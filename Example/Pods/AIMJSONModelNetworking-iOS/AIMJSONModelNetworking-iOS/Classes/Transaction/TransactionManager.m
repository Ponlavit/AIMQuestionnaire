//
//  TransactionManager.m
//  SaleWorkFlow
//
//  Created by Ponlavit Larpeampaisarl on 4/28/2558 BE.
//  Copyright (c) 2558 com.arsoft. All rights reserved.
//

#import "TransactionManager.h"
#import "NSString+EncoderUTF8.h"
#import "GCDSingleton.h"
#import "BaseModel.h"
#import <AFNetworking/AFNetworking.h>
#import "UpdateRequestObject.h"

#define APP_ID @"SWF"
#define RUN_EVERY_X_SEC 10

@implementation TransactionManager

+ (id)defaultManager{
    SINGLETON(^{
        return [[self alloc] init];
    });
}

- (NSManagedObjectContext *)managedObjectContext {
    if (!_managedObjectContext) {
        NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
        if (coordinator != nil) {
            _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
            [_managedObjectContext setPersistentStoreCoordinator:coordinator];
            [_managedObjectContext setUndoManager:nil];
        }
    }
    return _managedObjectContext;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator == nil) {
        NSURL *storeUrl = [NSURL fileURLWithPath:self.persistentStorePath];
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[NSManagedObjectModel mergedModelFromBundles:nil]];

        NSError *error = nil;
        
        
        NSAssert3([_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error] != nil, @"Unhandled error adding persistent store in %s at line %d: %@", __FUNCTION__, __LINE__, [error localizedDescription]);
    }
    return _persistentStoreCoordinator;
}

- (NSString *)persistentStorePath {
    if (_persistentStorePath == nil) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = (NSString*)[paths lastObject];
        _persistentStorePath = [documentsDirectory stringByAppendingPathComponent:@"transaction.sqlite"];
    }
    return _persistentStorePath;
}

-(void)addNewTransactionFromObject:(BaseModel*)model withTargetURL:(NSString*)urlString andToken:(NSString*)token error:(NSError*)error{
    if (!error) {
        error = [[NSError alloc]init];
    }
    
    UpdateRequestObject *updateReqObject = (UpdateRequestObject*)model;
    NSString *message = [model toJSONString];
    
    if (!urlString || [urlString isEqualToString:@""]){
        return;
    }
    if ([updateReqObject.target isEqualToString:@""] || [updateReqObject.module isEqualToString:@""]) {
        return;
    }
    
    Transaction *tran = [NSEntityDescription insertNewObjectForEntityForName:@"Transaction" inManagedObjectContext:self.managedObjectContext];
    tran.is_success = [NSNumber numberWithBool:NO];
    tran.json_message = message;
    tran.token = token;
    tran.failed_count = 0;
    tran.target_url = urlString;
    tran.target = updateReqObject.target;
    tran.module = updateReqObject.module;
    tran.sent_date = updateReqObject.updatedate;
    
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Add Transaction ERROR:%@", [error localizedDescription]);
    }
}

-(void)startService{
    if (!self.uploadTimer && ![self.uploadTimer isValid]) {
        self.uploadTimer = [NSTimer scheduledTimerWithTimeInterval:RUN_EVERY_X_SEC target:self selector:@selector(runUpload) userInfo:nil repeats:YES];
        [self.uploadTimer fire];
    }
}

- (void)postUpload:(Transaction *)tran {
    @synchronized(self){
        NSString *message = [[tran json_message] escapedUnicode];
        NSString *url = [NSString stringWithFormat:@"%@",[tran target_url]]; 
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        NSDictionary *params = @{KEY_PARAM_JSON_HTTP_REQUEST:message};
        NSLog(@"==== POST JSON with Message ====\n%@\n===== END POST JSON with Message ====",[tran json_message]);

        AFURLSessionManager *sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:nil];
        sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];

        NSMutableURLRequest *urlRequest = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:params error:nil];

        NSURLSessionDataTask *dataTask = [sessionManager dataTaskWithRequest:urlRequest completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {

            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;

            if (!error) {
                TransactionResponse *resp = [NSEntityDescription insertNewObjectForEntityForName:@"TransactionResponse" inManagedObjectContext:self.managedObjectContext];
                [resp setResponse_message:[responseObject description]];
                [resp setStatus:[NSNumber numberWithInteger:httpResponse.statusCode]];

                [tran addResponsesObject:resp];
                [tran setIs_success:[NSNumber numberWithBool:YES]];

                NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];

                NSLog(@"=  success with code: %ld\n=  desc: %@\n=  url: %@",(long)httpResponse.statusCode,[result debugDescription],url);

                NSError *error;
                if (![self.managedObjectContext save:&error]) {
                    NSLog(@"Update TransactionResponse ERROR:%@", [error localizedDescription]);
                }
            }
            else{
                TransactionResponse *resp = [NSEntityDescription insertNewObjectForEntityForName:@"TransactionResponse" inManagedObjectContext:self.managedObjectContext];
                [resp setResponse_message:[error localizedDescription]];
                [resp setStatus:[NSNumber numberWithInteger:httpResponse.statusCode]];

                [tran addResponsesObject:resp];
                [tran setFailed_count:[NSNumber numberWithInt:[tran.failed_count intValue]+1]];

                NSError *dbError;
                if (![self.managedObjectContext save:&dbError]) {
                    NSLog(@"Whoops, couldn't save: %@", [dbError localizedDescription]);
                }
            }

        }];
        [dataTask resume];
    }
}

