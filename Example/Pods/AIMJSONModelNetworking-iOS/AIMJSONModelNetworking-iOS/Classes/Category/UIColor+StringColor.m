//
//  UIColor+StringColor.m
//  SaleWorkFlow
//
//  Created by Ponlavit Larpeampaisarl on 7/7/2558 BE.
//  Copyright (c) 2558 com.arsoft. All rights reserved.
//

#import "UIColor+StringColor.h"
#import "SWConfiguration.h"
@implementation UIColor (StringColor)
+(UIColor*)colorFromString:(NSString*)colorString{
    NSArray *colorArray = [colorString componentsSeparatedByString:@","];
    if (colorArray.count == 3) {
        return RGB([[colorArray objectAtIndex:0] intValue], [[colorArray objectAtIndex:1] intValue], [[colorArray objectAtIndex:2] intValue]);
    }
    if (colorArray.count == 4) {
        return RGBA([[colorArray objectAtIndex:0] intValue], [[colorArray objectAtIndex:1] intValue], [[colorArray objectAtIndex:2] intValue],[[colorArray objectAtIndex:3] intValue]);
 
    }
    return nil;
}
@end
