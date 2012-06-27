//
//  ViewController.m
//  DACircularProgressExample
//
//  Created by Daniel Amitay on 2/6/12.
//  Copyright (c) 2012 Daniel Amitay. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

@synthesize progressView;
@synthesize largeProgressView;
@synthesize largestProgressView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    progressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(140.0f, 20.0f, 40.0f, 40.0f)];
    [self.view addSubview:progressView];
    
    largeProgressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(110.0f, 80.0f, 100.0f, 100.0f)];
    largeProgressView.roundedCorners = NO;
    [self.view addSubview:largeProgressView];
    
    [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(progressChange) userInfo:nil repeats:YES];
}

- (void)progressChange
{
    progressView.progress += 0.01;
    largeProgressView.progress += 0.01;
    largestProgressView.progress += 0.01;
    
    if (progressView.progress >= 1.0f)
    {
        progressView.progress = 0.0f;
    }
    
    if (largeProgressView.progress >= 1.0f)
    {
        largeProgressView.progress = 0.0f;
    }
    
    if (largestProgressView.progress >= 1.0f)
    {
        largestProgressView.progress = 0.0f;
    }
}

@end
