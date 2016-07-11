//
//  Transaction.h
//  SaleWorkFlow
//
//  Created by Ponlavit Larpeampaisarl on 4/28/2558 BE.
//  Copyright (c) 2558 com.arsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TransactionResponse;

@interface Transaction : NSManagedObject

@property (nonatomic, retain) NSDate * added_date;
@property (nonatomic, retain) NSNumber * failed_count;
@property (nonatomic, retain) NSNumber * is_success;
@property (nonatomic, retain) NSString * json_message;
@property (nonatomic, retain) NSDate * sent_date;
@property (nonatomic, retain) NSString * module;
@property (nonatomic, retain) NSString * target;
@property (nonatomic, retain) NSString * target_url;
@property (nonatomic, retain) NSString * token;
@property (nonatomic, retain) NSSet *responses;
@end

@interface Transaction (CoreDataGeneratedAccessors)

- (void)addResponsesObject:(TransactionResponse *)value;
- (void)removeResponsesObject:(TransactionResponse *)value;
- (void)addResponses:(NSSet *)values;
- (void)removeResponses:(NSSet *)values;

@end
