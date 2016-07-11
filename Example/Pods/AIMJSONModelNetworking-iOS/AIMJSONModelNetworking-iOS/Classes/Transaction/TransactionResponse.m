//
//  TransactionResponse.m
//  SaleWorkFlow
//
//  Created by Ponlavit Larpeampaisarl on 4/28/2558 BE.
//  Copyright (c) 2558 com.arsoft. All rights reserved.
//

#import "TransactionResponse.h"
#import "Transaction.h"


@implementation TransactionResponse

@dynamic added_date;
@dynamic response_message;
@dynamic status;
@dynamic source;


-(void)awakeFromInsert{
    [self setAdded_date:[NSDate date]];
}

@end
