//
//  AuthenticationRequest.m
//  SaleWorkFlow
//
//  Created by Ponlavit Larpeampaisarl on 5/14/2558 BE.
//  Copyright (c) 2558 com.arsoft. All rights reserved.
//

#import "AuthenticationRequest.h"
#import "UIDevice+Extended.h"

@implementation AuthenticationRequest
-(id)initWithUsername:(NSString *)username password:(NSString*)password andAppName:(NSString*)appName version:(NSString*)appVersion{
    if (self = [super init]) {
        self.username = username;
        self.password = password;
        self.tk_app_name = appName;
        self.tk_app_version = appVersion;
        
        self.tk_device_name = [[UIDevice currentDevice] name];
        self.tk_mac_address = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        self.tk_device_model = [[UIDevice currentDevice] localizedModel];
        self.tk_emulator_version = [[UIDevice currentDevice] systemVersion];
        self.tk_device_owner = [[UIDevice currentDevice] name];
        self.tk_uid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        self.tk_os = [[UIDevice currentDevice] systemName];
    }
    return self;
}
@end
