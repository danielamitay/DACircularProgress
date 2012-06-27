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

@synthesize progressView = _progressView;
@synthesize largeProgressView = _largeProgressView;
@synthesize largestProgressView = _largestProgressView;
@synthesize lineraProgressView = _lineraProgressView;
@synthesize animationButton = _animationButton;
@synthesize timer = _timer;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.progressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(140.0f, 30.0f, 40.0f, 40.0f)];
    [self.view addSubview:self.progressView];
    
    self.largeProgressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(110.0f, 85.0f, 100.0f, 100.0f)];
    self.largeProgressView.roundedCorners = NO;
    [self.view addSubview:self.largeProgressView];
}

- (void)progressChange
{
    for (DACircularProgressView *progressView in [NSArray arrayWithObjects:self.lineraProgressView, self.progressView, self.largeProgressView, self.largestProgressView, nil])
    {
        [progressView setProgress:progressView.progress + 0.01f];
        
        if (progressView.progress >= 1.0f)
        {
            [progressView setProgress:0.f];
        }
    }
}

- (void)startAnimation
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(progressChange) userInfo:nil repeats:YES];
    [self.animationButton setTitle:@"Stop Animation" forState:UIControlStateNormal];
}

- (void)stopAnimation
{
    [self.timer invalidate];
    self.timer = nil;
    [self.animationButton setTitle:@"Start Animation" forState:UIControlStateNormal];
}

- (IBAction)toggleAnimation:(id)sender
{
    if ([self.timer isValid])
    {
        [self stopAnimation];
    }
    else
    {
        [self startAnimation];
    }
}

@end
