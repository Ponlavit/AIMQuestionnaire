//
//  NSDate+StringSupport.h
//  SaleWorkFlow
//
//  Created by Ponlavit Larpeampaisarl on 4/20/2558 BE.
//  Copyright (c) 2558 com.arsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (StringSupport)
-(NSString *)toDateTimeString;
-(NSString *)toDateString;
-(NSString *)toTimeString;
-(NSString *)toStringWithFormat:(NSString*)format;
-(NSString *)toFullDateString;
-(NSString *)toTimestamp;
-(long)toLongTimestamp;
+(NSDate*)dateFromTimestamp:(long)timestamp;
@end
