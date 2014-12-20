//
//  FactsViewController.h
//  PacteraAssessment
//
//  Created by Arun Ramakani on 12/18/14.
//  Copyright (c) 2014 Pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FactsDataManager.h"

@interface FactsViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate,FactsImageDownloadDelegate, FactsDataDelegate>

@property (nonatomic, retain) UITableView *factListTable;
@property (nonatomic, retain) NSArray *factList;


@end

