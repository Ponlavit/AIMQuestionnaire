//
//  AIMAnswer.h
//  AIMQuestionnaire
//
//  Created by Ponlavit Larpeampaisarl on 7/10/2559 BE.
//  Copyright © 2559 Do In Thai co., ltd. All rights reserved.
//

#import "BaseModel.h"
GENERICSABLE(AIMAnswer)
@interface AIMAnswer : BaseModel
@property (nonatomic,strong) NSString *answer_text;
@property (nonatomic,strong) NSString *action;
@property (nonatomic) float answer_score;
@property (nonatomic,strong) NSMutableArray *contradiction;
@end
