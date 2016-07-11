    //
    //  User.m
    //  SaleWorkFlow
    //
    //  Created by Ponlavit Larpeampaisarl on 5/14/2558 BE.
    //  Copyright (c) 2558 com.arsoft. All rights reserved.
    //

#import "User.h"
#import "NSString+EncoderUTF8.h"
#import <AFNetworking/AFNetworking.h>
#import <EGOCache/EGOCache.h>
#import "SWConfiguration.h"

#define USER_CACHE_KEY @"USERSAVEXXNS"

#define RESPONSE_STATUS_CODE_INTERNET_PROBLEM @"100"
#define RESPONSE_STATUS_CODE_SUCCESS @"200"
#define RESPONSE_STATUS_CODE_AUTHENTICATION_FAILED @"401"
#define RESPONSE_STATUS_CODE_APPLICATION_VERSION @"400"

@interface User()
@property (nonatomic,strong) NSString *loginServiceURL;
@end

@implementation User
+ (id)currentUser{
    SINGLETON(^{
        User *user = (User*)[[EGOCache globalCache] objectForKey:USER_CACHE_KEY];
        if (user) {
            return user;
        }
        user = [[self alloc] init];
        user.isLogin = NO;
        return user;
    });
}

- (BOOL)registerWithRequest:(AuthenticationRequest *)request
                    success:(void (^)(User *user))success
                    failure:(void (^)(NSString *status, NSString *message))failure
{
    if (!request) {
        return NO;
    }
    request.action = @"register";
    return YES;
}

- (void)submitRequest:(AuthenticationRequest *)request failure:(void (^)(NSString *, NSString *))failure success:(void (^)(User *))success numberOfDayCache:(int)numberOfDayCache isCache:(BOOL)isCache
{
    NSAssert(!self.isLogin,
             @"User have been initial please logout before initial another login");
    NSString *json = request.toJSONString.escapedUnicode;
    NSDictionary *params = @{KEY_PARAM_JSON_HTTP_REQUEST:json};
    
    AFURLSessionManager *sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:nil];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableURLRequest *urlRequest = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:self.loginServiceURL parameters:params error:nil];
    
    NSURLSessionDataTask *dataTask = [sessionManager dataTaskWithRequest:urlRequest completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSString *status = [result objectForKey:KEY_RESPONSE_STATUS];
            NSString *message = [result objectForKey:KEY_RESPONSE_MESSAGE];
            
            if ([status longLongValue]==200) {
                
                //NSLog(@"--> JSON: %@", result);
                [self updateWithJSONData:responseObject];
                self.isLogin = YES;
                [[EGOCache globalCache] setObject:self forKey:USER_CACHE_KEY withTimeoutInterval:isCache?DAY*numberOfDayCache:0];
                
                
                success(self);
            }
            else {
                failure(status, [NSString stringWithFormat:@"%@", message]);
                //NSLog(@"--> NO");
            }
        }
        else{
            failure(RESPONSE_STATUS_CODE_INTERNET_PROBLEM, [error localizedDescription]);
        }
        
    }];
    [dataTask resume];
}

- (BOOL)loginWithRequest:(AuthenticationRequest *)request
                 success:(void (^)(User *user))success
                 failure:(void (^)(NSString *status, NSString *message))failure
                 isCache:(BOOL)isCache
      cacheDurationInDay:(int)numberOfDayCache {

    if (!request) {
        return NO;
    }
    request.action = @"login";
    [self submitRequest:request failure:failure success:success numberOfDayCache:numberOfDayCache isCache:isCache];
    return YES;
}

- (void)registerLoginServiceWithURL:(NSString*)url{
    if (self.loginServiceURL && ![self.loginServiceURL isEqualToString:url]) {
        [self logout];
    }
    self.loginServiceURL = url;
}

-(void)setRole:(NSString *)role{
    if (![role isKindOfClass:[NSString class]]) {
        _role = [role description];
    }
    else{
        _role = role;
    }
}

- (void)logout{
    self.u_id = nil;
    self.token = nil;
    self.name = nil;
    self.role = nil;
    self.allow_module = nil;
    self.isLogin = NO;
    [[EGOCache globalCache] removeCacheForKey:USER_CACHE_KEY];
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.u_id forKey:@"u_id"];
    [aCoder encodeObject:self.token forKey:@"tk_value"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.role forKey:@"role"];
    [aCoder encodeObject:self.allow_module forKey:@"allow_module"];
    [aCoder encodeObject:self.allow_service forKey:@"allow_service"];
    [aCoder encodeObject:self.webapi forKey:@"webapi"];

    [aCoder encodeBool:self.isLogin forKey:@"isLogin"];
    [aCoder encodeObject:self.loginServiceURL forKey:@"loginServiceURL"];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.loginServiceURL = [aDecoder decodeObjectForKey:@"loginServiceURL"];
        self.u_id = [aDecoder decodeObjectForKey:@"u_id"];
        self.token = [aDecoder decodeObjectForKey:@"tk_value"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.role = [aDecoder decodeObjectForKey:@"role"];
        self.allow_module = [aDecoder decodeObjectForKey:@"allow_module"];
        self.allow_service = [aDecoder decodeObjectForKey:@"allow_service"];
        self.webapi = [aDecoder decodeObjectForKey:@"webapi"];
        
        self.isLogin = [aDecoder decodeBoolForKey:@"isLogin"];
    }
    return self;
}

@end
