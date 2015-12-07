//
//  ItemElaborateDetailsViewController.h
//  SocialAdMarket
//
//  Created by Mahjabin Alam on 9/29/15.
//  Copyright (c) 2015 Brainstation-23. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSOfferDetails.h"
#import "detailsTableViewCell.h"
#import "GigsOfferList.h"

@interface ItemElaborateDetailsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) IBOutlet UITableView *table;
@property (readwrite, nonatomic) BSOfferDetails *offer;
@property (nonatomic, retain) GigsOfferList *gigsOfferList;
@property BOOL flagForGigs;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end
