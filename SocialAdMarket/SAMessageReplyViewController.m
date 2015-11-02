//
//  SAMessageReplyViewController.m
//  SocialAdMarket
//
//  Created by BS-125 on 10/30/15.
//  Copyright (c) 2015 Brainstation-23. All rights reserved.
//

#import "SAMessageReplyViewController.h"
#import "APIManager.h"
#import "SAMUserPropertiesAndAssets.h"
#import "SVProgressHUD.h"
@interface SAMessageReplyViewController ()<APIManagerDelegate,UITextFieldDelegate,UITextViewDelegate>{
    

    __weak IBOutlet UILabel *toLabel;
    
    __weak IBOutlet UITextView *messageTextView;
    __weak IBOutlet UITextField *subjectText;
}

@end

@implementation SAMessageReplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    toLabel.text = self.IBD.FromCustomerId;
    subjectText.text = self.IBD.Subject;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)sentBtnAct:(id)sender {
    
    
    if(messageTextView.text.length>0){
        
        [SVProgressHUD showWithStatus:@"Loading..."];
        
    SAMUserPropertiesAndAssets *userProperties = [SAMUserPropertiesAndAssets sharedInstance];
    APIManager *manager = [APIManager sharedManager];
    manager.delegate=self;
    NSDictionary *parameters = @{@"ToCustomerId": self.IBD.FromCustomerId,@"Subject": subjectText.text,@"Text": messageTextView.text};
    [manager replyMessage:[userProperties getUserID] WithParameters:parameters];
    }
    else{
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please, enter all the required information correctly." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];

        
    }
    

    
}

- (IBAction)cancelBtnAct:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark-
#pragma mark- APIManager Delegate methods

-(void)successFullySentMessage{
    
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark-
#pragma mark- UITextField Delegate methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //    NSLog(@"textFieldShouldReturn:");
    
    [textField resignFirstResponder];
       return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    
    [textView resignFirstResponder];
    
    return YES;
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
