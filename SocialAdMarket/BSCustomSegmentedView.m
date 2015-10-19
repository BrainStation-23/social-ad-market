//
//  CustomSegmentedView.m
//  SocialAdMarket
//
//  Created by Mahjabin Alam on 9/29/15.
//  Copyright (c) 2015 Brainstation-23. All rights reserved.
//

#import "BSCustomSegmentedView.h"


@implementation BSCustomSegmentedView

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        [self setBackgroundColor:[self colorFromHexString:@"#606060"]];
     
        self.gigsButton= [[UIButton alloc]initWithFrame: CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height)];
        self.gigsButton.titleLabel.textColor=[UIColor whiteColor];
        [self.gigsButton setTitle:@"Gigs" forState:UIControlStateNormal];
        self.gigsButton.tag=1;
        [self addSubview:self.gigsButton];
        [self.gigsButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        self.localButton= [[UIButton alloc]initWithFrame: CGRectMake(self.frame.size.width/2, 0, self.frame.size.width/2, self.frame.size.height)];
        self.localButton.titleLabel.textColor=[UIColor whiteColor];
        [self.localButton setTitle:@"Local" forState:UIControlStateNormal];
        self.localButton.tag=2;
        [self addSubview:self.localButton];
        [self.localButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}



-(IBAction)buttonClicked:(id)sender{
    UIButton *button = (UIButton*)sender;
    
    if(button.tag==1)
    {
        [self.gigsButton setBackgroundColor:[UIColor darkGrayColor]];
        [self.localButton setBackgroundColor:[UIColor clearColor]];
        [self setLeftCorners:self.gigsButton];
        [self.delegate selectedOption:self.gigsButton];
    }
    else
    {
        [self.gigsButton setBackgroundColor:[UIColor clearColor]];
        [self.localButton setBackgroundColor:[UIColor darkGrayColor]];
        [self setRightCorners:self.localButton];
        [self.delegate selectedOption:self.localButton];
    }
    
}

#pragma mark-
#pragma mark- set corner radius for buttons


-(void)setLeftCorners:(UIButton*)button{
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:button.bounds
                                     byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerTopLeft)
                                           cornerRadii:CGSizeMake(5.0, 5.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    button.layer.mask = maskLayer;
}

-(void)setRightCorners:(UIButton*)button{
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:button.bounds
                                     byRoundingCorners:(UIRectCornerBottomRight|UIRectCornerTopRight)
                                           cornerRadii:CGSizeMake(5.0, 5.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    button.layer.mask = maskLayer;
}

#pragma mark-
#pragma mark- Rgb Color from Hex Color code

-(UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:0.6];
}

@end
