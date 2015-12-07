//
//  ItemElaborateDetailsViewController.m
//  SocialAdMarket
//
//  Created by Mahjabin Alam on 9/29/15.
//  Copyright (c) 2015 Brainstation-23. All rights reserved.
//

#import "ItemElaborateDetailsViewController.h"

@interface ItemElaborateDetailsViewController ()

@end

@implementation ItemElaborateDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"The Brief";
    self.dataArray=[[NSMutableArray alloc]init];
    [self loadDataArray];
    self.table.allowsSelection = NO;
    self.table.estimatedRowHeight=100.0;
    self.table.rowHeight = UITableViewAutomaticDimension;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void) viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden=YES;
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        
    }
    [super viewWillDisappear:animated];
}

#pragma mark- table view delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    detailsTableViewCell *cell = (detailsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"itemDetailsTableViewCell"];
    //int index=(int)indexPath.row;
    NSArray *array=[self.dataArray objectAtIndex:indexPath.row];
    
    //hfghgkdf
    //NSArray *array=[self.dataArray objectAtIndex:indexPath.row];
    NSString *title=[NSString stringWithFormat:@"%@",[array objectAtIndex:0]];
    NSString *subTitle=[NSString stringWithFormat:@"%@",[array objectAtIndex:1]];
    
    NSLog(@"%@", subTitle);
    
    UIFont *usedFont = [UIFont systemFontOfSize:19.0];
    CGSize maximumLabelSize = CGSizeMake(self.table.frame.size.width-10, CGFLOAT_MAX);
    CGRect textRect = [title boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:usedFont} context:nil];
    CGSize expectedLabelSize1 = CGSizeMake(textRect.size.width, textRect.size.height);
    cell.title.frame=CGRectMake(cell.title.frame.origin.x, cell.title.frame.origin.y, expectedLabelSize1.width, expectedLabelSize1.height);
    
    usedFont = [UIFont systemFontOfSize:14.0];
    maximumLabelSize = CGSizeMake(self.table.frame.size.width-10, CGFLOAT_MAX);
    
    
    textRect = [subTitle boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:usedFont} context:nil];
    
    
    CGSize expectedLabelSize2 = CGSizeMake(textRect.size.width, textRect.size.height);
    cell.subTitle.frame=CGRectMake(cell.subTitle.frame.origin.x, cell.subTitle.frame.origin.y, expectedLabelSize2.width, expectedLabelSize2.height);
    cell.title.numberOfLines=0;
    cell.subTitle.numberOfLines=0;
    
    cell.title.text=[NSString stringWithFormat:@"%@",[array objectAtIndex:0]];
    cell.subTitle.text= [NSString stringWithFormat:@"%@",[array objectAtIndex:1]];
    //cell.subTitle.backgroundColor=[UIColor blackColor];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //detailsTableViewCell *cell=(detailsTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSArray *array=[self.dataArray objectAtIndex:indexPath.row];
    
    NSString *title=[NSString stringWithFormat:@"%@",[array objectAtIndex:0]];
    NSString *subTitle=[NSString stringWithFormat:@"%@",[array objectAtIndex:1]];
    
    UIFont *usedFont = [UIFont systemFontOfSize:19.0];
    CGSize maximumLabelSize = CGSizeMake(self.table.frame.size.width-10, CGFLOAT_MAX);
    CGRect textRect = [title boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:usedFont} context:nil];
    CGSize expectedLabelSize1 = CGSizeMake(textRect.size.width, textRect.size.height);
    
    usedFont = [UIFont systemFontOfSize:14.0];
    maximumLabelSize = CGSizeMake(self.table.frame.size.width-10, CGFLOAT_MAX);
    textRect = [subTitle boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:usedFont} context:nil];
    CGSize expectedLabelSize2 = CGSizeMake(textRect.size.width, textRect.size.height);
    
    return expectedLabelSize1.height+15+expectedLabelSize2.height+20;
}

