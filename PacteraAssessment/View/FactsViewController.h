//
//  FactsViewController.h
//  PacteraAssessment
//
//  This class mainly responsible for dispalying facts about the given title. This is inherited from table view controller which spports the implementation of
//  UIRefreshController. This conforms UITableViewDelegate, UITableViewDataSource standards to support table view display. This conforms UIScrollViewDelegate
//  standards to support scrolling call back. This also conforms FactsImageDownloadDelegate, FactsDataDelegate to support Fact list and image download.
//
//  Created by Arun Ramakani on 12/18/14.
//  Copyright (c) 2014 Pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FactsDataManager.h"


#define REFRESH_TITLE @"Refresh"
#define PULL_MESSAGE  @"Pull to refresh ..."
#define FETCH_STATUS  @"Fetch data ..."


@interface FactsViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate,FactsImageDownloadDelegate, FactsDataDelegate>


@end

