//
//  AIMQuestionnaire.h
//  AIMQuestionnaire
//
//  Created by Ponlavit Larpeampaisarl on 7/9/2559 BE.
//  Copyright © 2559 Do In Thai co., ltd. All rights reserved.
//

#import <AIMJSONModelNetworking-iOS/BaseModel.h>
#import "AIMResult.h"
#import "AIMQuestion.h"

@interface AIMQuestionnaire : BaseModel
@property (nonatomic,strong) NSString *questionnaire_title;
@property (nonatomic,strong) NSString *questionnaire_image;
property_NSMutableArray(AIMResult, results);
property_NSMutableArray(AIMQuestion,questions);
@end
