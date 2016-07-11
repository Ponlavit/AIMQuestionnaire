//
//  RestJSONWebServiceManager.h
//  SaleWorkFlow
//
//  Created by Ponlavit Larpeampaisarl on 4/23/2558 BE.
//  Copyright (c) 2558 com.arsoft. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "BaseModel.h"



typedef enum : NSUInteger {
    UpdatePolicy_ForceUpdate,
    UpdatePolicy_UseNewest,
} UpdatePolicy;


@interface RestJSONWebServiceManager : NSObject

// fetch Object
+(void)fetchJSONObjectOfClass:(Class)className
                      formURL:(NSString*)url
               withParameters:(id)parameters
                      success:(void (^)(NSNumber *statusCode, BaseModel *result, id responseObject))success
                      failure:(void (^)(NSNumber *statusCode, NSError *error))failure;
// Update Object
+(void)updateJSONObject:(BaseModel*)object
                fromURL:(NSString*)url
         withParameters:(id)parameters
                success:(void (^)(NSNumber *statusCode, BaseModel *object))success
                failure:(void (^)(NSNumber *statusCode, NSError *error))failure
           updatePolicy:(UpdatePolicy)policy;

// fetch Array
+(void)fetchJSONArrayOfClass:(Class)className
                     fromURL:(NSString*)url
                      module:(NSString*)module
                  updatedate:(NSDate*)date
                      target:(NSString*)target
              withParameters:(id)parameters
                     success:(void (^)(NSNumber *statusCode, NSMutableArray *result, id responseObject))success
                     failure:(void (^)(NSNumber *statusCode, NSError *error))failure;

+(void)fetchJSONArrayOfClass:(Class)className
                     fromURL:(NSString*)url
                      module:(NSString*)module
                  updatedate:(NSDate*)date
                      target:(NSString*)target
                     keyword:(NSString*)keyword
              withParameters:(id)parameters
                     success:(void (^)(NSNumber *statusCode, NSMutableArray *result, id responseObject))success
                     failure:(void (^)(NSNumber *statusCode, NSError *error))failure;

// Update Array
+(void)updateJSONObjectArray:(NSMutableArray*)objectArray
                     ofClass:(Class)className
                     fromURL:(NSString*)url
                      module:(NSString*)module
                  updatedate:(NSDate*)date
                      target:(NSString*)target
              withParameters:(id)parameters
                     success:(void (^)(NSNumber *statusCode, id responseData))success
                     failure:(void (^)(NSNumber *statusCode, NSError *error))failure
                updatePolicy:(UpdatePolicy)policy;
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
                updatePolicy:(UpdatePolicy)policy;

+(NSMutableArray*)parseJSONArray:(NSArray*)array asArrayOfClass:(Class)className;
+(NSMutableArray*)parseJSONDictionary:(NSDictionary*)result asArrayOfClass:(Class)className;
+(NSMutableArray*)parseJSONData:(NSData*)data asArrayOfClass:(Class)className;
@end
