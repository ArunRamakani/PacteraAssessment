//
//  FactsViewController.m
//  PacteraAssessment
//
//  This class mainly responsible for dispalying facts about the given title. This is inherited from table view controller which spports the implementation of
//  UIRefreshController. This conforms UITableViewDelegate, UITableViewDataSource standards to support table view display. This conforms UIScrollViewDelegate
//  standards to support scrolling call back. This also conforms FactsImageDownloadDelegate, FactsDataDelegate to support Fact list and image download.
//
//  Created by Arun Ramakani on 12/18/14.
//  Copyright (c) 2014 Pactera. All rights reserved.
//

#import "FactsViewController.h"
#import "Facts.h"
#import "FactsDisplayCellCell.h"

@interface FactsViewController ()

// Property to tarck image download process at any given instance
@property (nonatomic, retain) NSMutableDictionary   *factImageDownLoadTracker;

// Property to represent the list of Fact list
@property (nonatomic, retain) NSArray               *factList;

@end

@implementation FactsViewController

#pragma mark - View life cycle

-(void) dealloc {
    
    // release retained property
    [_factImageDownLoadTracker release];
    [_factList release];
    
    _factImageDownLoadTracker = nil;
    _factList                 = nil;
    
    [super dealloc];
    
}

-(id)init
{
    
    self = [super init];
    if(self){
    }
    return self;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // intialize image download tracker
    _factImageDownLoadTracker = [[NSMutableDictionary alloc] init];
    
    // Setup fact list table view style, delegate, datasourse, background color.
    self.tableView.delegate         = self;
    self.tableView.dataSource       = self;
    self.tableView.separatorStyle   = UITableViewCellSelectionStyleNone;
    self.tableView.backgroundColor  = [UIColor clearColor];
 
    // Setup UIRefreshControl component & Navigation bar right button to provide refresh functionality to facts List
    UIBarButtonItem *anotherButton          = [[UIBarButtonItem alloc] initWithTitle:REFRESH_TITLE style:UIBarButtonItemStylePlain
                                                                     target:self action:@selector(refreshFactListList:)];
    self.navigationItem.rightBarButtonItem  = anotherButton;
    self.refreshControl                     = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle     = [[[NSAttributedString alloc] initWithString:PULL_MESSAGE] autorelease];
    self.refreshControl.backgroundColor     = [UIColor yellowColor];
    [self.refreshControl addTarget:self action:@selector(getUpdatedFactData:) forControlEvents:UIControlEventValueChanged];
    
    // Initiate Automatic download for fist time load
    [self refreshFactListList:anotherButton];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
    // Calcel and remove all current image download process becuase we have memory preasure
    NSArray *inProgressImageDownload = [_factImageDownLoadTracker allValues];
    for(FactsDataManager *downloadProcess in inProgressImageDownload){
        [downloadProcess cancelDownload];
    }
    [_factImageDownLoadTracker removeAllObjects];
    
}

- (BOOL)shouldAutorotate:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - Facts List Download

//--------------------------------------------------------------------------------------------------
//	Function Name	:	refreshFactListList
//	Description		:   To initiate refresh of list of facts refresh button click
//	param			:	[in] id - initiater of the refresh action
//	return			:	[out] viod
//--------------------------------------------------------------------------------------------------
- (void)refreshFactListList:(id)sender {
    
    // initiate pull to refresh action
    [self.refreshControl beginRefreshing];
    [self getUpdatedFactData:self.refreshControl];
    
}

//--------------------------------------------------------------------------------------------------
//	Function Name	:	getUpdatedFactData
//	Description		:   To initiate refresh of list of facts on pull to refresh action
//	param			:	[in] (UIRefreshControl *) - refresh control reference
//	return			:	[out] viod
//--------------------------------------------------------------------------------------------------
-(void) getUpdatedFactData:(UIRefreshControl *)sender {

    // Update Pull to refresh title with inprogress status
    self.refreshControl.attributedTitle = [[[NSAttributedString alloc] initWithString:FETCH_STATUS] autorelease];
    
    // Initiate fact list downloas through Facts Data manager
    FactsDataManager *factsdata         = [[[FactsDataManager alloc] init] autorelease];
    factsdata.factsDownloadDelegate     = self;
    [factsdata getFacts];
    
    // disable refresh action , because pull to refresh is in progress
    self.navigationItem.rightBarButtonItem.enabled = false;
    
}

