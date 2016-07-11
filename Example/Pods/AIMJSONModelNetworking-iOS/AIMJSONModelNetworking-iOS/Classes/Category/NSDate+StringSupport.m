//
//  NSDate+StringSupport.m
//  SaleWorkFlow
//
//  Created by Ponlavit Larpeampaisarl on 4/20/2558 BE.
//  Copyright (c) 2558 com.arsoft. All rights reserved.
//

#import "NSDate+StringSupport.h"

@implementation NSDate (StringSupport)

-(NSString *)toDateTimeString{
    return [self toStringWithFormat:@"dd/MM/yyyy HH:mm"];
}
-(NSString *)toDateString{
    return [self toStringWithFormat:@"dd/MM/yyyy"];
}

-(NSString *)toFullDateString{
    return [self toStringWithFormat:@"EEEE, d MMMM yyyy"];
}

-(NSString *)toTimeString{
    return [self toStringWithFormat:@"HH:mm"];
}
-(NSString *)toStringWithFormat:(NSString*)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    formatter.timeZone = [NSTimeZone localTimeZone];
    formatter.locale = [NSLocale currentLocale];

    [formatter setDateFormat:format];
    NSString *dateString = [formatter stringFromDate:self];
    return dateString;
}

-(NSString *)toTimestamp{
    return [NSString stringWithFormat:@"%ld",[self toLongTimestamp]];
}

-(long)toLongTimestamp{
    return [self timeIntervalSince1970];
}

+(NSDate*)dateFromTimestamp:(long)timestamp{
    return [[NSDate alloc] initWithTimeIntervalSince1970:timestamp];

}

@end
