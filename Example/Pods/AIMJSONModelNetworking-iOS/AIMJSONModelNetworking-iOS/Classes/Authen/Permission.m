//
//  Permission.m
//  SaleWorkFlow
//
//  Created by Ponlavit Larpeampaisarl on 5/14/2558 BE.
//  Copyright (c) 2558 com.arsoft. All rights reserved.
//

#import "Permission.h"

@implementation Permission
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.name forKey:@"pname"];
    [aCoder encodeInt:self.level forKey:@"level"];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"pname"];
        self.level = [aDecoder decodeIntForKey:@"level"];
    }
    return self;
}
@end
