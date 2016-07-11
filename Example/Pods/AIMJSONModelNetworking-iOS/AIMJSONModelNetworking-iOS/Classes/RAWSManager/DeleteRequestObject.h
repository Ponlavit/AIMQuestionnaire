//
//  DeleteRequestObject.h
//  SaleWorkFlow
//
//  Created by Ponlavit Larpeampaisarl on 5/13/2558 BE.
//  Copyright (c) 2558 com.arsoft. All rights reserved.
//

#import "BaseModel.h"

@interface DeleteRequestObject : BaseModel
@property (nonatomic,strong) NSString *objectId;
@property (nonatomic,strong) NSString *target;
@property (nonatomic,strong) NSString *module;
@property (nonatomic,strong) NSString *token;
@end
