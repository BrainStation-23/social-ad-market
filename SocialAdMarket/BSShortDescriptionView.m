//
//  BSShortDescriptionView.m
//  SocialAdMarket
//
//  Created by BS23 on 10/5/15.
//  Copyright (c) 2015 Brainstation-23. All rights reserved.
//

#import "BSShortDescriptionView.h"

@implementation BSShortDescriptionView

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        self.briefDescriptionLabel.selectable=NO;
        self.briefDescriptionLabel.editable=NO;
        self.backgroundColor=[UIColor whiteColor];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, self.bounds.size.width-40, 25)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
         self.titleLabel.text = @"Test Title";
        [self addSubview: self.titleLabel];
        
        self.briefDescriptionLabel = [[UITextView alloc] initWithFrame:CGRectMake(20, self.titleLabel.bounds.size.height+20, self.bounds.size.width-40, 50)];
        self.briefDescriptionLabel.backgroundColor = [UIColor clearColor];
        self.briefDescriptionLabel.textColor = [UIColor grayColor];
        //self.briefDescriptionLabel.numberOfLines = 2;
        //self.briefDescriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.briefDescriptionLabel.text = @"Telechargez et consultez les catalogues et les tarifs de la gamme Audi au format PDF";
        [self addSubview: self.briefDescriptionLabel];
        
        
        self.swapButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.swapButton setTitle:@"You need more followers" forState:UIControlStateNormal];
        self.swapButton.frame = CGRectMake(20, self.bounds.size.height-50, self.titleLabel.bounds.size.width-40, 40);
        [self addSubview:self.swapButton];
       
    }
    return self;
}

@end
