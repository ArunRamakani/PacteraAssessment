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
    [_primaryLabel release];
    [_secondaryLabel release];
    [_factImage release];
    [_cellDivider release];
    [_cellAccesserImage release];
    
    _primaryLabel       = nil;
    _secondaryLabel     = nil;
    _cellDivider        = nil;
    _cellAccesserImage  = nil;
    
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
        _primaryLabel               = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 20)];
        _primaryLabel.font          = [UIFont systemFontOfSize:16];
        _primaryLabel.textAlignment = NSTextAlignmentLeft;
        [_primaryLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self.contentView addSubview:_primaryLabel];
        
        // setup secondary lable for fact discription dispaly
        _secondaryLabel                 = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 200, 50)];
        _secondaryLabel.textAlignment   = NSTextAlignmentLeft;
        _secondaryLabel.lineBreakMode   = NSLineBreakByWordWrapping;
        _secondaryLabel.numberOfLines   = 0;
        _secondaryLabel.font            = [UIFont systemFontOfSize:10];
        [_secondaryLabel setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth];
        [self.contentView addSubview:_secondaryLabel];
        
        // setup fact image
        _factImage = [[UIImageView alloc] initWithFrame:CGRectMake(220, 10, 70, 70)];
        [_factImage setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
        [self.contentView addSubview:_factImage];
        
        // setup cell divider
        _cellDivider                    = [[UIImageView alloc] initWithFrame:CGRectMake(0, 89, 340, 1)];
        _cellDivider.backgroundColor    = [UIColor grayColor];
        [_cellDivider setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self.contentView addSubview:_cellDivider];
        
        //setup cell accesser iamge
        _cellAccesserImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        _cellAccesserImage.image=[UIImage imageNamed:@"atdJL.png"];
        self.accessoryView = _cellAccesserImage;
        
    }
    
    return self;
}







@end
