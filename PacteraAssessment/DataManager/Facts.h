//
//  Facts.h
//  PacteraAssessment
//
//  Fact data model
//
//  Created by Arun Ramakani on 12/18/14.
//  Copyright (c) 2014 Pactera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Facts : NSObject

@property (nonatomic, retain) NSString      *factTitle;
@property (nonatomic, retain) NSString      *factDiscription;
@property (nonatomic, retain) NSString      *factImageLink;
@property (nonatomic, retain) UIImage       *factImage;
@property (nonatomic, assign) CGFloat       factCellHeight;
@property (nonatomic, assign) CGFloat       factTitleLabelHeight;
@property (nonatomic, assign) CGFloat       factDiscriptionLabelHeight;

@end
