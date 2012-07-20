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
@synthesize linearProgressView = _linearProgressView;
@synthesize stepper = _stepper;
@synthesize progressLabel = _progressLabel;
@synthesize continuousSwitch = _continuousSwitch;
@synthesize timer = _timer;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.progressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(140.0f, 30.0f, 40.0f, 40.0f)];
    self.progressView.roundedCorners = YES;
    self.progressView.trackTintColor = [UIColor clearColor];
    [self.view addSubview:self.progressView];
    
    self.largeProgressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(110.0f, 85.0f, 100.0f, 100.0f)];
    self.largeProgressView.roundedCorners = NO;
    [self.view addSubview:self.largeProgressView];
    
    self.largestProgressView.trackTintColor = [UIColor blackColor];
    self.largestProgressView.progressTintColor = [UIColor yellowColor];
    self.largestProgressView.thicknessRatio = 1.0f;
    
    [self startAnimation];
}

- (void)progressChange
{
    for (DACircularProgressView *progressView in [NSArray arrayWithObjects:self.linearProgressView, self.progressView, self.largeProgressView, self.largestProgressView, nil])
    {
        CGFloat progress = ![self.timer isValid] ? self.stepper.value / 10.f : progressView.progress + 0.01f;
        [progressView setProgress:progress animated:YES];
        
        if (progressView.progress >= 1.0f && [self.timer isValid])
        {
            [progressView setProgress:0.f animated:YES];
        }
        
        self.progressLabel.text = [NSString stringWithFormat:@"%.2f", progressView.progress];
    }
}

- (void)startAnimation
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(progressChange) userInfo:nil repeats:YES];
    self.continuousSwitch.on = YES;
}

- (void)stopAnimation
{
    [self.timer invalidate];
    self.timer = nil;
    self.continuousSwitch.on = NO;
}

- (IBAction)toggleAnimation:(id)sender
{
    if (self.continuousSwitch.on)
    {
        [self startAnimation];
    }
    else
    {
        [self stopAnimation];
    }
}

- (IBAction)step:(id)sender
{
    [self stopAnimation];
    [self progressChange];
}

@end