- (void) loadDataArray{
    if(self.flagForGigs==YES){
        NSArray *tmpArray=[[NSArray alloc]init];
        NSString *text1,*text2;
        text1=@"Intagram Handle";
        text2=self.gigsOfferList.IntagramHandle;
    //text2=@"hdyuigtryewotlkgdfnkjldsfjg;dfsjgklfdjg;lkjfgkldfjstioeruwtpiouerwptiofnmmgndfsmhjtrehthoeruwtioerwutiodjrglkdfnglfdnhs;jklgdfskl;gjdfsklgjklfsdjkl";
        tmpArray=[[NSArray alloc]initWithObjects:text1,text2, nil];
        [self.dataArray addObject:tmpArray];
        
        text1=@"Number Of Photos";
        text2=[NSString stringWithFormat:@"%li",(long)self.gigsOfferList.NumberOfPhotos];
        tmpArray=[[NSArray alloc]initWithObjects:text1,text2, nil];
        [self.dataArray addObject:tmpArray];
        
        text1=@"Offer Contact Email";
        text2=self.gigsOfferList.OfferContactEmail;
        tmpArray=[[NSArray alloc]initWithObjects:text1,text2, nil];
        [self.dataArray addObject:tmpArray];

        //[self.dataArray addObject:@"Offer Contact Name"];
        //[self.dataArray addObject:self.gigsOfferList.OfferContactName];
        
        text1=@"Offer Contact Number";
        text2=[NSString stringWithFormat:@"%li",(long)self.gigsOfferList.OfferContactNumber];
        tmpArray=[[NSArray alloc]initWithObjects:text1,text2, nil];
        [self.dataArray addObject:tmpArray];
        
        text1=@"Offer Contact Title";
        text2=self.gigsOfferList.OfferContactTitle;
        tmpArray=[[NSArray alloc]initWithObjects:text1,text2, nil];
        [self.dataArray addObject:tmpArray];
        
        text1=@"Offer Start Date & Time";
        text2=self.gigsOfferList.OfferStartDateTimeUtc;
        tmpArray=[[NSArray alloc]initWithObjects:text1,text2, nil];
        [self.dataArray addObject:tmpArray];
        
        text1=@"Offer End Date";
        text2=self.gigsOfferList.OfferEndDateTimeUtc;
        tmpArray=[[NSArray alloc]initWithObjects:text1,text2, nil];
        [self.dataArray addObject:tmpArray];
        
        text1=@"Posting Instructions";
        text2=self.gigsOfferList.PostingInstructions;
        tmpArray=[[NSArray alloc]initWithObjects:text1,text2, nil];
        [self.dataArray addObject:tmpArray];

        text1=@"Product Links";
        text2=self.gigsOfferList.ProductLinks;
        tmpArray=[[NSArray alloc]initWithObjects:text1,text2, nil];
        [self.dataArray addObject:tmpArray];
        
        text1=@"Product Name";
        text2=self.gigsOfferList.ProductNameOptional;
        tmpArray=[[NSArray alloc]initWithObjects:text1,text2, nil];
        [self.dataArray addObject:tmpArray];
        
        text1=@"Product To Feature";
        text2=self.gigsOfferList.ProductToFeature;
        tmpArray=[[NSArray alloc]initWithObjects:text1,text2, nil];
        [self.dataArray addObject:tmpArray];

        text1=@"Required In Caption";
        text2=self.gigsOfferList.RequiredInCaption;
        tmpArray=[[NSArray alloc]initWithObjects:text1,text2, nil];
        [self.dataArray addObject:tmpArray];
        
        text1=@"Rights";
        text2=self.gigsOfferList.Rights;
        tmpArray=[[NSArray alloc]initWithObjects:text1,text2, nil];
        [self.dataArray addObject:tmpArray];
        
        text1=@"Staying Days";
        text2=[NSString stringWithFormat:@"%li",(long)self.gigsOfferList.StayingDays];
        tmpArray=[[NSArray alloc]initWithObjects:text1,text2, nil];
        [self.dataArray addObject:tmpArray];

        text1=@"Style Instructions";
        text2=self.gigsOfferList.StyleInstructions;
        tmpArray=[[NSArray alloc]initWithObjects:text1,text2, nil];
        [self.dataArray addObject:tmpArray];
        
    }else{
        NSArray *tmpArray=[[NSArray alloc]init];
        NSString *text1,*text2;
        text1=@"Latitude";
        text2=self.offer.Latitude;
    //text2=@"hdyuigtryewotlkgdfnkjldsfjg;dfsjgklfdjg;lkjfgkldfjstioeruwtpiouerwptiofnmmgndfsmhjtrehthoeruwtioerwutiodjrglkdfnglfdnhs;jklgdfskl;gjdfsklgjklfsdjkl";
        tmpArray=[[NSArray alloc]initWithObjects:text1,text2, nil];
        [self.dataArray addObject:tmpArray];
        
        text1=@"Longitude";
        text2=self.offer.Longitude;
        tmpArray=[[NSArray alloc]initWithObjects:text1,text2, nil];
        [self.dataArray addObject:tmpArray];
        
        text1=@"Distance";
        text2=self.offer.Distance;
        tmpArray=[[NSArray alloc]initWithObjects:text1,text2, nil];
        [self.dataArray addObject:tmpArray];

        
        //[self.dataArray addObject:@"Offer Contact Name"];
        //[self.dataArray addObject:self.gigsOfferList.OfferContactName];
        
        
        
        text1=@"PictureUrl";
        text2=self.offer.PictureUrl;
        tmpArray=[[NSArray alloc]initWithObjects:text1,text2, nil];
        [self.dataArray addObject:tmpArray];
        
    }
}

@end
