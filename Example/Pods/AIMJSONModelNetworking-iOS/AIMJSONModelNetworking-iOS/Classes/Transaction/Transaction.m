//
//  Transaction.m
//  SaleWorkFlow
//
//  Created by Ponlavit Larpeampaisarl on 4/28/2558 BE.
//  Copyright (c) 2558 com.arsoft. All rights reserved.
//

#import "Transaction.h"
#import "TransactionResponse.h"


@implementation Transaction

@dynamic added_date;
@dynamic failed_count;
@dynamic is_success;
@dynamic json_message;
@dynamic sent_date;
@dynamic target;
@dynamic target_url;
@dynamic token;
@dynamic responses;
@synthesize module;

-(void)awakeFromInsert{
    [self setAdded_date:[NSDate date]];
}

@end
