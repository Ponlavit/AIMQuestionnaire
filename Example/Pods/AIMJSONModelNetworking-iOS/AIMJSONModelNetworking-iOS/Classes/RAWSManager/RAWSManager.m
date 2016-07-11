//
//  RAWSManager.m
//  SaleWorkFlow
//
//  Created by Ponlavit Larpeampaisarl on 5/13/2558 BE.
//  Copyright (c) 2558 com.arsoft. All rights reserved.
//

#import "RAWSManager.h"
#import "BaseModel.h"
#import "SearchRequestObject.h"
#import "UpdateRequestObject.h"
#import "DeleteRequestObject.h"
#import "AddRequestObject.h"
#import "TransactionManager.h"
#import "User.h"

#define RESPONSE_STATUS_CODE_INTERNET_PROBLEM @"100"
#define RESPONSE_STATUS_CODE_SUCCESS @"200"
#define RESPONSE_STATUS_CODE_AUTHENTICATION_FAILED @"401"
#define RESPONSE_STATUS_CODE_TARGET_MISMATCH @"404"
#define RESPONSE_STATUS_CODE_SERVER_ERROR @"500"

@interface RAWSManager ()
@property (nonatomic,strong) NSString *addServiceUrl;
@property (nonatomic,strong) NSString *updateServiceUrl;
@property (nonatomic,strong) NSString *deleteServiceUrl;
@property (nonatomic,strong) NSString *searchServiceUrl;
@property (nonatomic,strong) NSString *imageServiceUrl;
@end

@implementation RAWSManager

+ (id)defaultManager{
    SINGLETON(^{
        return [[self alloc] init];
    });
}

- (void)regiesterAddServiceWithURL:(NSString*)url{
    self.addServiceUrl = url;
}

- (void)regiesterDeleteServiceWithURL:(NSString*)url{
    self.deleteServiceUrl = url;
}

- (void)regiesterUpdateServiceWithURL:(NSString*)url{
    self.updateServiceUrl = url;
}

- (void)regiesterSearchServiceWithURL:(NSString*)url{
    self.searchServiceUrl = url;
}

- (void)regiesterImageServiceWithURL:(NSString*)url{
    self.imageServiceUrl = url;
}

+ (NSString*)getToken{
    return [[User currentUser] token];
//    return  [[User currentUser] token]?[[User currentUser] token]:@"PLTPNPAT";
}

+ (BOOL)updateRequestActionWithObject:(BaseModel *)object uniqueId:(NSString *)objectId withTarget:(NSString *)target andModule:(NSString *)module updatedate:(NSDate*)updatedate url:(NSString *)customURL{
    if (!object || !target || !module || !objectId) {
        return NO;
    }

    // Initial Setup object
    object.updatedate = [NSDate date];

    UpdateRequestObject *updateObj = [[UpdateRequestObject alloc] init];
    updateObj.data = object.toJSONString;
    updateObj.objectId = objectId;
    updateObj.target = target;
    updateObj.module = module;
    updateObj.token = [self getToken];
    updateObj.updatedate = updatedate;
    updateObj.unique_id = (long)[objectId longLongValue];
    
    [[TransactionManager defaultManager] addNewTransactionFromObject:updateObj withTargetURL:customURL?customURL:[[RAWSManager defaultManager] updateServiceUrl] andToken:[[User currentUser] token] error:nil];
    [[TransactionManager defaultManager] startService];
    return YES;
}


+ (BOOL)addRequestActionWithObject:(BaseModel*)object
                        withTarget:(NSString*)target
                         andModule:(NSString*) module
                        updatedate:(NSDate*)updatedate
                               url:(NSString*)customURL
                           success:(void (^)(NSHTTPURLResponse *httpResponse,id responseObject, NSString *message))success
                           failure:(void (^)(NSString *errorCode, NSString *errorMessage))failure{
    if (!object || !target || !module) {
        return NO;
    }


    // Initial Setup object
    object.active_flag = YES;
    object.updatedate = [NSDate date];

    AddRequestObject *addObj = [[AddRequestObject alloc] init];
    addObj.data = object.toJSONString;
    addObj.target = target;
    addObj.module = module;
    addObj.token = [self getToken];
    addObj.updatedate = updatedate;

    NSString *url = customURL?customURL:[[RAWSManager defaultManager] addServiceUrl];
    NSString *jsonData = addObj.toJSONString.escapedUnicode;
    NSDictionary *params = @{KEY_PARAM_JSON_HTTP_REQUEST:jsonData};
    AFURLSessionManager *sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:nil];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableURLRequest *urlRequest = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:params error:nil];
    
    NSURLSessionDataTask *dataTask = [sessionManager dataTaskWithRequest:urlRequest completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        if (!error) {
            [self handleSuccessResponse:responseObject requestOperation:httpResponse failure:failure success:success];
        }
        else{
            failure(RESPONSE_STATUS_CODE_INTERNET_PROBLEM, [error localizedDescription]);
        }
        
    }];
    [dataTask resume];
    
    return YES;
}

