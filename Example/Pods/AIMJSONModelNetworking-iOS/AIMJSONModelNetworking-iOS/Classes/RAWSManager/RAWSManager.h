//
//  RAWSManager.h
//  SaleWorkFlow
//
//  Created by Ponlavit Larpeampaisarl on 5/13/2558 BE.
//  Copyright (c) 2558 com.arsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDSingleton.h"
#import "BaseModel.h"
#import "NSString+EncoderUTF8.h"
#import <AFNetworking/AFNetworking.h>

@interface RAWSManager : NSObject
+ (id)defaultManager;

- (void)regiesterAddServiceWithURL:(NSString*)url;
- (void)regiesterDeleteServiceWithURL:(NSString*)url;
- (void)regiesterUpdateServiceWithURL:(NSString*)url;
- (void)regiesterSearchServiceWithURL:(NSString*)url;
- (void)regiesterImageServiceWithURL:(NSString*)url;

+ (BOOL)addRequestActionWithObject:(BaseModel*)object
                        withTarget:(NSString*)target
                         andModule:(NSString*) module
                        updatedate:(NSDate*)updatedate
                               url:(NSString*)customURL
                           success:(void (^)(NSHTTPURLResponse *httpResponse,id responseObject, NSString *message))success
                           failure:(void (^)(NSString *errorCode, NSString *errorMessage))failure;
+ (BOOL)uploadImage:(UIImage*)anImage imageRequestActionWithKey:(NSString*)key fileName:(NSString*)fileName progressDelegate:(void (^)(NSProgress *uploadProgress)) uploadProgressBlock success:(void (^)(NSHTTPURLResponse *httpResponse, id responseObject))success failure:(void (^)(NSHTTPURLResponse *operation, id responseObject, NSError *error))failure;

+ (BOOL)searchRequestActionWithKeyword:(NSString*)keyword
                                target:(NSString*)target
                             andModule:(NSString*)module
                            updatedate:(NSDate*)updatedate
                                   url:(NSString*)customURL
                                 limit:(int)limit
                                offset:(int)offset
                               success:(void (^)(NSHTTPURLResponse *httpResponse,id responseObject, NSString *message))success
                               failure:(void (^)(NSString *errorCode, NSString *errorMessage))failure;
+ (BOOL)deleteRequestActionWithObjectId:(NSString*)objectId
                             withTarget:(NSString*)target
                              andModule:(NSString*) module
                             updatedate:(NSDate*)updatedate
                                    url:(NSString*)customURL
                                success:(void (^)(NSHTTPURLResponse *httpResponse,id responseObject, NSString *message))success
                                failure:(void (^)(NSString *errorCode, NSString *errorMessage))failure;
+ (BOOL)updateRequestActionWithObject:(BaseModel*)object
                             uniqueId:(NSString*)objectId
                           withTarget:(NSString*)target
                            andModule:(NSString*)module
                           updatedate:(NSDate*)updatedate
                                  url:(NSString*)customURL;

@end
