//
//  AIMQuestion.h
//  AIMQuestionnaire
//
//  Created by Ponlavit Larpeampaisarl on 7/10/2559 BE.
//  Copyright © 2559 Do In Thai co., ltd. All rights reserved.
//

#import <AIMJSONModelNetworking-iOS/BaseModel.h>
#import "AIMAnswer.h"
GENERICSABLE(AIMQuestion)
@interface AIMQuestion : BaseModel
@property (nonatomic,strong) NSString *question_text;
@property (nonatomic) BOOL allow_multiple;
@property (nonatomic) BOOL has_image;
@property (nonatomic,strong) NSMutableArray *images;
@property (nonatomic) float max_score;
property_NSMutableArray(AIMAnswer, answers);
@end