+ (BOOL)deleteRequestActionWithObjectId:(NSString *)objectId withTarget:(NSString *)target andModule:(NSString *)module updatedate:(NSDate*)updatedate url:(NSString *)customURL success:(void (^)(NSHTTPURLResponse *, id, NSString *))success failure:(void (^)(NSString *, NSString *))failure{
    
    if (!objectId || !target || !module) {
        return NO;
    }

    DeleteRequestObject *delObj = [[DeleteRequestObject alloc] init];
    delObj.objectId = objectId;
    delObj.target = target;
    delObj.module = module;
    delObj.token = [self getToken];
    delObj.updatedate = updatedate;
    
    NSString *url = customURL?customURL:[[RAWSManager defaultManager] deleteServiceUrl];
    NSDictionary *params = @{KEY_PARAM_JSON_HTTP_REQUEST:delObj.toJSONString.escapedUnicode};
    
    AFURLSessionManager *sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:nil];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableURLRequest *urlRequest = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:params error:nil];
    
    NSURLSessionDataTask *dataTask = [sessionManager dataTaskWithRequest:urlRequest completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        if (!error) {
            [self handleSuccessResponse:responseObject requestOperation:httpResponse failure:failure success:success];
        }
        else{
            failure(RESPONSE_STATUS_CODE_INTERNET_PROBLEM, [error localizedDescription]);
        }
        
    }];
    [dataTask resume];
    
    return YES;
}


+ (BOOL)uploadImage:(UIImage*)anImage imageRequestActionWithKey:(NSString*)key fileName:(NSString*)fileName progressDelegate:(void (^)(NSProgress *uploadProgress)) uploadProgressBlock success:(void (^)(NSHTTPURLResponse *httpResponse, id responseObject))success failure:(void (^)(NSHTTPURLResponse *operation, id responseObject, NSError *error))failure{
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableURLRequest *request =
    [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST"
                                     URLString:[[RAWSManager defaultManager] imageServiceUrl]
                                    parameters:nil
                     constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {

                         [formData appendPartWithFileData:UIImageJPEGRepresentation(anImage,0.3f)
                                                     name:@"image"
                                                 fileName:fileName
                                                 mimeType:@"image/jpeg"];
                         NSString *token = [[User currentUser] token];
                         NSData *userToken = [token dataUsingEncoding:NSUTF8StringEncoding];
                         [formData appendPartWithFormData:userToken name:@"token"];
                         NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
                         [formData appendPartWithFormData:keyData name:@"key"];

    } error:nil];

    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:uploadProgressBlock completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            NSLog(@"%@", response);
            
            NSError *error;
            NSJSONSerialization *jsonObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
            
            NSLog(@"%@", jsonObject);
            success(nil,responseObject);
        }
        else{
            NSLog(@"Error: %@", error);
        }
        
    }];
    [uploadTask resume];
    
    return YES;
}

+ (BOOL)searchRequestActionWithKeyword:(NSString *)keyword target:(NSString *)target andModule:(NSString *)module updatedate:(NSDate*)updatedate url:(NSString *)customURL limit:(int)limit offset:(int)offset success:(void (^)(NSHTTPURLResponse *, id, NSString *))success failure:(void (^)(NSString *, NSString *))failure{
    
    NSAssert(target, @"input value failed target");
    NSAssert(module, @"input value failed module");
    NSAssert(limit >= 0, @"input value failed limit");
    NSAssert(offset >= 0, @"input value failed offset");

    
    SearchRequestObject *sObj = [[SearchRequestObject alloc] init];
    sObj.target = target;
    sObj.limit = limit;
    sObj.module = module;
    sObj.keyword = keyword;
    sObj.offset = offset;
    sObj.token = [self getToken];
    sObj.updatedate = updatedate;
    
    NSString *json = sObj.toJSONString;
    NSString *encodedJSON = json.escapedUnicode;
    NSString *url = customURL?customURL:[[RAWSManager defaultManager] searchServiceUrl];
    NSDictionary *params = @{KEY_PARAM_JSON_HTTP_REQUEST:encodedJSON};
    
    AFURLSessionManager *sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:nil];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableURLRequest *urlRequest = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:params error:nil];
    
    NSURLSessionDataTask *dataTask = [sessionManager dataTaskWithRequest:urlRequest completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        if (!error) {
            NSString *data = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"Request Success %@:%@ \n%@",sObj.module,sObj.target,data);
            [self handleSuccessResponse:responseObject requestOperation:httpResponse failure:failure success:success];
        }
        else{
            NSLog(@"Request Failed %@:%@",sObj.module,sObj.target);
            failure(RESPONSE_STATUS_CODE_INTERNET_PROBLEM, [error localizedDescription]);
        }
        
    }];
    [dataTask resume];
    
    return YES;
}


+ (void)handleSuccessResponse:(id)responseObject requestOperation:(NSHTTPURLResponse *)httpResponse failure:(void (^)(NSString *, NSString *))failure success:(void (^)(NSHTTPURLResponse *,id, NSString *))success
{
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
    NSString *status = [result objectForKey:KEY_RESPONSE_STATUS];
    NSString *message = [result objectForKey:KEY_RESPONSE_MESSAGE];

    if ([status longLongValue] ==200) {
        success(httpResponse,responseObject, message);
    }
    else if ([status longLongValue] == 401) {
        failure(RESPONSE_STATUS_CODE_AUTHENTICATION_FAILED, message);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"logout" object:nil];
    }
    else if ([status longLongValue] == 404) {
        failure(RESPONSE_STATUS_CODE_TARGET_MISMATCH, message);
    }
    else if ([status longLongValue] == 400) {
        failure(RESPONSE_STATUS_CODE_TARGET_MISMATCH, message);
    }
    else if ([status longLongValue] == 500) {
        failure(RESPONSE_STATUS_CODE_SERVER_ERROR, message);
    }
    else{
        failure(RESPONSE_STATUS_CODE_SERVER_ERROR, message?message:@"nil");
    }
}

@end
