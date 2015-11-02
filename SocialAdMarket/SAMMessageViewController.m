//
//  SAMMessageViewController.m
//  SocialAdMarket
//
//  Created by BS23 on 10/13/15.
//  Copyright (c) 2015 Brainstation-23. All rights reserved.
//

#import "SAMMessageViewController.h"
#import "SAMUserPropertiesAndAssets.h"
#import "APIManager.h"
#import "InboxTableViewCell.h"
#import "InboxDetails.h"
#import "SAMessageDetailsViewController.h"
#import "SVProgressHUD.h"
@interface SAMMessageViewController ()<UITableViewDataSource,UITableViewDelegate,APIManagerDelegate>{
    
    
    __weak IBOutlet UITableView *sentItemsTableView;
    NSMutableArray *sentItemsArray;
    NSMutableArray *inboxItemArray;
    __weak IBOutlet UISegmentedControl *segmentBtn;
    
    NSInteger segmentBtnIndex;
    
    __weak IBOutlet UILabel *toOrFromLable;
    
}

@end

@implementation SAMMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate=self;
    
    
//    SAMUserPropertiesAndAssets *userProperties = [SAMUserPropertiesAndAssets sharedInstance];
//    APIManager *manager = [APIManager sharedManager];
//    manager.delegate=self;
//    [manager getInboxItems:[userProperties getUserID]];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [SVProgressHUD showWithStatus:@"Loading..."];
    
    if(segmentBtn.selectedSegmentIndex==0){
        
        toOrFromLable.text=@"From";
        
        segmentBtnIndex=0;
        
        SAMUserPropertiesAndAssets *userProperties = [SAMUserPropertiesAndAssets sharedInstance];
        APIManager *manager = [APIManager sharedManager];
        manager.delegate=self;
        [manager getInboxItems:[userProperties getUserID]];
        
        
        
    }
    else if (segmentBtn.selectedSegmentIndex==1){
    
        segmentBtnIndex=1;
        toOrFromLable.text=@"To";

        
        SAMUserPropertiesAndAssets *userProperties = [SAMUserPropertiesAndAssets sharedInstance];
        APIManager *manager = [APIManager sharedManager];
        manager.delegate=self;
        [manager getSentItems:[userProperties getUserID]];
    }
    

    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)segmentBtnAct:(id)sender {
    
  
    [SVProgressHUD showWithStatus:@"Loading..."];
  
    
    if(segmentBtn.selectedSegmentIndex==0){
        
        segmentBtnIndex=0;
        toOrFromLable.text=@"From";

        
        SAMUserPropertiesAndAssets *userProperties = [SAMUserPropertiesAndAssets sharedInstance];
        APIManager *manager = [APIManager sharedManager];
        manager.delegate=self;
        [manager getInboxItems:[userProperties getUserID]];
        

        
    }
    else if (segmentBtn.selectedSegmentIndex==1){
        
        segmentBtnIndex=1;

        toOrFromLable.text=@"To";

        SAMUserPropertiesAndAssets *userProperties = [SAMUserPropertiesAndAssets sharedInstance];
        APIManager *manager = [APIManager sharedManager];
        manager.delegate=self;
        [manager getSentItems:[userProperties getUserID]];
    }
    
    
}


#pragma mark-
#pragma mark- TableView Datasource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(segmentBtnIndex==0)
    return [inboxItemArray count];
    else if (segmentBtnIndex==1)
        return [sentItemsArray count];
    
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"InboxTableViewCell";
    InboxTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (InboxTableViewCell *)[topLevelObjects objectAtIndex:0];
        [cell.detailsBtn addTarget:self action:@selector(editBtnAct:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.detailsBtn.tag = indexPath.row;

    InboxDetails *IBD;
    if(segmentBtnIndex==0){
      IBD  = [inboxItemArray objectAtIndex:indexPath.row];
        
        cell.nameLabel.text = IBD.CustomerFromName;
        cell.subjectLabel.text = IBD.Subject;
        cell.dateLabel.text = IBD.CreatedOn;

    }else if (segmentBtnIndex==1)
    {
      IBD = [sentItemsArray objectAtIndex:indexPath.row];
        
        cell.nameLabel.text = IBD.CustomerToName;
        cell.subjectLabel.text = IBD.Subject;
        cell.dateLabel.text = IBD.CreatedOn;

    }

    
    
    return cell;
}

#pragma mark-
#pragma mark- APIManager Delegate methods

-(void)gotSentItems:(NSArray *)sentItems{

    
    [SVProgressHUD dismiss];
    sentItemsArray = [sentItems copy];
    [sentItemsTableView reloadData];
    
    
    
}

-(void)gotInboxItems:(NSArray *)inboxItems{
    
    
    [SVProgressHUD dismiss];
    inboxItemArray = [inboxItems copy];
    [sentItemsTableView reloadData];
    
    
}


- (void)editBtnAct:(UIButton*)sender {

    InboxDetails * IBD;
    SAMessageDetailsViewController* MDVC = [[SAMessageDetailsViewController alloc] initWithNibName:@"SAMessageDetailsViewController" bundle:nil];

    if(segmentBtnIndex==0){
        IBD  = [inboxItemArray objectAtIndex:sender.tag];
        MDVC.flagForReplyBtn=YES;

     }else if (segmentBtnIndex==1)
     {
        IBD = [sentItemsArray objectAtIndex:sender.tag];
         MDVC.flagForReplyBtn=NO;

     }

    
    
         MDVC.IBD = IBD;
        [self.navigationController pushViewController:MDVC animated:YES];
}

#pragma mark-
#pragma mark- TableView Delegate methods



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
    
}








- (void)loadView:(UIButton *)sender {
    DELEGATE.segmentedView.hidden=YES;
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.4;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    
    UIStoryboard *storyBoard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    if(sender.tag==1){
        SocialAddMarketViewController *vc =[storyBoard instantiateViewControllerWithIdentifier:@"MainViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(sender.tag==2){
        SAMMapViewController *vc =[storyBoard instantiateViewControllerWithIdentifier:@"MapViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(sender.tag==4){
        SAMProfileViewController *vc= [storyBoard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
@end
