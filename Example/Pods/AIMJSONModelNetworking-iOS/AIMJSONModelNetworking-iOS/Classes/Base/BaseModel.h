//
//  BaseModel.h
//  SaleWorkFlow
//
//  Created by Administartor on 2/5/15.
//  Copyright (c) 2015 Administartor. All rights reserved.
//  *** @property of Base Model Not Support NSMutableDictionary ***
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#import "ObjectiveCGenerics.h"

#define CLASS_STRING_NSMULTITABLEARRAY @"NSMutableArray"

#define skipPropertyName(n) [propNameString isEqualToString:n]
#define skipPropertyNameAnd(n) [propNameString isEqualToString:n] ||
#define startDefineSkipProperty - (BOOL)shouldSkipPropertyName:(const char *)propName{\
NSString *propNameString = [NSString stringWithUTF8String:propName];\
return [super shouldSkipPropertyName:propName] ||
#define endDefineSkipProperty }
#define saveListHandlerWithTag(tag) if([[cellDataSource tagCell] isEqualToString:tag])

GENERICSABLE(BaseModel)

@interface BaseModel : NSObject <BaseModel>
@property (nonatomic,strong) NSDate *updatedate;
@property (nonatomic) long long unique_id;
@property (nonatomic) BOOL active_flag;
- (NSMutableDictionary*)getObjectDictionary;
- (BOOL)isSame:(BaseModel*)objectToCheck;
- (BOOL)isOlder:(BaseModel*)objectToCheck;
- (BOOL)isNewer:(BaseModel*)objectToCheck;
- (BOOL)isSameKey:(long long)keyToCheck;
- (NSString*)toJSONString;
- (NSDate*)getLastUpdate;
- (NSString*)getSearchAbleString;
- (void)setUpValueWithData:(NSData*)data;
+ (id)initWithJSONString:(NSString*)jsonString forClass:(Class)class;
+ (id)initWithJSONData:(NSData*)jsonData forClass:(Class)class;
- (void)updateTimestamp;
- (NSString*)toString;
- (BOOL)shouldSkipPropertyName:(const char *)propName;
- (void)updateWithJSONString:(NSString*)jsonString;
- (void)updateWithJSONData:(NSData*)jsonData;
- (void)setUpValueWithString:(NSString*)jsonString;
-(void)customBindingValue:(NSDictionary*)result;
@end
