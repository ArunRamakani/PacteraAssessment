//
//  FactsDataManager.h
//  PacteraAssessment
//
//  Created by Arun Ramakani on 12/18/14.
//  Copyright (c) 2014 Pactera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Facts.h"

@protocol FactsImageDownloadDelegate <NSObject>
@required
- (void) factImageDownloadCompleted:(Facts*) fact imageIndexPath:(NSIndexPath*) imageIndexPath;

@end

@protocol FactsDataDelegate <NSObject>
@required
- (void) factDownloadCompleted:(NSArray*) facts factsTitle:(NSString*) factTitle;

@end

@interface FactsDataManager : NSObject


@property (nonatomic, weak) id<FactsImageDownloadDelegate> imageDownloadDelegate;
@property (nonatomic, weak) id<FactsDataDelegate>          factsDownloadDelegate;
@property (nonatomic, retain) Facts *factForImageDownload;
@property (nonatomic, retain) NSIndexPath *imageIndexPath;

- (void) getFacts;
- (void) startImageDownload;
- (void) cancelDownload;


@end
