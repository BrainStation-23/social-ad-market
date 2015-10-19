//
//  CustomSegmentedView.h
//  SocialAdMarket
//
//  Created by Mahjabin Alam on 9/29/15.
//  Copyright (c) 2015 Brainstation-23. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol BSCustomSegmentedViewDelegate;

@interface BSCustomSegmentedView : UIView

@property(nonatomic, strong) IBOutlet UIButton *gigsButton;
@property(nonatomic, strong) IBOutlet UIButton *localButton;

@property(nonatomic, weak) id<BSCustomSegmentedViewDelegate> delegate;

-(IBAction)buttonClicked:(id)sender;


@end


@protocol BSCustomSegmentedViewDelegate <NSObject>

-(void)selectedOption:(UIButton*)sender;

@end