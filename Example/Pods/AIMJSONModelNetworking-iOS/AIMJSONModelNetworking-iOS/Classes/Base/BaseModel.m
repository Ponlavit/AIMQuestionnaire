//
//  BaseModel.m
//  SaleWorkFlow
//
//  Created by Administartor on 2/5/15.
//  Copyright (c) 2015 Administartor. All rights reserved.
//

#import "BaseModel.h"
#define KEY_RESULT @"entries"
#import "AFNetworking.h"
#import "NSObject+JSON.h"
#import <Foundation/NSObjCRuntime.h>

@interface BaseModel()
//dictionary key:property name array/dictionary ,value:class member ของแต่ละ property
@property (nonatomic,strong) NSMutableArray *classPropertiesArrayList;
@end

@implementation BaseModel

-(NSString *)getSearchAbleString{
    return @"";
}
-(NSMutableArray *)classPropertiesArrayList{
    if (!_classPropertiesArrayList) {
        _classPropertiesArrayList = [NSMutableArray array];
        objc_property_t *properties = NULL;
        
        unsigned int selfPropertyCount = 0;
        objc_property_t *selfProperties = class_copyPropertyList([self class], &selfPropertyCount);
        objc_property_t *superProperties = NULL;
        
        Class superClass = [self class];
        while (superClass != [NSObject class]) {
            unsigned int superPropertyCount;
            superProperties = class_copyPropertyList(superClass, &superPropertyCount);
            for (int i = 0; i < superPropertyCount; i++) {
                objc_property_t property = superProperties[i];
                const char *propName = property_getName(property);
                if ([self shouldSkipPropertyName:propName]) continue;
                NSString *key = [NSString stringWithCString:propName encoding:NSUTF8StringEncoding];
                [_classPropertiesArrayList addObject:key];
            }
            superClass = class_getSuperclass([superClass class]);
            free(superProperties);
        }
        
        if (superClass != [NSObject class]) {
            properties = selfProperties;
        }
        free(properties);
    }
    return _classPropertiesArrayList;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
}

- (id)initWithCoder:(NSCoder *)aDecoder{ // NS_DESIGNATED_INITIALIZER
    
    if(self=[super init]){
        
    }
    return self;
}

-(NSString *)toString{
    return [self description];
}

- (NSDate *)getLastUpdate{
    return self.updatedate;
}

- (void)updateTimestamp{
    self.updatedate = [NSDate date];
}

+ (id)initWithJSONData:(NSData*)jsonData forClass:(Class)class{
    BaseModel* bm = [[class alloc] init];
    [bm setUpValueWithData:jsonData];
    return bm;
}

+ (id)initWithJSONString:(NSString*)jsonString forClass:(Class)class {
    NSData* data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    return [BaseModel initWithJSONData:data forClass:class];
}

- (NSString*)getStingProtocalWithStringType:(NSString *)typeClassName{
  
    NSString *protocal =nil;
    
    if([typeClassName hasPrefix:CLASS_STRING_NSMULTITABLEARRAY]){
       
        NSArray * array = [typeClassName componentsSeparatedByString:@"<"];
        if([array count]>1){
            
            NSString *subString = [array objectAtIndex:1];
            array = [subString componentsSeparatedByString:@">"];
            
            if([array count]>0){
                protocal = [array objectAtIndex:0];
            }
        }
        
        return protocal;
    }
    
    return nil;
}

