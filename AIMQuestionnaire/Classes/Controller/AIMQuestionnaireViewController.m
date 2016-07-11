//
//  AIMQuestionnaireViewController.m
//  AIMQuestionnaire
//
//  Created by Ponlavit Larpeampaisarl on 7/10/2559 BE.
//  Copyright © 2559 Do In Thai co., ltd. All rights reserved.
//

#import "AIMQuestionnaireViewController.h"
#import "AIMQuestionView.h"
@import MBProgressHUD;
#import "UIColor+HexStringColor.h"
@interface AIMQuestionnaireViewController ()
@property (nonatomic) float totalScore;
@property (nonatomic,strong) UIView *questionHolder;
@property (nonatomic,strong) NSMutableArray<AIMQuestionView *> *ary_question;
@property (nonatomic,strong) UIView *actionHolder;
@property (nonatomic,strong) UIButton *nextButton;
@property (nonatomic,strong) UIButton *backButton;
@property (nonatomic,strong) MBProgressHUD *hud;
@end

@implementation AIMQuestionnaireViewController

-(NSMutableArray *)ary_question{
    if (!_ary_question) {
        _ary_question = [NSMutableArray array];
    }
    return _ary_question;
}

-(UIButton *)backButton{
    if (!_backButton) {
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake([self getFooterMargin], [self getFooterMargin], [self getActionButtonWidth], [self getFooterHeight]-[self getFooterMargin]*2)];
        [_backButton setTitle:[self getBackButtonTitle] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(didPressedBack) forControlEvents:UIControlEventTouchUpInside];
        [self setupButtonTheme:_backButton];
    }
    return _backButton;
}
-(UIButton *)nextButton{
    if (!_nextButton) {
        _nextButton = [[UIButton alloc] initWithFrame:CGRectMake(self.actionHolder.frame.size.width - [self getActionButtonWidth] - [self getFooterMargin], [self getFooterMargin], [self getActionButtonWidth], [self getFooterHeight]-[self getFooterMargin]*2)];
        [_nextButton setTitle:[self getNextButtonTitle] forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(didPressedContinue) forControlEvents:UIControlEventTouchUpInside];
        [self setupButtonTheme:_nextButton];
    }
    return _nextButton;
}


-(UIView *)actionHolder{
    if (!_actionHolder) {
        _actionHolder = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - [self getFooterHeight], self.view.frame.size.width, [self getFooterHeight])];
        [_actionHolder setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin];
    }
    return _actionHolder;
}

-(UIView *)questionHolder{
    if (!_questionHolder) {
        _questionHolder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - [self getFooterHeight])];
        [_questionHolder setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    }
    return _questionHolder;
}

- (id)initWithQuestionnaire:(AIMQuestionnaire*)questionnaire{
    if (self = [super init]) {
        self.questionnaire = questionnaire;
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated{
    [self.view addSubview:self.questionHolder];
    [self.view addSubview:self.actionHolder];

    [self generateQuestion];
    [self setupFirstQuestion];
    [self setupBackAndContinueButton];
}

-(void)generateQuestion{
    for (AIMQuestion *question in self.questionnaire.questions) {
        AIMQuestionView *qv = [[AIMQuestionView alloc] initWithFrame:self.questionHolder.bounds andQuestion:question];
        [self.ary_question addObject:qv];
    }
}

-(void)setupFirstQuestion{
    [self generateQuestion];
    AIMQuestionView *qv = [self.ary_question objectAtIndex:0];
    qv.lastQuestionID = -1;
    [self openQuestionFromID:qv.question.unique_id];
}

-(void)openQuestionFromID:(long long)questionID{
    AIMQuestionView *nextQuestion = [self getQuestionFromID:questionID];
    if (self.currentQuestion) {
        self.currentQuestion.userScore = [self.currentQuestion calculateScore];
        self.totalScore += self.currentQuestion.userScore;
        nextQuestion.lastQuestionID = self.currentQuestion.question.unique_id;
    }

    // Replace new question
    [self.currentQuestion removeFromSuperview];
    self.currentQuestion = nextQuestion;
    [self.backButton setHidden:self.currentQuestion.lastQuestionID == -1];
    [self.view addSubview:self.currentQuestion];
}

-(AIMQuestionView*)getQuestionFromID:(long long)questionID{
    for (AIMQuestionView *questionView in self.ary_question) {
        if([questionView.question isSameKey:questionID])
            return questionView;
    }
    return nil;
}

-(void)setupBackAndContinueButton{
    [self.actionHolder addSubview:self.nextButton];
    [self.actionHolder addSubview:self.backButton];
}

-(void)didPressedContinue{
    if([self.currentQuestion isAllowNext]){
        NSString *nextAction = [self.currentQuestion getNextQuestion];
        NSLog(@"action : %@",nextAction);
        if([nextAction containsString:@"showquestion"]){
            nextAction = [nextAction substringFromIndex:[@"showquestion" length]+1];
            [self openQuestionFromID:[nextAction longLongValue]];
            NSLog(@"total score is : %.2f",self.totalScore);
        }
        else if([nextAction containsString:@"showresult"]){
            nextAction = [nextAction substringFromIndex:[@"showresult" length]+1];
            for (AIMResult *result in self.questionnaire.results) {
                if (result.unique_id == [nextAction longLongValue]){
                    NSAssert(self.delegate && [self.delegate respondsToSelector:@selector(questionnaire:didFinishedWithResult:)], @"require delegatation");
                    [self.delegate questionnaire:self didFinishedWithResult:result];
                }
            }
        }
        else if([nextAction containsString:@"checkscore"]){
            // calculate last question score before open the result
            self.currentQuestion.userScore = [self.currentQuestion calculateScore];
            self.totalScore += self.currentQuestion.userScore;
            [self.currentQuestion removeFromSuperview];
            [self.actionHolder setHidden:YES];
            NSLog(@"total score is : %.2f",self.totalScore);

            for (AIMResult *result in self.questionnaire.results) {
                if ([self totalScore] >= result.result_from && [self totalScore] <= result.result_to) {
                    NSAssert(self.delegate && [self.delegate respondsToSelector:@selector(questionnaire:didFinishedWithResult:)], @"require delegatation");
                    [self.delegate questionnaire:self didFinishedWithResult:result];                }
            }
        }
    }
    else{
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.hud setMode:MBProgressHUDModeText];
        [self.hud setLabelText:@"กรุณาเลือกอย่างน้อย 1 ข้อ"];
        [self.hud hide:YES afterDelay:3.0f];
    }
}

-(void)didPressedBack{
    AIMQuestionView *lastQuestion = [self getQuestionFromID:self.currentQuestion.lastQuestionID];

    // Minus last question score
    self.totalScore -= [lastQuestion userScore];

    // Replace last question
    [self.currentQuestion removeFromSuperview];
    self.currentQuestion = lastQuestion;
    [self.backButton setHidden:self.currentQuestion.lastQuestionID == -1];
    NSLog(@"total score is : %.2f",self.totalScore);

    [self.view addSubview:self.currentQuestion];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setup for theme

- (float) getFooterHeight{
    return 50.0f;
}

- (float) getFooterMargin{
    return 10.0f;
}

- (float) getActionButtonWidth{
    return 120.0f;
}

-(NSString*)getBackButtonTitle{
    return @"กลับ";
}

-(NSString*)getNextButtonTitle{
    return @"ต่อไป";
}

-(void)setupButtonTheme:(UIButton*)button{
    [button.layer setCornerRadius:10.0f];
    [button setBackgroundColor:[UIColor colorFromHexString:@"#2980b9"]];
}

@end
