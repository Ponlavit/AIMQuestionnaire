//
//  ServiceURL.h
//  SaleWorkFlow
//
//  Created by Ponlavit Larpeampaisarl on 8/5/2558 BE.
//  Copyright (c) 2558 com.arsoft. All rights reserved.
//

#import "BaseModel.h"
GENERICSABLE(ServiceURL)

@interface ServiceURL : BaseModel <NSCoding,ServiceURL>
@property (nonatomic,strong) NSString *service_key;
@property (nonatomic,strong) NSString *service_url;
@end
