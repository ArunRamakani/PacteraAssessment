//
//  FactsDisplayCellCell.h
//  PacteraAssessment
//
//  Created by Arun Ramakani on 12/19/14.
//  Copyright (c) 2014 Pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facts.h"

@interface FactsDisplayCellCell : UITableViewCell{

}
@property(nonatomic,retain) UILabel     *factTitleLabel;
@property(nonatomic,retain) UILabel     *factDiscriptionLabel;
@property(nonatomic,retain) UIImageView *factImage;
@property(nonatomic,retain) UIImageView *cellDivider;
@property(nonatomic,retain) UIImageView *cellAccesserImage;

@end


