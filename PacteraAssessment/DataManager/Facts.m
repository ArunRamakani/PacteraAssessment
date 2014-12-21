//
//  Facts.m
//  PacteraAssessment
//
//  Fact data model
//
//  Created by Arun Ramakani on 12/18/14.
//  Copyright (c) 2014 Pactera. All rights reserved.
//

#import "Facts.h"

@implementation Facts

-(void) dealloc {
    
    // release retained property
    [_factTitle release];
    [_factDiscription release];
    [_factImageLink release];
    [_factImage release];
    
    _factTitle          = nil;
    _factDiscription    = nil;
    _factImageLink      = nil;
    _factImage          = nil;
    
    [super dealloc];
}

@end