- (void)setUpValueWithData:(NSData*)data{
    id obj = self;
    id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    id entries = [result objectForKey:KEY_RESULT];
    if(entries) result = entries;
    unsigned int propertyCount, i;
    
    objc_property_t *properties = NULL;
    
    unsigned int selfPropertyCount;
    objc_property_t *selfProperties = class_copyPropertyList([self class], &selfPropertyCount);
    objc_property_t *superProperties = NULL;
    
    Class superClass = class_getSuperclass([self class]);
    if (superClass != [NSObject class]) {
        unsigned int superPropertyCount;
        superProperties = class_copyPropertyList(superClass, &superPropertyCount);
        
        properties = malloc((selfPropertyCount+superPropertyCount)*sizeof(objc_property_t));
        if (properties != NULL) {
            memcpy(properties, selfProperties, selfPropertyCount*sizeof(objc_property_t));
            memcpy(properties+selfPropertyCount, superProperties, superPropertyCount*sizeof(objc_property_t));
        }
        
        propertyCount = selfPropertyCount+superPropertyCount;
    }
    else {
        properties = selfProperties;
        propertyCount = selfPropertyCount;
    }

    
    for(i = 0; i < propertyCount; i++) {
        objc_property_t property = properties[i];
        
        const char *propName = property_getName(property);
        if(propName) {
            if ([self shouldSkipPropertyName:propName]){
                continue;
            }
            const char *propType = property_getAttributes(property);
            NSString *propertyName = [NSString stringWithCString:propName encoding:NSUTF8StringEncoding];
            NSString *typeString = [NSString stringWithUTF8String:propType];
            NSArray *attributes = [typeString componentsSeparatedByString:@","];
            NSString *typeAttribute = [attributes objectAtIndex:0];
            
            BOOL isObjectType = NO;
            
            if ([typeAttribute hasPrefix:@"T@"] && ![typeAttribute isEqualToString:@"T@"]) {
                NSString * typeClassName = [typeAttribute substringWithRange:NSMakeRange(3, [typeAttribute length]-4)];
                NSString *protocal =[self getStingProtocalWithStringType:typeClassName];
                if(protocal) typeClassName = CLASS_STRING_NSMULTITABLEARRAY;
                Class classType = NSClassFromString(typeClassName);
                
                if (classType) {
                    isObjectType =YES;
                    if([classType isSubclassOfClass:[BaseModel class]] ){
                        id value = [result objectForKey:propertyName];
                        if (!value || [value isKindOfClass:[NSNull class]]) {
                            [obj setValue:nil forKey:propertyName];
                            continue;
                        }
                        NSError *error =nil;
                        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:value options:NSJSONWritingPrettyPrinted error:&error];

                        id newClass = [[classType alloc] init];
                        [newClass setUpValueWithData:jsonData];
                        [obj setValue:newClass forKey:propertyName];
                    }
                    else if([classType isSubclassOfClass:[NSMutableDictionary class]]){
                        continue;
                      
                    }
                    else if([classType isSubclassOfClass:[NSMutableArray class]]){
                        id value = [result objectForKey:propertyName];
                        if ([(NSObject*)value isKindOfClass:[NSNull class]]) {
                            continue;
                        }
                        Class className = NSClassFromString(protocal);
                        NSMutableArray *array = [NSMutableArray array];
                        for (id subObj in value) {
                            if([className isSubclassOfClass:[BaseModel class]] ){
                                NSError *error =nil;
                                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:subObj options:NSJSONWritingPrettyPrinted error:&error];
                                id newClass = [[className alloc] init];
                                [newClass setUpValueWithData:jsonData];
                                [array addObject:newClass];
                            }
                            else{
                                if (!([className isSubclassOfClass:[NSString class]] && ([subObj isEqualToString:@"null"] || [subObj isEqualToString:@"<null>"]))) {
                                    [array addObject:subObj];
                                }
                            }
                        }
                        [obj setValue:array forKey:propertyName];
                    }
                    else if([classType isSubclassOfClass:[NSDate class]]){
                        id value = [result objectForKey:propertyName];
                        if(value && ![value isKindOfClass:[NSNull class]]){
                            double timeInterval = [value longLongValue];
                            NSDate *date =[NSDate dateWithTimeIntervalSince1970:timeInterval];
                            [obj setValue:date forKey:propertyName];

                        }
                    }
                    else{
                        isObjectType = NO;
                    }
                }
            }
            if(!isObjectType){
                id value = [result objectForKey:propertyName];
                
                if(![value isEqual:[NSNull null]]&& value){
                    @try {
                        [obj setValue:value forKey:propertyName];
                    }
                    @catch (NSException *exception) {
                        NSLog(@"property:%@ parse error with data %@",propertyName,value);
                    }
                }
                
            }
            
        }
    }
    
    free(properties);
    propertyCount = 0;
    selfPropertyCount = 0;
    free(superProperties);
    free(selfProperties);
    [self customBindingValue:result];
    
}

