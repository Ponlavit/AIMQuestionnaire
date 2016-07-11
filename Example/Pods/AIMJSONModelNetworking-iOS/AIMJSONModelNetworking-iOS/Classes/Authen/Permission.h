//
//  Permission.h
//  SaleWorkFlow
//
//  Created by Ponlavit Larpeampaisarl on 5/14/2558 BE.
//  Copyright (c) 2558 com.arsoft. All rights reserved.
//

#import "BaseModel.h"

GENERICSABLE(Permission)

@interface Permission : BaseModel <Permission,NSCoding>
@property (nonatomic,strong) NSString *name;
@property (nonatomic) int level;
@end