-(void)runUpload{
    // Upload by getting from db Transaction
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Transaction" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    NSPredicate *successPredicate = [NSPredicate predicateWithFormat:@"is_success == %@",[NSNumber numberWithBool:NO]];
    [request setPredicate:successPredicate];
    NSError *error;
    NSArray *transactionList = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (transactionList) {
        for (Transaction *tran in transactionList) {
            [self postUpload:tran];
        }
    }
}

- (NSArray<NSManagedObject*>*)getTransaction{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"is_success == %@", [NSNumber numberWithBool:NO]];
    NSEntityDescription *TransactionEntity  = [NSEntityDescription entityForName:@"Transaction" inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:TransactionEntity];
    [fetchRequest setPredicate:predicate];
    
    NSArray<NSManagedObject*> *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    if ([result count] > 0) {
        return result;
    }
    else{
        if (MOCK_DATA) {
            return [self mockData];
        }
        else{
            return [NSArray array];
        }
    }
}

- (NSArray<NSManagedObject*>*)mockData{
    NSManagedObject *newData = [NSEntityDescription insertNewObjectForEntityForName:@"Transaction" inManagedObjectContext:self.managedObjectContext];
    [newData setValue:[NSDate date] forKey:@"added_date"];
    [newData setValue:@3 forKey:@"failed_count"];
    [newData setValue:[NSNumber numberWithBool:NO] forKey:@"is_success"];
    [newData setValue:@"{'status':'success'}" forKey:@"json_message"];
    [newData setValue:[NSDate date] forKey:@"sent_date"];
    [newData setValue:@"http://1" forKey:@"target_url"];
    [newData setValue:@"a1qwewqewqq335acdgd" forKey:@"token"];
    [newData setValue:@"Update activity" forKey:@"target"];
    [newData setValue:@"OPM" forKey:@"module"];
    
    NSManagedObject *newData2 = [NSEntityDescription insertNewObjectForEntityForName:@"Transaction" inManagedObjectContext:self.managedObjectContext];
    [newData2 setValue:[NSDate date] forKey:@"added_date"];
    [newData2 setValue:@5 forKey:@"failed_count"];
    [newData2 setValue:[NSNumber numberWithBool:NO] forKey:@"is_success"];
    [newData2 setValue:@"{'status':'success'}" forKey:@"json_message"];
    [newData2 setValue:[NSDate date] forKey:@"sent_date"];
    [newData2 setValue:@"http://2" forKey:@"target_url"];
    [newData2 setValue:@"a2qwewqewqq335acdgd" forKey:@"token"];
    [newData2 setValue:@"Update activity" forKey:@"target"];
    [newData2 setValue:@"WLM" forKey:@"module"];
    
    NSManagedObject *newData3 = [NSEntityDescription insertNewObjectForEntityForName:@"Transaction" inManagedObjectContext:self.managedObjectContext];
    [newData3 setValue:[NSDate date] forKey:@"added_date"];
    [newData3 setValue:@5 forKey:@"failed_count"];
    [newData3 setValue:[NSNumber numberWithBool:NO] forKey:@"is_success"];
    [newData3 setValue:@"{'status':'success'}" forKey:@"json_message"];
    [newData3 setValue:[NSDate date] forKey:@"sent_date"];
    [newData3 setValue:@"http://3" forKey:@"target_url"];
    [newData3 setValue:@"a3qwewqewqq335acdgd" forKey:@"token"];
    [newData3 setValue:@"Update activity" forKey:@"target"];
    [newData3 setValue:@"OPM" forKey:@"module"];
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [result addObject:newData];
    [result addObject:newData2];
    [result addObject:newData3];
    
    return result;
}

@end
