//
//  TransactionManager.h
//  SaleWorkFlow
//
//  Created by Ponlavit Larpeampaisarl on 4/28/2558 BE.
//  Copyright (c) 2558 com.arsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseModel.h"
#import "Transaction.h"
#import "TransactionResponse.h"
#import "SWConfiguration.h"

@interface TransactionManager : NSObject

+ (id)defaultManager;
- (void)addNewTransactionFromObject:(BaseModel*)model
                      withTargetURL:(NSString*)urlString
                           andToken:(NSString*)token
                              error:(NSError*)error;
- (void)startService;
- (NSArray<NSManagedObject*>*)getTransaction;
-(void)runUpload;
- (void)postUpload:(Transaction *)tran;

@property (nonatomic, strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSString *persistentStorePath;
@property (nonatomic, strong) NSTimer *uploadTimer;
@end
