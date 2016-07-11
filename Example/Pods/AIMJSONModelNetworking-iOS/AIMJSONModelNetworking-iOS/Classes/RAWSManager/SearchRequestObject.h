//
//  SearchRequestObject.h
//  SaleWorkFlow
//
//  Created by Ponlavit Larpeampaisarl on 5/13/2558 BE.
//  Copyright (c) 2558 com.arsoft. All rights reserved.
//

#import "BaseModel.h"

@interface SearchRequestObject : BaseModel
@property (nonatomic,strong) NSString *keyword;
@property (nonatomic,strong) NSString *target;
@property (nonatomic,strong) NSString *module;
@property (nonatomic,strong) NSString *token;
@property (nonatomic) int limit;
@property (nonatomic) int offset;
@end
