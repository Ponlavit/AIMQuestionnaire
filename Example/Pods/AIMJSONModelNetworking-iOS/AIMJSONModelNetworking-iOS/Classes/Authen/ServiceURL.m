//
//  ServiceURL.m
//  SaleWorkFlow
//
//  Created by Ponlavit Larpeampaisarl on 8/5/2558 BE.
//  Copyright (c) 2558 com.arsoft. All rights reserved.
//

#import "ServiceURL.h"

@implementation ServiceURL
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.service_key forKey:@"service_key"];
    [aCoder encodeObject:self.service_url forKey:@"service_url"];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.service_key = [aDecoder decodeObjectForKey:@"service_key"];
        self.service_url = [aDecoder decodeObjectForKey:@"service_url"];
    }
    return self;
}
@end
