//
//  UIButtonWithImageAspectFit.m
//  FoodGive
//
//  Created by Ponlavit Larpeampaisarl on 4/24/2559 BE.
//  Copyright © 2559 Do In Thai co., ltd. All rights reserved.
//

#import "UIButtonWithImageAspectFit.h"

@implementation UIButtonWithImageAspectFit
- (void) awakeFromNib {
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
}
@end
