//
//  FactsDisplayCellCell.m
//  PacteraAssessment
//
//  Created by Arun Ramakani on 12/19/14.
//  Copyright (c) 2014 Pactera. All rights reserved.
//

#import "FactsDisplayCellCell.h"


@implementation FactsDisplayCellCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}





- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // Initialization code
        
        _primaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 20)];
        _primaryLabel.textAlignment = NSTextAlignmentLeft;
        [_primaryLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        //[_primaryLabel setBackgroundColor:[UIColor greenColor]];
        _primaryLabel.font = [UIFont systemFontOfSize:16];
        
        _secondaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 200, 50)];
        _secondaryLabel.textAlignment = NSTextAlignmentLeft;
        _secondaryLabel.font = [UIFont systemFontOfSize:10];
        [_secondaryLabel setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth];
        //[_secondaryLabel setBackgroundColor:[UIColor blueColor]];
        
        _secondaryLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _secondaryLabel.numberOfLines = 0;
        
        
        
        _myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(220, 10, 70, 70)];
        [_myImageView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
        
        
        _cellDivider = [[UIImageView alloc] initWithFrame:CGRectMake(0, 89, 340, 1)];
        [_cellDivider setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        _cellDivider.backgroundColor = [UIColor grayColor];
        
        [self.contentView addSubview:_primaryLabel];
        [self.contentView addSubview:_secondaryLabel];
        [self.contentView addSubview:_myImageView];
        [self.contentView addSubview:_cellDivider];
        
        [self.contentView addSubview:_imgAccessoryvw];
        
        _imgAccessoryvw=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
        _imgAccessoryvw.image=[UIImage imageNamed:@"atdJL.png"];
        self.accessoryView = _imgAccessoryvw;
        
    
        
    }
        //[self.contentView setBackgroundColor:[UIColor redColor]];
    return self;
}







@end
