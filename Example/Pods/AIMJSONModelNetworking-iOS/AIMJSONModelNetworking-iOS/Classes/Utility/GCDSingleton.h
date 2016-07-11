//
//  GCDSingleton.h
//  SaleWorkFlow
//
//  Created by Ponlavit Larpeampaisarl on 3/24/2558 BE.
//  Copyright (c) 2558 com.arsoft. All rights reserved.
//

#ifndef SaleWorkFlow_GCDSingleton_h
#define SaleWorkFlow_GCDSingleton_h
#define SINGLETON(block) \
static dispatch_once_t pred = 0; \
__strong static id _sharedObject = nil; \
dispatch_once(&pred, ^{ \
_sharedObject = block(); \
}); \
return _sharedObject; \

#endif
