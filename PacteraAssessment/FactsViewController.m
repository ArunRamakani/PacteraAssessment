//
//  FactsViewController.m
//  PacteraAssessment
//
//  Created by Arun Ramakani on 12/18/14.
//  Copyright (c) 2014 Pactera. All rights reserved.
//

#import "FactsViewController.h"

@interface FactsViewController ()

@end

@implementation FactsViewController

-(id)init
{
    self = [super init];
    if(self){
       
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _factList = [[UITableView alloc] initWithFrame:self.view.bounds];
    [_factList setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];

    
    [self.view addSubview:_factList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
