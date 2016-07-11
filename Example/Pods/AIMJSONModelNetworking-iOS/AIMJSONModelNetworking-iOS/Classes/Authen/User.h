//
//  User.h
//  SaleWorkFlow
//
//  Created by Ponlavit Larpeampaisarl on 5/14/2558 BE.
//  Copyright (c) 2558 com.arsoft. All rights reserved.
//

#import "BaseModel.h"
#import "GCDSingleton.h"
#import "Permission.h"
#import "AuthenticationRequest.h"
#import "SWConfiguration.h"
#import "ServiceURL.h"
@interface User : BaseModel <NSCoding>
@property (nonatomic,strong) NSString *u_id;
@property (nonatomic,strong) NSString *token;
@property (nonatomic,strong) NSString *name;
@property (nonatomic) BOOL isLogin;
@property (nonatomic,strong) NSString *role;
@property (nonatomic,strong) NSMutableArray *allow_module;
@property (nonatomic,strong) NSMutableArray *allow_service;
Prop_MArray(ServiceURL,webapi);

+ (id)currentUser;
- (BOOL)loginWithRequest:(AuthenticationRequest *)request
                 success:(void (^)(User *user))success
                 failure:(void (^)(NSString *status, NSString *message))failure
                 isCache:(BOOL)isCache
      cacheDurationInDay:(int)numberOfDayCache;
- (void)registerLoginServiceWithURL:(NSString*)url;
- (void)logout;
@end
