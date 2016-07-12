//
//  AIMResultViewController.m
//  AIMQuestionnaire
//
//  Created by Ponlavit Larpeampaisarl on 7/11/2559 BE.
//  Copyright © 2559 Ponlavit Larpeampaisarl. All rights reserved.
//

#import "AIMResultViewController.h"

@interface AIMResultViewController ()
@property (nonatomic,weak) IBOutlet UIWebView *result_holder;
@property (nonatomic,strong) AIMResult *show_result;
@end

@implementation AIMResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setResult:(AIMResult*)result{
    self.show_result = result;
}

-(void)viewDidAppear:(BOOL)animated{
    self.title = @"ผลการตรวจสอบเบื้องต้น";
    [self.result_holder loadHTMLString:[self setupThemeForHeader:self.show_result.result_header andDescription:self.show_result.result_description] baseURL:nil];
}



-(NSString*)setupThemeForHeader:(NSString*)header andDescription:(NSString*)desc{
    NSString *themeString = [NSString stringWithFormat:
                             @"%@%@%@%d%@",
                             @"<body style='margin:20;padding:20'><div style='style='background: #3498db;background-image: -webkit-linear-gradient(top, #3498db, #2980b9);display: block;'><h3><center>",
                             header,
                             @"</center></h3></div><div style='background: #3498db;background-image: -webkit-linear-gradient(top, #3498db, #2980b9);display: block; width:",
                             (int)self.result_holder.frame.size.width,
                             @" px;background-image: -moz-linear-gradient(top, #3498db, #2980b9);background-image: -ms-linear-gradient(top, #3498db, #2980b9);background-image: -o-linear-gradient(top, #3498db, #2980b9);background-image: linear-gradient(to bottom, #3498db, #2980b9);-webkit-border-radius: 10;-moz-border-radius: 10;border-radius: 10px;color: #ffffff;font-size: 20px;padding: 10px 20px 10px 20px;text-decoration: none;-moz-hyphens:auto;-ms-hyphens:auto;-webkit-hyphens:auto;hyphens:auto;word-wrap:break-word;'>"];
    NSString *endThemeString = @"</div></body>";
    return [NSString stringWithFormat:@"%@%@%@",themeString,desc,endThemeString];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    // [webView setFrame:CGRectMake(webView.frame.origin.x, webView.frame.origin.y, webView.scrollView.contentSize.width, webView.scrollView.contentSize.height)];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
