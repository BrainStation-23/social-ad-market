//
//  PopularPayTableViewCell.h
//  SocialAdMarket
//
//  Created by Mahjabin Alam on 9/29/15.
//  Copyright (c) 2015 Brainstation-23. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopularPayTableViewCell : UITableViewCell

@property(nonatomic, strong) IBOutlet UILabel *ppTitle;
@property(nonatomic, strong) IBOutlet UILabel *ppSubTitle;
@property(nonatomic, strong) IBOutlet UILabel *ppFollowers;
@property(nonatomic, strong) IBOutlet UILabel *ppDistance;
@property(nonatomic, strong) IBOutlet UIImageView *ppImageView;


@end
