//
//  UIDevice+Extended.m
//  HealthOnline
//
//  Created by Ponlavit Larpeampaisarl on 6/25/2557 BE.
//  Copyright (c) 2557 kmmiMac. All rights reserved.
//

#import "UIDevice+Extended.h"

@implementation UIDevice (Extended)
- (BOOL)iPhone {
    return (self.userInterfaceIdiom == UIUserInterfaceIdiomPhone);
}
+ (BOOL)iPhone {
    return [[UIDevice currentDevice] iPhone];
}

- (BOOL)iPad {
    return (self.userInterfaceIdiom == UIUserInterfaceIdiomPad);
}
+ (BOOL)iPad {
    return [[UIDevice currentDevice] iPad];
}


@end
