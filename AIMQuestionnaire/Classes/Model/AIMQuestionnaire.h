//
//  AIMQuestionnaire.h
//  AIMQuestionnaire
//
//  Created by Ponlavit Larpeampaisarl on 7/9/2559 BE.
//  Copyright © 2559 Do In Thai co., ltd. All rights reserved.
//

#import "BaseModel.h"
#import "AIMResult.h"
#import "AIMQuestion.h"

@interface AIMQuestionnaire : BaseModel
@property (nonatomic,strong) NSString *questionnaire_title;
@property (nonatomic,strong) NSString *questionnaire_image;
_Pragma("clang diagnostic push");
_Pragma("clang diagnostic ignored \"-Wobjc-protocol-qualifiers\"");
@property(nonatomic,strong) NSMutableArray<AIMQuestion> *questions;
@property(nonatomic,strong) NSMutableArray<AIMResult> *results;
_Pragma("clang diagnostic pop")

@end
