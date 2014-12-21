//
//  FactsDataManager.h
//  PacteraAssessment
//
//  Helper class that manages data download and parsing for Facts list display
//
//  Created by Arun Ramakani on 12/18/14.
//  Copyright (c) 2014 Pactera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Facts.h"

// delegate protocal for fact list download process
@protocol FactsImageDownloadDelegate <NSObject>

@required
//--------------------------------------------------------------------------------------------------
//	Function Name	:	factImageDownloadCompleted:facts:imageIndexPath
//	Description		:   Delegate method call to handle fact download completion
//	param			:	[in] (Facts *) - Fact for wich image is downloaded downloaded
//	param			:	[in] (NSIndexPath*) - Fact index to be updated
//	return			:	[out] viod
//--------------------------------------------------------------------------------------------------
- (void) factImageDownloadCompleted:(Facts*) fact imageIndexPath:(NSIndexPath*) imageIndexPath;

@end

// delegate protocal for fact image download process
@protocol FactsDataDelegate <NSObject>

@required
//--------------------------------------------------------------------------------------------------
//	Function Name	:	factDownloadCompleted:facts:factTitle
//	Description		:   Delegate method call to handle fact download completion
//	param			:	[in] (NSArray *) - Downloaded fact List
//	param			:	[in] (NSString*) - Downloaded fact Title
//	return			:	[out] viod
//--------------------------------------------------------------------------------------------------
- (void) factDownloadCompleted:(NSArray*) facts factsTitle:(NSString*) factTitle;

@end

@interface FactsDataManager : NSObject

// Delegate reference for call back of image download process and fact list download process
@property (nonatomic, assign) id<FactsImageDownloadDelegate> imageDownloadDelegate;
@property (nonatomic, assign) id<FactsDataDelegate>          factsDownloadDelegate;

// Fact/fact index reference for call back
@property (nonatomic, assign) Facts                          *factForImageDownload;
@property (nonatomic, assign) NSIndexPath                    *imageIndexPath;

//--------------------------------------------------------------------------------------------------
//	Function Name	:	getFacts
//	Description		:   initiates fact download network call
//	return			:	[out] viod
//--------------------------------------------------------------------------------------------------
- (void) getFacts;

//--------------------------------------------------------------------------------------------------
//	Function Name	:	startImageDownload
//	Description		:   initiates fact image download network call
//	return			:	[out] viod
//--------------------------------------------------------------------------------------------------
- (void) startImageDownload;

//--------------------------------------------------------------------------------------------------
//	Function Name	:	cancelDownload
//	Description		:   To Cancel the current download process
//	return			:	[out] viod
//--------------------------------------------------------------------------------------------------
- (void) cancelDownload;


@end
