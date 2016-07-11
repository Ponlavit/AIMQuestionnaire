//
//  RestJSON.m
//  SaleWorkFlow
//
//  Created by Ponlavit Larpeampaisarl on 4/23/2558 BE.
//  Copyright (c) 2558 com.arsoft. All rights reserved.
//

#import "RestJSONWebServiceManager.h"
#import <AFNetworking/AFNetworking.h>
#import "RAWSManager.h"

#define KEY_RESULT @"entries"

@implementation RestJSONWebServiceManager

#pragma mark - Fetch Object
+(void)fetchJSONObjectOfClass:(Class)className formURL:(NSString *)url withParameters:(id)parameters success:(void (^)(NSNumber *, BaseModel *, id))success failure:(void (^)(NSNumber *, NSError *))failure{
    
    AFURLSessionManager *sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:nil];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableURLRequest *urlRequest = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:parameters error:nil];
    
    NSURLSessionDataTask *dataTask = [sessionManager dataTaskWithRequest:urlRequest completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        if (!error) {
            id newClass = [BaseModel initWithJSONData:responseObject forClass:className];
            NSNumber *statusCode = [NSNumber numberWithInteger:httpResponse.statusCode];
            success(statusCode,newClass,responseObject);
        }
        else{
            NSNumber *statusCode = [NSNumber numberWithInteger:httpResponse.statusCode];
            failure(statusCode,error);
        }
        
    }];
    [dataTask resume];
}

#pragma mark - Update Object
+(void)updateJSONObject:(BaseModel*)object
                fromURL:(NSString*)url
         withParameters:(id)parameters
                success:(void (^)(NSNumber *statusCode, BaseModel* obj))success
                failure:(void (^)(NSNumber *statusCode, NSError *error))failure
           updatePolicy:(UpdatePolicy)policy{
    
    AFURLSessionManager *sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:nil];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableURLRequest *urlRequest = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:parameters error:nil];
    
    NSURLSessionDataTask *dataTask = [sessionManager dataTaskWithRequest:urlRequest completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                BaseModel *newObject = [BaseModel initWithJSONData:responseObject forClass:object.class];
                BaseModel *oldObject = object;
                if(policy == UpdatePolicy_UseNewest){
                    if([oldObject isOlder:newObject]){
                        success([NSNumber numberWithInteger:httpResponse.statusCode],newObject);
                    }
                }
                else if (policy == UpdatePolicy_ForceUpdate){
                    success([NSNumber numberWithInteger:httpResponse.statusCode],newObject);
                }
            });
        }
        else{
            NSNumber *statusCode = [NSNumber numberWithInteger:httpResponse.statusCode];
            failure(statusCode,error);
        }
        
    }];
    [dataTask resume];
}

#pragma mark - Array Operation

+ (NSMutableArray*)mergeBaseModelArray:(NSMutableArray *)oldArray newArray:(NSMutableArray *)newArray
{
    for (int i = 0; i < newArray.count; i++) {
        for (int j = 0; j < oldArray.count; j++) {
            
            BaseModel *newObj = [newArray objectAtIndex:i];
            BaseModel *oldObj = [oldArray objectAtIndex:j];
            
            if ([newObj isSame:oldObj]) {
                if ([oldObj isNewer:newObj]) {
                    [newArray replaceObjectAtIndex:i withObject:oldObj];
                    break;
                }
            }
        }
    }
    return newArray;
}


#pragma mark - Update Array of BaseModel

+(void)updateJSONObjectArray:(NSMutableArray*)objectArray
                     ofClass:(Class)className
                     fromURL:(NSString*)url
                      module:(NSString *)module
                  updatedate:(NSDate*)date
                      target:(NSString *)target
              withParameters:(id)parameters
                     success:(void (^)(NSNumber *, id))success
                     failure:(void (^)(NSNumber *, NSError *))failure
                updatePolicy:(UpdatePolicy)policy
{
    
    [RestJSONWebServiceManager updateJSONObjectArray:objectArray ofClass:className fromURL:url module:module updatedate:date target:target keyword:nil withParameters:parameters success:success failure:failure updatePolicy:policy];
}


