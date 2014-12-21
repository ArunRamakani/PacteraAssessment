//
//  FactsDataManager.m
//  PacteraAssessment
//
//  Helper class that manages data download and parsing for Facts list display
//
//  Created by Arun Ramakani on 12/18/14.
//  Copyright (c) 2014 Pactera. All rights reserved.
//

#import "FactsDataManager.h"
#import "CJSONDeserializer.h"
#import "Facts.h"

@interface FactsDataManager()

@property (nonatomic, retain) NSURLConnection   *downloadConn;
@property (nonatomic, retain) NSMutableData     *downloadedData;

@end

@implementation FactsDataManager

-(void) dealloc {
    
    // release retained property
    [_downloadConn release];
    [_downloadedData release];
    
    _downloadConn   = nil;
    _downloadedData = nil;
    
    [super dealloc];
}

//--------------------------------------------------------------------------------------------------
//	Function Name	:	cancelDownload
//	Description		:   To Cancel the current download process
//	return			:	[out] viod
//--------------------------------------------------------------------------------------------------
- (void)cancelDownload
{
    [_downloadConn cancel];
}

#pragma mark - Image Download & Delegate

//--------------------------------------------------------------------------------------------------
//	Function Name	:	startImageDownload
//	Description		:   initiates fact image download network call
//	return			:	[out] viod
//--------------------------------------------------------------------------------------------------
-(void) startImageDownload
{
    // initialize data object to store downloaded data
    _downloadedData = [NSMutableData data];
    [_downloadedData retain];
    
    // Create image download request and fire network request
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_factForImageDownload.factImageLink] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:20];
    _downloadConn         = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}

//--------------------------------------------------------------------------------------------------
//	Function Name	:	handleImageDownload
//	Description		:   To delegate back the downloaded image to Facts view controller
//	return			:	[out] viod
//--------------------------------------------------------------------------------------------------
-(void) handleImageDownload {
    
    // Set appIcon and clear temporary data/image
    UIImage *image = [[[UIImage alloc] initWithData:_downloadedData] autorelease];
    
    if(image == nil){
        _factForImageDownload.factImage = [UIImage imageNamed:@"noImage.png"];
    } else {
        _factForImageDownload.factImage = image;
    }
    
    // delegate back the downloaded image to Facts view controller
    [_imageDownloadDelegate factImageDownloadCompleted:_factForImageDownload imageIndexPath:_imageIndexPath];
    
}

#pragma mark - Fact list Download & Delegate

//--------------------------------------------------------------------------------------------------
//	Function Name	:	getFacts
//	Description		:   initiates fact download network call
//	return			:	[out] viod
//--------------------------------------------------------------------------------------------------
-(void) getFacts {
    
    // initialize data object to store downloaded data
    _downloadedData = [NSMutableData data];
    [_downloadedData retain];
    
    // Create fact list download request and fire network request
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://dl.dropboxusercontent.com/u/746330/facts.json"] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:20];
    _downloadConn = [[NSURLConnection alloc] initWithRequest:request delegate:self];

}

//--------------------------------------------------------------------------------------------------
//	Function Name	:	handleFactsFeed
//	Description		:   To parse and delegate back the downloaded fact list to Facts view controller
//	return			:	[out] viod
//--------------------------------------------------------------------------------------------------
-(void) handleFactsFeed {
    
    NSMutableArray *displayFactsArray = [[[NSMutableArray alloc] init] autorelease];
    
    // conver data from NSASCIIStringEncoding encoding to NSUTF8StringEncoding to availe JSON parsing
    NSString *myString = [[[NSString alloc] initWithData:_downloadedData encoding:NSASCIIStringEncoding] autorelease];
    NSData* data = [myString dataUsingEncoding:NSUTF8StringEncoding];
    
    // Decerialize and parse the data downloaded
    NSError *error = nil;
    NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:data error:&error];
    
    // handle parse error
    if(error){
        [_factsDownloadDelegate factDownloadCompleted:nil factsTitle:nil];
        //NSLog(@"Error : %@", error.userInfo);
    } else {
        //NSLog(@"myString : %@", myString);
        
        NSArray *rows   = [dictionary  valueForKey:@"rows"];
        NSString *title = [dictionary  valueForKey:@"title"];
        
        for (NSDictionary *row in rows) {
            if (![[row  valueForKey:@"title"] isKindOfClass:[NSNull class]]) {
                Facts *fact = [[[Facts alloc] init] autorelease];
                fact.factTitle = [row  valueForKey:@"title"];
                
                if (![[row  valueForKey:@"description"] isKindOfClass:[NSNull class]]) {
                    fact.factDiscription = [row  valueForKey:@"description"];
                } else {
                    fact.factDiscription = @"No discription available";
                }
                if (![[row  valueForKey:@"imageHref"] isKindOfClass:[NSNull class]]) {
                    fact.factImageLink = [row  valueForKey:@"imageHref"];
                }
                
                [displayFactsArray addObject:fact];
            }
        }
        // delegate back the downloaded fact list to Facts view controller
        [_factsDownloadDelegate factDownloadCompleted:displayFactsArray factsTitle:title];
    }
    
}


#pragma mark - NSURLConnectionDelegate

//--------------------------------------------------------------------------------------------------
//	Function Name	:	connection:didReceiveData
//	Description		:   To collect the data downloaded from network call
//  param           :   [in] (NSData *) network downloaded data
//	return			:	[out] viod
//--------------------------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_downloadedData appendData:data];
}


//--------------------------------------------------------------------------------------------------
//	Function Name	:	connection:didFailWithError
//	Description		:   To handle network call failure
//  param           :   [in] (NSError *) error representation
//	return			:	[out] viod
//--------------------------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // redirect call based on data download failure type (Fact list/Fact image)
    if(_factsDownloadDelegate != nil){
        [_factsDownloadDelegate factDownloadCompleted:nil factsTitle:error.localizedDescription];
    } else {
        // Set no image place holder
        _factForImageDownload.factImage = [UIImage imageNamed:@"noImage.png"];
        [_imageDownloadDelegate factImageDownloadCompleted:_factForImageDownload imageIndexPath:_imageIndexPath];
    }
    
    //NSLog(@"Error : %@", error.userInfo);
}

//--------------------------------------------------------------------------------------------------
//	Function Name	:	connectionDidFinishLoading
//	Description		:   To notify network call is completed
//  param           :   [in] (NSURLConnection *) connection object reference
//	return			:	[out] viod
//--------------------------------------------------------------------------------------------------
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // redirect call based on data download success type (Fact list/Fact image)
    if(_factsDownloadDelegate != nil){
        [self handleFactsFeed];
    } else {
        [self handleImageDownload];
    }
    
}

@end

