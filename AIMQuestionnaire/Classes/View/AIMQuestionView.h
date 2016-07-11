//
//  AIMQuestionView.h
//  AIMQuestionnaire
//
//  Created by Ponlavit Larpeampaisarl on 7/10/2559 BE.
//  Copyright © 2559 Do In Thai co., ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AIMAnswerView.h"
#import "AIMQuestion.h"
@interface AIMQuestionView : UIView <AIMAnswerViewDelegate,UIWebViewDelegate>
@property (nonatomic) float userScore;
@property (nonatomic) long lastQuestionID;
@property (nonatomic,strong) AIMQuestion *question;

-(id)initWithFrame:(CGRect)frame andQuestion:(AIMQuestion*)question;
-(float)calculateScore;
-(BOOL)isAllowNext;
-(NSString*)getNextQuestion;
@end
