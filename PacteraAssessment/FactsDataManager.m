//
//  FactsDataManager.m
//  PacteraAssessment
//
//  Created by Arun Ramakani on 12/18/14.
//  Copyright (c) 2014 Pactera. All rights reserved.
//

#import "FactsDataManager.h"
#import "CJSONDeserializer.h"
#import "Facts.h"

@interface FactsDataManager()

@property (nonatomic, strong) NSURLConnection   *downloadConn;
@property (nonatomic, strong) NSMutableData     *downloadedData;



@end

@implementation FactsDataManager


-(void) startImageDownload
{
    _downloadedData = [NSMutableData data];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_factForImageDownload.factImageLink]];
    _downloadConn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}

- (void)cancelDownload
{
    [_downloadConn cancel];
}

-(void) getFacts {
    
    _downloadedData = [NSMutableData data];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://dl.dropboxusercontent.com/u/746330/facts.json"]];
    _downloadConn = [[NSURLConnection alloc] initWithRequest:request delegate:self];

}


#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    [_downloadedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
    
    if(_factsDownloadDelegate != nil){
        [_factsDownloadDelegate factDownloadCompleted:nil factsTitle:nil];
    } else {
        _factForImageDownload.factImage = [UIImage imageNamed:@"latest.png"];
        [_imageDownloadDelegate factImageDownloadCompleted:_factForImageDownload imageIndexPath:_imageIndexPath];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    if(_factsDownloadDelegate != nil){
        [self handleFactsFeed];
    } else {
        [self handleImageDownload];
    }
    
}

-(void) handleImageDownload {
    
    // Set appIcon and clear temporary data/image
    UIImage *image = [[UIImage alloc] initWithData:_downloadedData];
    
    if(image == nil){
        _factForImageDownload.factImage = [UIImage imageNamed:@"latest.png"];
    } else {
        _factForImageDownload.factImage = image;
    }
    
    [_imageDownloadDelegate factImageDownloadCompleted:_factForImageDownload imageIndexPath:_imageIndexPath];
    
}

-(void) handleFactsFeed {
    
    NSMutableArray *displayFactsArray = [[NSMutableArray alloc] init];


    NSString *myString = [[NSString alloc] initWithData:_downloadedData encoding:NSASCIIStringEncoding];
    NSData* data = [myString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:data error:&error];
    
    NSLog(@"myString : %@", myString);
    
    NSArray *rows   = [dictionary  valueForKey:@"rows"];
    NSString *title = [dictionary  valueForKey:@"title"];
    
    for (NSDictionary *row in rows) {
        if (![[row  valueForKey:@"title"] isKindOfClass:[NSNull class]]) {
            Facts *fact = [[Facts alloc] init];
            fact.factTitle = [row  valueForKey:@"title"];
            
            if (![[row  valueForKey:@"description"] isKindOfClass:[NSNull class]]) {
                fact.factDiscription = [row  valueForKey:@"description"];
            } else {
                fact.factDiscription = @"No discription Available";
            }
            if (![[row  valueForKey:@"imageHref"] isKindOfClass:[NSNull class]]) {
                fact.factImageLink = [row  valueForKey:@"imageHref"];
            }
            
            [displayFactsArray addObject:fact];
        }
    }
    [_factsDownloadDelegate factDownloadCompleted:displayFactsArray factsTitle:title];
}

@end

