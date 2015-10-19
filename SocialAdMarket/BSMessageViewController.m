//
//  BSMessageViewController.m
//  SocialAdMarket
//
//  Created by BS23 on 10/13/15.
//  Copyright (c) 2015 Brainstation-23. All rights reserved.
//

#import "BSMessageViewController.h"

@interface BSMessageViewController ()

@end

@implementation BSMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate=self;
    self.placeHolderTextLabel.text = @"When a merchant wants to contact you about a paid gig or swap the messages will appear here.";
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
        SocialAddMarketViewController *vc =[storyBoard instantiateViewControllerWithIdentifier:@"BSMainViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(sender.tag==2){
        BSMapViewController *vc =[storyBoard instantiateViewControllerWithIdentifier:@"BSMapViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(sender.tag==4){
        BSProfileViewController *vc= [storyBoard instantiateViewControllerWithIdentifier:@"BSProfileViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
@end