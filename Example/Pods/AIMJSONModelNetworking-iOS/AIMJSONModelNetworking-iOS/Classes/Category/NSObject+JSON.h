//
//  NSObject+JSON.h
//  SaleWorkFlow
//
//  Created by Ponlavit Larpeampaisarl on 6/26/2558 BE.
//  Copyright (c) 2558 com.arsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
@interface NSObject (JSON)
-(NSMutableDictionary *)getObjectDictionary:(BaseModel*)object;
@end
