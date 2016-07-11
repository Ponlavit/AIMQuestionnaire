//
//  AIMAnswerView.m
//  AIMQuestionnaire
//
//  Created by Ponlavit Larpeampaisarl on 7/10/2559 BE.
//  Copyright © 2559 Do In Thai co., ltd. All rights reserved.
//

#import "AIMAnswerView.h"
#import <QuartzCore/QuartzCore.h>
#import <AIMJSONModelNetworking-iOS/UIColor+StringColor.h>

@interface AIMAnswerView()
@property (nonatomic,strong) UIWebView *answerTextHolder;
@property (nonatomic,strong) UIView *disableMask;
@end

@implementation AIMAnswerView

-(UIView *)disableMask{
    if (!_disableMask) {
        _disableMask  = [[UIView alloc]initWithFrame:self.bounds];
        _disableMask.backgroundColor = [[UIColor grayColor]colorWithAlphaComponent:0.6];
        [_disableMask setUserInteractionEnabled:NO];
    }
    return _disableMask;
}

-(UIWebView *)answerTextHolder{
    if (!_answerTextHolder) {
        _answerTextHolder = [[UIWebView alloc] initWithFrame:self.bounds];
        [_answerTextHolder setDelegate:self];
        [_answerTextHolder setUserInteractionEnabled:NO];
        [_answerTextHolder setBackgroundColor:[UIColor clearColor]];
        [_answerTextHolder setOpaque:NO];
        [_answerTextHolder loadHTMLString:[self setupThemeForAnswers:self.answer.answer_text] baseURL:nil];
    }
    return _answerTextHolder;
}


-(id)initWithFrame:(CGRect)frame andAnswer:(AIMAnswer*)answer{
    if (self = [super initWithFrame:frame]) {
        _answer = answer;
        [self addTarget:self action:@selector(onSelect) forControlEvents:UIControlEventTouchUpInside];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

-(void)setDelegate:(id<AIMAnswerViewDelegate>)delegate{
    _delegate = delegate;
}


-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        [self.answerTextHolder loadHTMLString:[self setupThemeForAnswersHighlight:self.answer.answer_text] baseURL:nil];
    }
    else{
        [self.answerTextHolder loadHTMLString:[self setupThemeForAnswers:self.answer.answer_text] baseURL:nil];
    }
}

-(void)setEnabled:(BOOL)enabled{
    [super setEnabled:enabled];
    if (!enabled) {
        [self setSelected:NO];
        self.answerTextHolder.layer.mask = self.disableMask.layer;
    }
    else{
        self.answerTextHolder.layer.mask = nil;
    }
}

-(void)onSelect{
    [self setSelected:!self.isSelected];
    if(self.delegate && [self.delegate respondsToSelector:@selector(didSelected:)]){
        [self.delegate didSelected:self];
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [self addSubview:self.answerTextHolder];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, webView.scrollView.contentSize.width, webView.scrollView.contentSize.height)];
    [webView setFrame:self.bounds];
    if ([self.delegate respondsToSelector:@selector(didFinishRenderAnswer:)]) {
        [self.delegate didFinishRenderAnswer:self];
    }
}

#pragma mark - setup for theme

-(NSString*)setupThemeForAnswers:(NSString*)answer{
    NSString *themeString = [NSString stringWithFormat:
                             @"%@%d%@",@"<body style='margin:0;padding:0'><div style='background: #3498db;background-image: -webkit-linear-gradient(top, #3498db, #2980b9);display: block; width:",
                             (int)self.bounds.size.width,
                             @" px;background-image: -moz-linear-gradient(top, #3498db, #2980b9);background-image: -ms-linear-gradient(top, #3498db, #2980b9);background-image: -o-linear-gradient(top, #3498db, #2980b9);background-image: linear-gradient(to bottom, #3498db, #2980b9);-webkit-border-radius: 10;-moz-border-radius: 10;border-radius: 10px;color: #ffffff;font-size: 20px;padding: 10px 20px 10px 20px;text-decoration: none;-moz-hyphens:auto;-ms-hyphens:auto;-webkit-hyphens:auto;hyphens:auto;word-wrap:break-word;'>"];
    NSString *endThemeString = @"</div></body>";
    return [NSString stringWithFormat:@"%@%@%@",themeString,answer,endThemeString];
}

-(NSString*)setupThemeForAnswersHighlight:(NSString*)answer{
    NSString *themeString = [NSString stringWithFormat:
                             @"%@%d%@",@"<body style='margin:0;padding:0'><div style='background: #3498db;background-image: -webkit-linear-gradient(top, #3498db, #2980b9);display: block; width:",
                             (int)self.bounds.size.width,
                             @" px;background-image: -moz-linear-gradient(top, #3498db, #2980b9);background-image: -ms-linear-gradient(top, #3498db, #2980b9);background-image: -o-linear-gradient(top, #3498db, #2980b9);background-image: linear-gradient(to bottom, #3498db, #2980b9);-webkit-border-radius: 10;-moz-border-radius: 10;border-radius: 10px;color: #ffffff;font-size: 20px;padding: 10px 20px 10px 20px;text-decoration: none;border: solid 1px #203E5F;box-shadow: inset 0 1px 4px rgba(0, 0, 0, 0.6);-webkit-box-shadow: inset 0 1px 4px rgba(0, 0, 0, 0.6);-moz-box-shadow: inset 0 1px 4px rgba(0, 0, 0, 0.6);background: #2E5481;-moz-hyphens:auto;-ms-hyphens:auto;-webkit-hyphens:auto;hyphens:auto;word-wrap:break-word;'>"];
    NSString *endThemeString = @"</div></body>";
    return [NSString stringWithFormat:@"%@%@%@",themeString,answer,endThemeString];
}




@end
