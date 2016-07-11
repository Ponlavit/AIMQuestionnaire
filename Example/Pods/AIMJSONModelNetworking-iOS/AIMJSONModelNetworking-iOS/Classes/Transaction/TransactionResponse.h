//
//  TransactionResponse.h
//  SaleWorkFlow
//
//  Created by Ponlavit Larpeampaisarl on 4/28/2558 BE.
//  Copyright (c) 2558 com.arsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Transaction;

@interface TransactionResponse : NSManagedObject

@property (nonatomic, retain) NSDate * added_date;
@property (nonatomic, retain) NSString * response_message;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) Transaction *source;

@end
