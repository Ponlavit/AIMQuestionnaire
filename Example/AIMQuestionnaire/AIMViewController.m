//
//  AIMViewController.m
//  AIMQuestionnaire
//
//  Created by Ponlavit Larpeampaisarl on 07/11/2016.
//  Copyright (c) 2016 Ponlavit Larpeampaisarl. All rights reserved.
//

#import "AIMViewController.h"
#import "AIMQuestionnaireViewController.h"
#import "RestJSONWebServiceManager.h"
#import "AIMResultViewController.h"

@interface AIMViewController ()
@property (nonatomic,strong) NSMutableArray *datasource;
@property (nonatomic,strong) AIMQuestionnaireViewController *questionnaireVC;
@end

@implementation AIMViewController

-(NSMutableArray *)datasource{
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"แบบสอบถาม";
}

-(void)setupView{
    
}


-(void)viewDidAppear:(BOOL)animated{
    [RestJSONWebServiceManager fetchJSONArrayOfClass:[AIMQuestionnaire class] fromURL:@"http://rbithai.com/ftpp/getQuestionnaireExample.php" module:@"STLM" updatedate:0 target:@"question" withParameters:nil success:^(NSNumber *statusCode, NSMutableArray *result, id responseObject) {
        self.datasource = [result copy];
        [self showQuestionnair:[self.datasource objectAtIndex:0]];
    } failure:^(NSNumber *statusCode, NSError *error) {
        NSLog(@"%@",[error description]);
    }];
}

-(void)showQuestionnair:(AIMQuestionnaire*)questionnaire{
    self.questionnaireVC = [[AIMQuestionnaireViewController alloc] initWithQuestionnaire:questionnaire];
    [self.questionnaireVC setDelegate:self];
    [self.questionnaireVC.view setFrame:self.view.bounds];
    [self.view addSubview:self.questionnaireVC.view];
}

-(void)questionnaire:(AIMQuestionnaireViewController *)questionnaire didFinishedWithResult:(AIMResult *)result{
    [self.questionnaireVC.view removeFromSuperview];
    [self performSegueWithIdentifier:@"showResult" sender:result];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"showResult"]){
        AIMResultViewController *rvc = (AIMResultViewController*)[segue destinationViewController];
        [rvc setResult:sender];
    }
}

@end
