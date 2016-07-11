//
//  AuthenticationRequest.h
//  SaleWorkFlow
//
//  Created by Ponlavit Larpeampaisarl on 5/14/2558 BE.
//  Copyright (c) 2558 com.arsoft. All rights reserved.
//

#import "BaseModel.h"

@interface AuthenticationRequest : BaseModel

@property (nonatomic, strong) NSString* tk_device_name;
@property (nonatomic, strong) NSString* tk_mac_address;
@property (nonatomic, strong) NSString* tk_device_model;
@property (nonatomic, strong) NSString* tk_app_version;
@property (nonatomic, strong) NSString* tk_emulator_version;
@property (nonatomic, strong) NSString* tk_device_owner;
@property (nonatomic, strong) NSString* tk_os;
@property (nonatomic, strong) NSString* tk_uid;
@property (nonatomic, strong) NSString* username;
@property (nonatomic, strong) NSString* password;
@property (nonatomic, strong) NSString* tk_app_name;
@property (nonatomic, strong) NSString* action;

-(id)initWithUsername:(NSString *)username password:(NSString*)password andAppName:(NSString*)appName version:(NSString*)appVersion;
@end
