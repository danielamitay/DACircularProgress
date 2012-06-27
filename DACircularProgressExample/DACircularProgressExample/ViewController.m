//
//  ViewController.m
//  DACircularProgressExample
//
//  Created by Daniel Amitay on 2/6/12.
//  Copyright (c) 2012 Daniel Amitay. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation ViewController

@synthesize progressView;
@synthesize largeProgressView;
@synthesize largestProgressView;
@synthesize lineraProgressView;
@synthesize animationButton;
@synthesize timer;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    progressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(140.0f, 30.0f, 40.0f, 40.0f)];
    [self.view addSubview:progressView];
    
    largeProgressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(110.0f, 85.0f, 100.0f, 100.0f)];
    largeProgressView.roundedCorners = NO;
    [self.view addSubview:largeProgressView];
}

- (void)progressChange
{
    lineraProgressView.progress += 0.01;
    progressView.progress += 0.01;
    largeProgressView.progress += 0.01;
    largestProgressView.progress += 0.01;
    
    if (lineraProgressView.progress >= 1.0f)
    {
        lineraProgressView.progress = 0.0f;
    }
    
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

- (IBAction)toggleAnimation:(id)sender
{
    if ([self.timer isValid])
    {
        [self.timer invalidate];
        self.timer = nil;
        [self.animationButton setTitle:@"Start Animation" forState:UIControlStateNormal];
    }
    else
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(progressChange) userInfo:nil repeats:YES];
        [self.animationButton setTitle:@"Stop Animation" forState:UIControlStateNormal];
    }
}

@end
