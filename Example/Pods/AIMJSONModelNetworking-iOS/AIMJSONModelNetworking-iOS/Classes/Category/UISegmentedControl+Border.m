//
//  UISegmentedControl+Border.m
//  SaleWorkFlow
//
//  Created by Sarinthon on 2/2/2559 BE.
//  Copyright © 2559 com.arsoft. All rights reserved.
//

#import "UISegmentedControl+Border.h"

@implementation UISegmentedControl (Border)

- (void)removeBorder{
    [self setBackgroundImage:[self imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self setBackgroundImage:[self imageWithColor:self.tintColor] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [self setDividerImage:[self imageWithColor:[UIColor clearColor]] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
}

- (UIImage*)imageWithColor:(UIColor*)color{
    CGRect rect = CGRectMake(0.0, 0.0, 1.0, 1.0);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
