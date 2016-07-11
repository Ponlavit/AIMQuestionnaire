//
//  AIMQuestionnaireViewController.h
//  AIMQuestionnaire
//
//  Created by Ponlavit Larpeampaisarl on 7/10/2559 BE.
//  Copyright © 2559 Do In Thai co., ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AIMQuestionnaire.h"
#import "AIMQuestionView.h"

@protocol AIMQuestionnaireViewControllerDelegate;

@interface AIMQuestionnaireViewController : UIViewController
- (id)initWithQuestionnaire:(AIMQuestionnaire*)questionnaire;
@property (nonatomic,strong) AIMQuestionnaire *questionnaire;
@property (nonatomic,strong) AIMQuestionView *currentQuestion;
@property (nonatomic,weak) id<AIMQuestionnaireViewControllerDelegate> delegate;
@end

@protocol AIMQuestionnaireViewControllerDelegate <NSObject>
@required
-(void)questionnaire:(AIMQuestionnaireViewController*)questionnaire didFinishedWithResult:(AIMResult*)result;
@end