#pragma mark - FactsDataDelegate
//--------------------------------------------------------------------------------------------------
//	Function Name	:	factDownloadCompleted:facts:factTitle
//	Description		:   Delegate method call to handle fact download completion
//	param			:	[in] (NSArray *) - Downloaded fact List
//	param			:	[in] (NSString*) - Downloaded fact Title
//	return			:	[out] viod
//--------------------------------------------------------------------------------------------------
- (void) factDownloadCompleted:(NSArray*) facts factsTitle:(NSString*) factTitle{
    
    // Refresh only if you get a new fact list
    if(facts.count > 0) {
        
        // Calcel and remove all current image download process becuase we got a new fact list to display
        NSArray *inProgressImageDownload = [_factImageDownLoadTracker allValues];
        for(FactsDataManager *downloadProcess in inProgressImageDownload){
            [downloadProcess cancelDownload];
        }
        [_factImageDownLoadTracker removeAllObjects];
        
        // Network indicator should be hidden if its already displayed
        if(_factImageDownLoadTracker.count == 0 && [UIApplication sharedApplication].networkActivityIndicatorVisible){
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
        
        // Release the old facts and retain new facts
        [_factList release];
        [facts retain];
        _factList = facts;
        
        // Refresh table and update refresh control status
        [self.tableView reloadData];
        self.title = factTitle;
    } else if (facts == nil){
        // show error aleart on fact list down load failure
        NSLog(@"Fact list download error :: %@",factTitle);
    }
    
    //revert pull to refresh state
    [self.refreshControl endRefreshing];
    self.navigationItem.rightBarButtonItem.enabled = true;
    self.refreshControl.attributedTitle = [[[NSAttributedString alloc] initWithString:PULL_MESSAGE] autorelease];
    
}

#pragma mark - UITableView Data Source
//--------------------------------------------------------------------------------------------------
//	Function Name	:	tableView: numberOfRowsInSection
//	Description		:	returns the number of Rows in respective sections
//	param			:	[in] (UITableView *)tableView - TableView Object
//  param           :   [in] (NSInteger)section - section in the table view
//	return			:	[out] NSInteger - number of row
//-------------------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  _factList.count;
}

//--------------------------------------------------------------------------------------------------
//	Function Name	:	tableView:heightForRowAtIndexPath
//	Description		:	set the row height of the table
//  param           :   [in] (NSIndexPath *) represtent the table row index
//	param			:	[in] (UITableView *)tableView - TableView Object
//	return			:	[out] CGFloat - height of the given row
//-------------------------------------------------------------------------------------------------
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    // calculate dynamic label size
    Facts *factRow          = [_factList objectAtIndex:indexPath.row];
    CGSize constrainSize    = CGSizeMake(self.view.frame.size.width - 90, 150);
    CGSize sizeTitle        = [factRow.factTitle sizeWithFont:[UIFont systemFontOfSize:16]
                                     constrainedToSize:constrainSize
                                    lineBreakMode:NSLineBreakByWordWrapping];
    CGSize sizeDiscription  = [factRow.factDiscription sizeWithFont:[UIFont systemFontOfSize:10]
                                     constrainedToSize:constrainSize
                                         lineBreakMode:NSLineBreakByWordWrapping];
    
    // store calculated heights in fact reference
    factRow.factTitleLabelHeight        = sizeTitle.height;
    factRow.factDiscriptionLabelHeight  = sizeDiscription.height;
    factRow.factCellHeight              = (sizeTitle.height + sizeDiscription.height + 22) > 66 ? (sizeTitle.height + sizeDiscription.height + 22) : 66;

    return factRow.factCellHeight;
}

//--------------------------------------------------------------------------------------------------
//	Function Name	:	tableView:cellForRowAtIndexPath
//	Description		:	initialization of table view cells
//	param			:	[in] UITableView * - tableView for which cell has to be returned
//                  :   [in] NSIndexPath * - indexPath of the given table view row
//	return			:	[out] (UITableViewCell *) - Table view cell
//----------------------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Create reusable cell from custom cell object
    static NSString *cellIdentifier = @"FactsCell";
    FactsDisplayCellCell *cell = (FactsDisplayCellCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[FactsDisplayCellCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] autorelease];
    }

    // Set up data for current fact row
    Facts *factRow = [_factList objectAtIndex:indexPath.row];
    
    cell.factTitleLabel.text            = factRow.factTitle;
    cell.factDiscriptionLabel.text      = factRow.factDiscription;
    
    // setup cell image if availabel else provide a place holder image or no image
    if(factRow.factImageLink == nil){
        cell.factImage.image = [UIImage imageNamed:@"noImage.png"];
    } else {
        if(factRow.factImage == nil){
            cell.factImage.image = [UIImage imageNamed:@"default-placeholder.png"];
            if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
            {
                [self startImageDownload:factRow imageIndexPath:indexPath];
            }
        } else {
            cell.factImage.image = factRow.factImage;
        }
    }
    
    // set update frame for cell subviewes based on content size
    cell.factTitleLabel.frame       = CGRectMake(10, 6, cell.contentView.frame.size.width - 90, factRow.factTitleLabelHeight);
    cell.factDiscriptionLabel.frame = CGRectMake(10, factRow.factTitleLabelHeight + 9, cell.contentView.frame.size.width - 90, factRow.factDiscriptionLabelHeight);
    cell.factImage.frame            = CGRectMake(cell.contentView.frame.size.width - 70, factRow.factCellHeight/2 -25 , 50, 50);
    cell.cellDivider.frame          = CGRectMake(0, factRow.factCellHeight -1 , self.view.frame.size.width, 1);
    
    return cell;
}