+(void)updateJSONObjectArray:(NSMutableArray*)objectArray
                     ofClass:(Class)className
                     fromURL:(NSString*)url
                      module:(NSString *)module
                  updatedate:(NSDate*)date
                      target:(NSString *)target
                     keyword:(NSString*)keyword
              withParameters:(id)parameters
                     success:(void (^)(NSNumber *, id))success
                     failure:(void (^)(NSNumber *, NSError *))failure
                updatePolicy:(UpdatePolicy)policy
{
    [RAWSManager searchRequestActionWithKeyword:keyword target:target andModule:module updatedate:date url:url limit:0  offset:0 success:^(NSHTTPURLResponse *httpResponse, id responseObject, NSString *message) {
        NSError *error;
        
        NSDictionary *result = [self getResultFromDataJSONData:responseObject error:&error];
        NSNumber *statusCode = [NSNumber numberWithInteger:httpResponse.statusCode];
        
        if (error) {
            failure(statusCode,error);
            return;
        }
        
        NSMutableArray *newArray = [RestJSONWebServiceManager parseJSONDictionary:result asArrayOfClass:className];
        NSMutableArray *oldArray = objectArray;
        
        if (policy == UpdatePolicy_ForceUpdate) {
            [oldArray removeAllObjects];
            [oldArray arrayByAddingObjectsFromArray:newArray];
        }
        else if (policy == UpdatePolicy_UseNewest){
            NSMutableArray *mergeArray = [RestJSONWebServiceManager mergeBaseModelArray:oldArray newArray:newArray];
            [oldArray removeAllObjects];
            [oldArray addObjectsFromArray:mergeArray];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            success(statusCode,responseObject);
        });
    } failure:^(NSString *errorCode, NSString *errorMessage) {
        failure([NSNumber numberWithInteger:[errorCode integerValue]],[NSError errorWithDomain:NSStringFromClass(className) code:[errorCode integerValue] userInfo:@{@"errorMessage":errorMessage}]);
    }];
}


#pragma mark - Fetch Array of BaseModel

+(void)fetchJSONArrayOfClass:(Class)className
                     fromURL:(NSString*)url
                      module:(NSString *)module
                  updatedate:(NSDate*)date
                      target:(NSString *)target
              withParameters:(id)parameters
                     success:(void (^)(NSNumber *, NSMutableArray *, id))success
                     failure:(void (^)(NSNumber *, NSError *))failure{
    [self fetchJSONArrayOfClass:className fromURL:url module:module updatedate:date target:target keyword:nil withParameters:parameters success:success failure:failure];
}

+(void)fetchJSONArrayOfClass:(Class)className
                     fromURL:(NSString*)url
                      module:(NSString *)module
                  updatedate:(NSDate*)date
                      target:(NSString *)target
                     keyword:(NSString *)keyword
              withParameters:(id)parameters
                     success:(void (^)(NSNumber *, NSMutableArray *, id))success
                     failure:(void (^)(NSNumber *, NSError *))failure{
    
    [RAWSManager searchRequestActionWithKeyword:keyword target:target andModule:module updatedate:date url:url limit:0 offset:0 success:^(NSHTTPURLResponse *httpResponse, id responseObject, NSString *message) {
        
        NSError *error;
        NSDictionary *result = [self getResultFromDataJSONData:responseObject error:&error];
        
        NSNumber *statusCode = [NSNumber numberWithInteger:httpResponse.statusCode];
        
        if (error) {
            failure(statusCode,error);
            return;
        }
        NSMutableArray *arrResult = [RestJSONWebServiceManager parseJSONDictionary:result asArrayOfClass:className];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            success(statusCode,arrResult,result);
        });
    } failure:^(NSString *errorCode, NSString *errorMessage) {
        failure([NSNumber numberWithInteger:[errorCode integerValue]],[NSError errorWithDomain:NSStringFromClass(className) code:[errorCode integerValue] userInfo:@{@"errorMessage":errorMessage}]);
    }];
}

#pragma mark - JSON Parse

+(NSDictionary*)getResultFromDataJSONData:(NSData*)responseObject error:(NSError**)error{
    return [NSJSONSerialization
            JSONObjectWithData:responseObject
            options:NSJSONReadingMutableContainers
            error:error];
}

+(NSMutableArray*)parseJSONDictionary:(NSDictionary*)result asArrayOfClass:(Class)className{
    id(^createAndAddObj)(NSDictionary*) = ^(NSDictionary *dic) {
        NSError *error =nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
        id newClass = [BaseModel initWithJSONData:jsonData forClass:className];
        return newClass;
    };
    
    id entries;
    if([result objectForKey:KEY_RESULT]) entries =[result objectForKey:KEY_RESULT];
    else entries = result;
    
    if([entries isKindOfClass:[NSMutableArray class]]){
        NSMutableArray *array = [NSMutableArray array];
        for (id object in entries) {
            [array addObject:createAndAddObj(object)];
        }
        return  array;
    }
    else if ([entries isKindOfClass:[NSMutableDictionary class]]){
        return  createAndAddObj(entries);
    }
    return nil;
}

+(NSMutableArray*)parseJSONData:(NSData*)data asArrayOfClass:(Class)className{
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    return [self parseJSONDictionary:result asArrayOfClass:className];
}

+(NSMutableArray*)parseJSONArray:(NSArray*)array asArrayOfClass:(Class)className{
    NSMutableArray *objArray = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [objArray addObject:[self parseJSONDictionary:dict asArrayOfClass:className]];
    }
    return objArray;
}
@end