-(void)customBindingValue:(NSDictionary*)result{
    NSString *keyValue = @"unique_id";
    id baseObj = [result objectForKey:keyValue];
    if (baseObj) ((BaseModel*)self).unique_id = [baseObj longLongValue];
    
    keyValue = @"updatedate";
    id value = [result objectForKey:keyValue];
    if(value){
        double timeInterval = [value longLongValue];
        NSDate *date =[NSDate dateWithTimeIntervalSince1970:timeInterval];
        [self setValue:date forKey:keyValue];
    }
    
    keyValue = @"active_flag";
    baseObj = [result objectForKey:keyValue];
    if (baseObj) self.active_flag = [baseObj boolValue];
    // Default is YES
    else self.active_flag = YES;
}


- (void)setUpValueWithString:(NSString*)jsonString{
    NSData* data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    [self setUpValueWithData:data];
}

- (NSString*)toJSONString{
    NSError *error=nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self getObjectDictionary] options:NSJSONWritingPrettyPrinted error:&error];
    if(error) assert([error description]);
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@": true" withString:@": 1"];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@": false" withString:@": 0"];

    return jsonString;
}

-(NSMutableDictionary*)getObjectDictionary{
    NSMutableDictionary *baseDict = [NSMutableDictionary dictionary];
    NSMutableArray *propertiesArray = self.classPropertiesArrayList;
    for(int i = 0; i < [propertiesArray count]; i++) {
        NSString *key = [propertiesArray objectAtIndex:i];
        if ([self shouldSkipPropertyName:[key cStringUsingEncoding:NSUTF8StringEncoding]]) {
            continue;
        }
        id item = [self valueForKey:key];
        if (item) {
            if ([item isKindOfClass:[BaseModel class]]) {
                [baseDict setObject:[item getObjectDictionary] forKey:key];
            }
            else if([item isKindOfClass:[NSMutableArray class]]){
                if([item count] != 0) {
                    NSMutableArray *baseModelArray = [NSMutableArray array];
                    BOOL isFalse = NO;
                    for (int j = 0; j < [item count]; j++) {
                        id obj = [item objectAtIndex:j];
                        if([obj isKindOfClass:[BaseModel class]]) [baseModelArray addObject: [(BaseModel*)obj getObjectDictionary]];
                        else {
                            isFalse = YES;
                            break;
                        }
                    }
                    [baseDict setObject:isFalse?item:baseModelArray forKey:key];
                }
            }
            else if([item isKindOfClass:[NSDate class]]){
                NSDate *date = (NSDate*)item;
                long timeStamp =[date timeIntervalSince1970];
                [baseDict setObject:[NSNumber numberWithLong:timeStamp] forKey:key];
            }
            else{
                [baseDict setObject:item forKey:key];
            }
        }
        
    }
    return baseDict;
}

- (BOOL)shouldSkipPropertyName:(const char *)propName{
    NSString *propNameString =[NSString stringWithUTF8String:propName];
    if ([propNameString isEqualToString:@"hash"]||[propNameString isEqualToString:@"superclass"]||[propNameString isEqualToString:@"debugDescription"]||[propNameString isEqualToString:@"description"] || [propNameString isEqualToString:@"classPropertiesArrayList"]){
        return YES;
    }
    return NO;
}

-(BOOL)isSameKey:(long long)keyToCheck{
    return [self unique_id] == keyToCheck;
}

-(BOOL)isSame:(BaseModel *)objectToCheck{
    return [self isSameKey:objectToCheck.unique_id];
}

-(BOOL)isNewer:(BaseModel *)objectToCheck{
    return ![self isOlder:objectToCheck];
}

-(BOOL)isOlder:(BaseModel *)objectToCheck{
    if (![self isSame:objectToCheck]) {
        @throw [NSException exceptionWithName:@"NotSameObjectException" reason:@"The object is not the same object: please use isSame() first before calling this function." userInfo:nil];
    }
    return ([[objectToCheck updatedate] timeIntervalSince1970] - [[self updatedate] timeIntervalSince1970]) > 0;
}

- (void)updateWithJSONString:(NSString*)jsonString{
    NSData* data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    [self updateWithJSONData:data];
}

- (void)updateWithJSONData:(NSData*)jsonData{
    [self setUpValueWithData:jsonData];
}

@end
