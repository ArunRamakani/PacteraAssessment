//
//  FactsViewController.m
//  PacteraAssessment
//
//  Created by Arun Ramakani on 12/18/14.
//  Copyright (c) 2014 Pactera. All rights reserved.
//

#import "FactsViewController.h"
#import "Facts.h"
#import "FactsDisplayCellCell.h"

@interface FactsViewController ()

@property (nonatomic, retain) NSMutableDictionary *factImageDownLoadTracker;

@end

@implementation FactsViewController

-(id)init
{
    self = [super init];
    if(self){
        _factImageDownLoadTracker = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStylePlain
                                                                     target:self action:@selector(refreshFactListList:)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    
  
   
    _factListTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, 340, 200)];
    _factListTable.delegate = self;
    _factListTable.separatorStyle = UITableViewCellSelectionStyleNone;
    _factListTable.dataSource = self;
  
    [_factListTable setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin];
    
    
    self.tableView = _factListTable;
    self.tableView.backgroundColor = [UIColor clearColor];
  
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getUpdatedFactData:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to refresh ..."];
    self.refreshControl.backgroundColor = [UIColor yellowColor];
    [self refreshFactListList:anotherButton];
    
}

- (void)refreshFactListList:(id)sender {
    
    [self.refreshControl beginRefreshing];
    [self getUpdatedFactData:self.refreshControl];
}


-(void) getUpdatedFactData:(UIRefreshControl *)sender {
    
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Fetch data ..."];
    FactsDataManager *factsdata = [[FactsDataManager alloc] init];
    factsdata.factsDownloadDelegate = self;
    [factsdata getFacts];
    self.navigationItem.rightBarButtonItem.enabled = false;
    
    
}

- (void) factDownloadCompleted:(NSArray*) facts factsTitle:(NSString*) factTitle{
    if(facts.count > 0) {
        
        
        NSArray *inProgressImageDownload = [_factImageDownLoadTracker allValues];
        for(FactsDataManager *downloadProcess in inProgressImageDownload){
            [downloadProcess cancelDownload];
        }
        [_factImageDownLoadTracker removeAllObjects];
        if(_factImageDownLoadTracker.count == 0 && [UIApplication sharedApplication].networkActivityIndicatorVisible){
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
        
        _factList = facts;
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
        self.navigationItem.rightBarButtonItem.enabled = true;
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to refresh ..."];
        self.title = factTitle;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  _factList.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"FactsCell";
    
    // Similar to UITableViewCell, but
    FactsDisplayCellCell *cell = (FactsDisplayCellCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[FactsDisplayCellCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    // Just want to test, so I hardcode the data

    
    // Leave cells empty if there's no data yet
    Facts *factRow = [_factList objectAtIndex:indexPath.row];
    
    cell.primaryLabel.text = factRow.factTitle;
    cell.secondaryLabel.text = factRow.factDiscription;
    if(factRow.factImageLink == nil){
        cell.myImageView.image = [UIImage imageNamed:@"latest.png"];
    } else {
        if(factRow.factImage == nil) {
            cell.myImageView.image = [UIImage imageNamed:@"default-placeholder.png"];
            if (_factListTable.dragging == NO && _factListTable.decelerating == NO)
            {
                [self startImageDownload:factRow imageIndexPath:indexPath];
            }
        } else {
            cell.myImageView.image = factRow.factImage;
        }
        
    }
    
    return cell;
}


#pragma mark - UIScrollViewDelegate

// -------------------------------------------------------------------------------
//	scrollViewDidEndDragging:willDecelerate:
//  Load images for all onscreen rows when scrolling is finished.
// -------------------------------------------------------------------------------
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self loadImagesForFacts];
    }
}

// -------------------------------------------------------------------------------
//	scrollViewDidEndDecelerating:
// -------------------------------------------------------------------------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
        [self loadImagesForFacts];
}




// -------------------------------------------------------------------------------
//	loadImagesForOnscreenRows
//  This method is used in case the user scrolled into a set of cells that don't
//  have their app icons yet.
// -------------------------------------------------------------------------------
- (void)loadImagesForFacts
{
    if ([self.factList count] > 0)
    {
        NSArray *visiblePaths = [self.factListTable indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            Facts *fact = [self.factList objectAtIndex:indexPath.row];
            
            if (!fact.factImage)
            {
                [self startImageDownload:fact imageIndexPath:indexPath];
            }
        }
    }
}

-(void) startImageDownload:(Facts*) fact imageIndexPath:(NSIndexPath*) indexPath{
    FactsDataManager *factImageDownloadProcess = [_factImageDownLoadTracker objectForKey:indexPath];
    
    if (factImageDownloadProcess == nil){
        factImageDownloadProcess = [[FactsDataManager alloc] init];
        factImageDownloadProcess.factForImageDownload = fact;
        factImageDownloadProcess.imageIndexPath = indexPath;
        factImageDownloadProcess.imageDownloadDelegate = self;
        [_factImageDownLoadTracker setObject:factImageDownloadProcess forKey:indexPath];
        [factImageDownloadProcess startImageDownload];
        if(![UIApplication sharedApplication].networkActivityIndicatorVisible){
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        }
    }
}


#pragma mark - FactsImageDownloadDelegate

- (void) factImageDownloadCompleted:(Facts*) fact imageIndexPath:(NSIndexPath*) imageIndexPath {
    

    FactsDisplayCellCell *cell = (FactsDisplayCellCell*)[_factListTable cellForRowAtIndexPath:imageIndexPath];
    cell.myImageView.image = fact.factImage;
    Facts *factListRef = [self.factList objectAtIndex:imageIndexPath.row];
    factListRef.factImage = fact.factImage;
    [_factImageDownLoadTracker removeObjectForKey:imageIndexPath];
    
    if(_factImageDownLoadTracker.count == 0 && [UIApplication sharedApplication].networkActivityIndicatorVisible){
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
    
    
}

@end
