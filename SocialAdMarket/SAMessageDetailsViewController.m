//
//  SAMessageDetailsViewController.m
//  SocialAdMarket
//
//  Created by BS-125 on 10/30/15.
//  Copyright (c) 2015 Brainstation-23. All rights reserved.
//

#import "SAMessageDetailsViewController.h"
#import "APIManager.h"
#import "SAMUserPropertiesAndAssets.h"
#import "SAMessageReplyViewController.h"
#import "SVProgressHUD.h"
@interface SAMessageDetailsViewController ()<APIManagerDelegate>{
    
    __weak IBOutlet UILabel *fromLabel;
    __weak IBOutlet UILabel *toLable;
    __weak IBOutlet UILabel *detailMessage;
    __weak IBOutlet UILabel *subjectLabel;
    __weak IBOutlet UIButton *replyBtn;
    
}

@end

@implementation SAMessageDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    fromLabel.text = self.IBD.CustomerFromName;
    toLable.text = self.IBD.CustomerToName;
    subjectLabel.text = self.IBD.Subject;
    detailMessage.text = self.IBD.Message;
    
    if(self.flagForReplyBtn){
        replyBtn.hidden=NO;
        [SVProgressHUD showWithStatus:@"Loading..."];
        SAMUserPropertiesAndAssets *userProperties = [SAMUserPropertiesAndAssets sharedInstance];
        APIManager *manager = [APIManager sharedManager];
        manager.delegate=self;
        [manager viewUserInboxMessage:[userProperties getUserID] WithId:self.IBD.Id];

    }
    else
        replyBtn.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backBtnAct:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)replyBtnAct:(id)sender {
    
    SAMessageReplyViewController *saMRVC = [[SAMessageReplyViewController alloc] initWithNibName:@"SAMessageReplyViewController" bundle:nil];
    saMRVC.IBD = self.IBD;
    [self.navigationController pushViewController:saMRVC animated:YES];
   
}
- (IBAction)deleteBtnAct:(id)sender {
    
    [SVProgressHUD showWithStatus:@"Loading..."];
    SAMUserPropertiesAndAssets *userProperties = [SAMUserPropertiesAndAssets sharedInstance];
    APIManager *manager = [APIManager sharedManager];
    manager.delegate=self;
    [manager deleteMessage:[userProperties getUserID] WithId:self.IBD.Id];
}

#pragma mark-
#pragma mark- APIManager Delegate methods


-(void)successFullyDeleteMessage{
    
    [SVProgressHUD dismiss];

    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)successFullyReadMessage{
    
    
    [SVProgressHUD dismiss];
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
