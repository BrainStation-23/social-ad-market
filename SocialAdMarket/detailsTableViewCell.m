//
//  detailsTableViewCell.m
//  SocialAdMarket
//
//  Created by BS-126 on 12/3/15.
//  Copyright © 2015 Brainstation-23. All rights reserved.
//

#import "detailsTableViewCell.h"

@implementation detailsTableViewCell

- (void)awakeFromNib {
    //self.title.backgroundColor=[UIColor colorWithRed:(230/255.f) green:(245/255.f) blue:(240/255.f) alpha:1.0f];
    self.title.textColor=[UIColor colorWithRed:(48/255.f) green:(179/255.f) blue:(103/255.f) alpha:1.0f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