#pragma mark - UIScrollViewDelegate

//-------------------------------------------------------------------------------------------------------------------
//	Function Name	:	scrollViewDidEndDragging:willDecelerate:
//	Description		:	delegate method call to indiacte scroll has end with decelerate and image date can be
//                  :   downloaded
//	param			:	[in] UIScrollView * - current view controller scroll view
//                  :   [in] BOOL  - decelerate state of the scroll action
//	return			:	[out] void
//-------------------------------------------------------------------------------------------------------------------
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self loadImagesForFacts];
    }
}

//-------------------------------------------------------------------------------------------------------------------
//	Function Name	:	scrollViewDidEndDecelerating:
//	Description		:	delegate method call to indiacte scroll has end and image date can be
//                  :   downloaded
//	param			:	[in] UIScrollView * - current view controller scroll view
//	return			:	[out] void
//-------------------------------------------------------------------------------------------------------------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
        [self loadImagesForFacts];
}

#pragma mark - Image Download

//-------------------------------------------------------------------------------------------------------------------
//	Function Name	:	loadImagesForFacts
//	Description		:	check if the imafe is already available for the given fact in visible table row , if not
//                  :   initiate image download
//	return			:	[out] void
//-------------------------------------------------------------------------------------------------------------------
- (void)loadImagesForFacts
{
    
    if ([self.factList count] > 0)
    {
        // get all visible row
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            // check of image, if no - start download
            Facts *fact = [self.factList objectAtIndex:indexPath.row];
            if (!fact.factImage)
            {
                [self startImageDownload:fact imageIndexPath:indexPath];
            }
        }
    }
    
}

//-------------------------------------------------------------------------------------------------------------------
//	Function Name	:	startImageDownload:fact:indexPath
//	Description		:	Start downloading image for the given fact.
//	return			:	[out] void
//-------------------------------------------------------------------------------------------------------------------
-(void) startImageDownload:(Facts*) fact imageIndexPath:(NSIndexPath*) indexPath{
    
    // Check if the image down process is already in forgress, if not start new download process
    FactsDataManager *factImageDownloadProcess = [_factImageDownLoadTracker objectForKey:indexPath];
    
    if (factImageDownloadProcess == nil){
        
        // Use facts data manager to download image
        factImageDownloadProcess = [[[FactsDataManager alloc] init] autorelease];
        factImageDownloadProcess.factForImageDownload = fact;
        factImageDownloadProcess.imageIndexPath = indexPath;
        factImageDownloadProcess.imageDownloadDelegate = self;
        [_factImageDownLoadTracker setObject:factImageDownloadProcess forKey:indexPath];
        [factImageDownloadProcess startImageDownload];
        
        // Make the activity indicator visible as image download started
        if(![UIApplication sharedApplication].networkActivityIndicatorVisible){
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        }
    }
    
}

#pragma mark - FactsImageDownloadDelegate

//--------------------------------------------------------------------------------------------------
//	Function Name	:	factImageDownloadCompleted:facts:imageIndexPath
//	Description		:   Delegate method call to handle fact download completion
//	param			:	[in] (Facts *) - Fact for wich image is downloaded downloaded
//	param			:	[in] (NSIndexPath*) - Fact index to be updated
//	return			:	[out] viod
//--------------------------------------------------------------------------------------------------
- (void) factImageDownloadCompleted:(Facts*) fact imageIndexPath:(NSIndexPath*) imageIndexPath {
    
    // Access the fact Cell to upadate image
    FactsDisplayCellCell *cell  = (FactsDisplayCellCell*)[self.tableView cellForRowAtIndexPath:imageIndexPath];
    cell.factImage.image        = fact.factImage;
    Facts *factListRef          = [self.factList objectAtIndex:imageIndexPath.row];
    factListRef.factImage       = fact.factImage;
    
    // Remove the image download process from tracker
    [_factImageDownLoadTracker removeObjectForKey:imageIndexPath];
    
    // if image download tracker count is zero remove process indicator
    if(_factImageDownLoadTracker.count == 0 && [UIApplication sharedApplication].networkActivityIndicatorVisible){
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
    
    
}


@end
