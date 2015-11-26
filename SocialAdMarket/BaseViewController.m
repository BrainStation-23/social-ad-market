//
//  BaseViewController.m
//  SocialAdMarket
//
//  Created by Mahjabin Alam on 10/15/15.
//  Copyright (c) 2015 Brainstation-23. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.expandButtonLabel = [self createExpandableButtonView];
    
    self.expandableMenu = [[DWBubbleMenuButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - self.expandButtonLabel.frame.size.width - 20.f, self.view.frame.size.height - self.expandButtonLabel.frame.size.height - 20.f, self.expandButtonLabel.frame.size.width, self.expandButtonLabel.frame.size.height) expansionDirection:DirectionLeft];
    
    self.expandableMenu.homeButtonView = self.expandButtonLabel;
    [self.expandableMenu addButtons:[self createBottomAnimatedButtons]];
    [self.view addSubview:self.expandableMenu];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}


- (UILabel *)createExpandableButtonView {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 40.f, 40.f)];
    label.text = @"+";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.cornerRadius = label.frame.size.height / 2.f;
    label.backgroundColor =[UIColor colorWithRed:45/255.0 green:166/255.0 blue:80/255.0 alpha:1];
    label.clipsToBounds = YES;
    
    return label;

}


- (NSArray *)createBottomAnimatedButtons {
    NSMutableArray *buttonsMutable = [[NSMutableArray alloc] init];
    
    UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [listButton setBackgroundImage:[UIImage imageNamed:@"list.png"] forState:UIControlStateNormal];
    [buttonsMutable addObject:listButton];
    
    UIButton *mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [mapButton setBackgroundImage:[UIImage imageNamed:@"map.png"] forState:UIControlStateNormal];
    [buttonsMutable addObject:mapButton];
    
    UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [messageButton setBackgroundImage:[UIImage imageNamed:@"message.png"] forState:UIControlStateNormal];
    [buttonsMutable addObject:messageButton];
    
    UIButton *profileButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [profileButton setBackgroundImage:[UIImage imageNamed:@"profile.png"] forState:UIControlStateNormal];
    [buttonsMutable addObject:profileButton];
    
    int i=1;
    for (UIButton *button in buttonsMutable) {
        button.frame = CGRectMake(0.f, 0.f, 36.f, 36.f);
        button.layer.cornerRadius = button.frame.size.height / 2.f;
        button.backgroundColor = [UIColor colorWithRed:45/255.0 green:166/255.0 blue:80/255.0 alpha:1];
        //[UIColor clearColor];
        button.clipsToBounds = YES;
        button.tag = i++;
        
        [button addTarget:self action:@selector(loadView:) forControlEvents:UIControlEventTouchUpInside];
    }
    return [buttonsMutable copy];
}


- (UIButton *)createButtonWithName:(NSString *)imageName {
    
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button sizeToFit];
    [button addTarget:self action:@selector(loadView:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (BOOL)prefersStatusBarHidden {
    return true;
}

- (void)loadView:(UIButton *)sender {
    [self.delegate loadView:sender];
    
}
@end
