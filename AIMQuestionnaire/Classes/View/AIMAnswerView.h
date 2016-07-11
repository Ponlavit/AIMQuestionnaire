//
//  AIMAnswerView.h
//  AIMQuestionnaire
//
//  Created by Ponlavit Larpeampaisarl on 7/10/2559 BE.
//  Copyright © 2559 Do In Thai co., ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AIMAnswer.h"
@protocol AIMAnswerViewDelegate;


@interface AIMAnswerView : UIControl <UIWebViewDelegate>
@property (nonatomic,strong) AIMAnswer *answer;
@property (nonatomic,strong) id<AIMAnswerViewDelegate> delegate;
-(id)initWithFrame:(CGRect)frame andAnswer:(AIMAnswer*)answer;
@end


@protocol AIMAnswerViewDelegate <NSObject>
@required
- (void)didFinishRenderAnswer:(AIMAnswerView*)answerView;
- (void)didSelected:(AIMAnswerView*)answerView;
@end
