//
//  FactsDisplayCellCell.m
//  PacteraAssessment
//
//  Created by Arun Ramakani on 12/19/14.
//  Copyright (c) 2014 Pactera. All rights reserved.
//

#import "FactsDisplayCellCell.h"


@implementation FactsDisplayCellCell


-(void) dealloc {
    
    // release retained property
    [_factTitleLabel release];
    [_factDiscriptionLabel release];
    [_factImage release];
    [_cellDivider release];
    [_cellAccesserImage release];
    
    _factTitleLabel         = nil;
    _factDiscriptionLabel   = nil;
    _cellDivider            = nil;
    _cellAccesserImage      = nil;
    
    [super dealloc];
}

//--------------------------------------------------------------------------------------------------
//	Function Name	:	initWithStyle:reuseIdentifier
//	Description		:   To configure custom cell with reusable identifier to re-use created cell object
//  param           :   [in] (NSString *) string to identify the re-usable cell
//	return			:	[out] viod
//--------------------------------------------------------------------------------------------------
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    // check if a cell can be reused from the reuse queue
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // setup primary label for fact title display
        _factTitleLabel                   = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, self.contentView.frame.size.width - 80, 50)];
        _factTitleLabel.font              = [UIFont systemFontOfSize:16];
        _factTitleLabel.lineBreakMode     = NSLineBreakByWordWrapping;
        _factTitleLabel.numberOfLines     = 0;
        _factTitleLabel.textAlignment     = NSTextAlignmentLeft;
        [_factTitleLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self.contentView addSubview:_factTitleLabel];
        
        // setup secondary lable for fact discription dispaly
        _factDiscriptionLabel                 = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, self.contentView.frame.size.width - 80, 50)];
        _factDiscriptionLabel.textAlignment   = NSTextAlignmentLeft;
        _factDiscriptionLabel.lineBreakMode   = NSLineBreakByWordWrapping;
        _factDiscriptionLabel.numberOfLines   = 0;
        _factDiscriptionLabel.font            = [UIFont systemFontOfSize:10];
        [_factDiscriptionLabel setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth];
        [self.contentView addSubview:_factDiscriptionLabel];
        
        // setup fact image
        _factImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width - 70, 20, 50, 50)];
        [_factImage setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
        [self.contentView addSubview:_factImage];
        
        // setup cell divider
        _cellDivider                    = [[UIImageView alloc] initWithFrame:CGRectMake(0, 65, 340, 1)];
        _cellDivider.backgroundColor    = [UIColor grayColor];
        [self.contentView addSubview:_cellDivider];
        
        //setup cell accesser iamge
        _cellAccesserImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        _cellAccesserImage.image=[UIImage imageNamed:@"atdJL.png"];
        self.accessoryView = _cellAccesserImage;
        
    }
    
    return self;
}


@end
