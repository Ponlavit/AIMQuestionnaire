//
//  AIMResult.h
//  AIMQuestionnaire
//
//  Created by Ponlavit Larpeampaisarl on 7/10/2559 BE.
//  Copyright © 2559 Do In Thai co., ltd. All rights reserved.
//

#import <AIMJSONModelNetworking-iOS/BaseModel.h>
GENERICSABLE(AIMResult)
@interface AIMResult : BaseModel
@property (nonatomic,strong) NSString *result_header;
@property (nonatomic,strong) NSString *result_description;
@property (nonatomic) float result_from;
@property (nonatomic) float result_to;
@end
