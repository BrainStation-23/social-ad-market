//
//  SAMSettingsViewController.m
//  SocialAdMarket
//
//  Created by Mahjabin Alam on 10/15/15.
//  Copyright (c) 2015 Brainstation-23. All rights reserved.
//

#import "SAMSettingsViewController.h"
#import "BSUserPropertiesAndAssets.h"
#import "SAMChangeEmailViewController.h"

@interface SAMSettingsViewController (){
    NSArray *sectionLabelArray;
    BSUserPropertiesAndAssets *userAssets;
    MFMailComposeViewController *mailComposer;
    SAMChangeEmailViewController *changeEmailViewController;
    SuggestMerchantViewController *suggestMerchantViewController;
}

@end

@implementation SAMSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    userAssets =[BSUserPropertiesAndAssets sharedInstance];
    sectionLabelArray =[[NSArray alloc]initWithObjects:@"Help", @"Contact", @"General", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(IBAction)goBack:(id)sender{
 
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark- TableView Data source methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==0){
        return 1;
    }
    else if (section==1){
        return 3;
    }
    else{
        return 2;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
   
    return [sectionLabelArray objectAtIndex:section];
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, tableView.frame.size.width, 30)];
    NSString *sectionTitle =[sectionLabelArray objectAtIndex:section];
    label.font= [UIFont fontWithName:@"Iowan Old" size:20.0];
    [label setText:sectionTitle];
    [headerView addSubview:label];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:@"settingsCell"];
    
    if(indexPath.section==0){
        cell.textLabel.text = @"FAQ";
        cell.accessoryType= UITableViewCellAccessoryNone;
    }
    else if (indexPath.section==1){
        if(indexPath.row==0){
            cell.textLabel.text = @"Email Us";
        }
        else if (indexPath.row==1){
            cell.textLabel.text = @"Change Contact Email";
        }
        else{
            cell.textLabel.text = @"Suggest a Merchant";
        }
    }
    else{
        if(indexPath.row==0){
            cell.textLabel.text = @"Rate Us in App Store";
        }
        else{
            cell.textLabel.text = @"Terms Of Service";
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50.0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1 && indexPath.row==0){
        [self presentEmailView];
    }
    else if(indexPath.section == 1 && indexPath.row==1){
        [self presentChangeEmailAddressView];
    }
    else if(indexPath.section == 1 && indexPath.row==2){
        [self presentSearchBusinessView];
    }
}


#pragma mark-
#pragma mark- utility method

-(void)presentEmailView{
    NSString *userName = [[userAssets getUerInformation] objectForKey:@"userName"];
 
    NSString *emailTitle =[ userName stringByAppendingString: @" has feedback"];
    NSArray *reciepent = [NSArray arrayWithObject:@"help@popularpays.com"];
    
    mailComposer = [[MFMailComposeViewController alloc] init];
    mailComposer.mailComposeDelegate = self;
    [mailComposer setSubject:emailTitle];
    [mailComposer setToRecipients:reciepent];
    
    [self presentViewController:mailComposer animated:YES completion:nil];
}

-(void)presentChangeEmailAddressView{
    changeEmailViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChangeEmailViewController"];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    self.navigationController.navigationBarHidden=YES;
    
    [self.navigationController pushViewController:changeEmailViewController animated:YES];
}

-(void)presentSearchBusinessView{
    suggestMerchantViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SuggestMerchantViewController"];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    self.navigationController.navigationBarHidden=YES;
    
    [self.navigationController pushViewController:suggestMerchantViewController animated:YES];
}

#pragma mark -
#pragma mark - Mail Compose delegate

-(void)mailComposeController:(MFMailComposeViewController *)controller
         didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if (result) {
        NSLog(@"Result : %d",result);
    }
    if (error) {
        NSLog(@"Error : %@",error);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


@end
