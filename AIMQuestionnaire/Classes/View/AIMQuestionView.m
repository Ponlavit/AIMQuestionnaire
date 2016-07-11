//
//  AIMQuestionView.m
//  AIMQuestionnaire
//
//  Created by Ponlavit Larpeampaisarl on 7/10/2559 BE.
//  Copyright © 2559 Do In Thai co., ltd. All rights reserved.
//

#import "AIMQuestionView.h"
#import "AIMAnswerView.h"

@interface AIMQuestionView()
@property (nonatomic,strong) NSMutableArray<AIMAnswerView*> *ary_answer;
@property (nonatomic) int answerFinishedLoadedCount;
@property (nonatomic) float question_end_y;
@property (nonatomic,strong) UIWebView *questionTextHolder;
@property (nonatomic,strong) UIScrollView *answerScrollView;
@property (nonatomic) BOOL hasDoneRender;
@end

@implementation AIMQuestionView


-(UIScrollView *)answerScrollView{
    if (!_answerScrollView) {
        _answerScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [_answerScrollView setBackgroundColor:[UIColor whiteColor]];
        [_answerScrollView setOpaque:YES];
    }
    return _answerScrollView;
}
-(NSMutableArray<AIMAnswerView *> *)ary_answer{
    if (!_ary_answer) {
        _ary_answer = [NSMutableArray array];
    }
    return _ary_answer;
}

-(UIWebView *)questionTextHolder{
    if (!_questionTextHolder) {
        _questionTextHolder = [[UIWebView alloc] initWithFrame:CGRectMake(20,20, self.frame.size.width-40, 10)];
        [_questionTextHolder setDelegate:self];
        [_questionTextHolder setUserInteractionEnabled:NO];
        [_questionTextHolder setBackgroundColor:[UIColor clearColor]];
        [_questionTextHolder setOpaque:NO];
        [_questionTextHolder loadHTMLString:[self setupThemeForQuestion:self.question.question_text] baseURL:nil];
    }
    return _questionTextHolder;
}

-(id)initWithFrame:(CGRect)frame andQuestion:(AIMQuestion*)question{
    if (self = [super initWithFrame:frame]) {
        self.question = question;
        self.answerFinishedLoadedCount = 0;
        self.hasDoneRender = NO;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [self addSubview:self.answerScrollView];
    [self.answerScrollView addSubview:self.questionTextHolder];
    [self setBackgroundColor:[UIColor clearColor]];
}


-(void)setupAnswer{
    AIMQuestion *q = self.question;
    int offset = 0;
    for (AIMAnswer *answer in [q answers]) {
        AIMAnswerView *av = [[AIMAnswerView alloc] initWithFrame:CGRectMake(20, offset+100, self.frame.size.width-40, 10) andAnswer:answer];
        [av setDelegate:self];
        offset = av.frame.size.height + av.frame.origin.y + [self getButtonSpacing];
        [av setBackgroundColor:[UIColor clearColor]];
        [self.ary_answer addObject:av];
        [self.answerScrollView addSubview:av];
    }
}

-(void)didSelected:(AIMAnswerView *)answerView{
    if (!self.question.allow_multiple) {
        // Deselect other answerView
        for (AIMAnswerView *answer in self.ary_answer) {
            if (![answer isEqual:answerView]) {
                [answer setSelected:NO];
            }
        }
    }
    else{
        // Contradiction check
        NSMutableOrderedSet *ary_disableOption = [NSMutableOrderedSet orderedSet];
        for (AIMAnswerView *answerView in self.ary_answer) {
            if(answerView.isSelected){
                for (NSNumber *num in answerView.answer.contradiction) {
                    [ary_disableOption addObject:num];
                }
            }
        }

        // Enable all
        for (AIMAnswerView *answerView in self.ary_answer) {
            [answerView setEnabled:YES];
        }

        // Disable who should
        for (NSNumber *num in ary_disableOption) {
            for (AIMAnswerView *answerView in self.ary_answer) {
                if (answerView.answer.unique_id == [num longLongValue]) {
                    [answerView setEnabled:NO];
                    break;
                }
            }

        }
    }
}

-(float)calculateScore{
    float score = 0.0f;
    for (AIMAnswerView *answer in self.ary_answer) {
        if([answer isSelected]){
            score += [[answer answer] answer_score];
        }
    }
    return MIN(score,self.question.max_score);
}

-(BOOL)isAllowNext{
    for (AIMAnswerView *answer in self.ary_answer) {
        if([answer isSelected]){
            return YES;
        }
    }
    return NO;
}

-(NSString*)getNextQuestion{
    for (AIMAnswerView *answer in self.ary_answer) {
        if([answer isSelected]){
            return answer.answer.action;
        }
    }
    return nil;
}

-(void)didFinishRenderAnswer:(AIMAnswerView *)answerView{
    if (self.hasDoneRender) {
        return;
    }
    self.answerFinishedLoadedCount++;
    int last = self.question_end_y;
    if (self.answerFinishedLoadedCount == [self.ary_answer count]) {
        int offset = [self getButtonSpacing];
        for (AIMAnswerView *av in self.ary_answer) {
            [av setFrame:CGRectMake(av.frame.origin.x,
                                    last + offset,
                                    av.frame.size.width,
                                    av.frame.size.height)];
            last = av.frame.origin.y + av.frame.size.height;
        }
        self.hasDoneRender = YES;
    }
    [self.answerScrollView setContentSize:CGSizeMake(self.bounds.size.width, last+[self getButtonSpacing])];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    if ([webView isEqual:self.questionTextHolder]) {
        CGSize contentSize = webView.scrollView.contentSize;
        CGSize viewSize = webView.bounds.size;
        float rw = viewSize.width / contentSize.width;
        webView.scrollView.minimumZoomScale = rw;
        webView.scrollView.maximumZoomScale = rw;
        webView.scrollView.zoomScale = rw;
        [webView setFrame:CGRectMake(webView.frame.origin.x,
                                     webView.frame.origin.y,
                                     webView.scrollView.contentSize.width,
                                     webView.scrollView.contentSize.height)];
        self.question_end_y = webView.frame.origin.y +
        webView.scrollView.contentSize.height;
        [self setupAnswer];
    }
}

#pragma mark - setup for theme

-(NSString*)setupThemeForQuestion:(NSString*)answer{
    NSString *themeString = @"<body style='margin:0;padding:0;'><div style='font-size:22px;font-style:normal;font-weight:normal;text-decoration:none;text-transform:none;color:000000;'>";
    NSString *endThemeString = @"</div></body>";
    return [NSString stringWithFormat:@"%@%@%@",themeString,answer,endThemeString];
}

-(float)getButtonSpacing{
    return 20.0f;
}

@end
