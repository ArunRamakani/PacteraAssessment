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
@property(nonatomic,retain) UILabel     *primaryLabel;
@property(nonatomic,retain) UILabel     *secondaryLabel;
@property(nonatomic,retain) UIImageView *factImage;
@property(nonatomic,retain) UIImageView *cellDivider;
@property(nonatomic,retain) UIImageView *cellAccesserImage;

@end


