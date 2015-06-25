//
//  ViewController.m
//  DACircularProgressExample
//
//  Created by Daniel Amitay on 2/6/12.
//  Copyright (c) 2012 Daniel Amitay. All rights reserved.
//

#import "ViewController.h"
#import "DALabeledCircularProgressView.h"

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
    
    self.progressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(140.0f, 50.0f, 40.0f, 40.0f)];
    self.progressView.roundedCorners = YES;
    self.progressView.trackTintColor = [UIColor clearColor];
    [self.view addSubview:self.progressView];
    
    self.largeProgressView.roundedCorners = NO;
    [self.view addSubview:self.largeProgressView];
    
    self.largestProgressView.trackTintColor = [UIColor blackColor];
    self.largestProgressView.progressTintColor = [UIColor yellowColor];
    self.largestProgressView.thicknessRatio = 1.0f;
    self.largestProgressView.clockwiseProgress = NO;
    
    // Labeled progress views
    self.labeledProgressView = [[DALabeledCircularProgressView alloc] initWithFrame:CGRectMake(200.0f, 40.0f, 60.0f, 60.0f)];
    self.labeledProgressView.roundedCorners = YES;
    [self.view addSubview:self.labeledProgressView];
    
    self.labeledLargeProgressView.roundedCorners = NO;
    [self.view addSubview:self.labeledLargeProgressView];
    
    [self startAnimation];
}

- (void)progressChange
{
    NSArray *progressViews = @[self.linearProgressView,
                               self.progressView,
                               self.largeProgressView,
                               self.largestProgressView];
    for (DACircularProgressView *progressView in progressViews) {
        CGFloat progress = ![self.timer isValid] ? self.stepper.value / 10.0f : progressView.progress + 0.01f;
        [progressView setProgress:progress animated:YES];
        
        if (progressView.progress >= 1.0f && [self.timer isValid]) {
            [progressView setProgress:0.f animated:YES];
        }
        
        self.progressLabel.text = [NSString stringWithFormat:@"%.2f", progressView.progress];
    }
    
    // Labeled progress views
    NSArray *labeledProgressViews = @[self.labeledProgressView,
                                      self.labeledLargeProgressView];
    for (DALabeledCircularProgressView *labeledProgressView in labeledProgressViews) {
        CGFloat progress = ![self.timer isValid] ? self.stepper.value / 10.0f : labeledProgressView.progress + 0.01f;
        [labeledProgressView setProgress:progress animated:YES];
        
        if (labeledProgressView.progress >= 1.0f && [self.timer isValid]) {
            [labeledProgressView setProgress:0.f animated:YES];
        }
        
        labeledProgressView.progressLabel.text = [NSString stringWithFormat:@"%.2f", labeledProgressView.progress];
    }
    
    
}

- (void)startAnimation
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.03
                                                  target:self
                                                selector:@selector(progressChange)
                                                userInfo:nil
                                                 repeats:YES];
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
    if (self.continuousSwitch.on) {
        [self startAnimation];
    } else {
        [self stopAnimation];
    }
}

- (IBAction)toggleIndeterminate:(id)sender
{
    NSArray *progressViews = @[self.progressView,
                               self.largeProgressView,
                               self.largestProgressView];
    for (DACircularProgressView *progressView in progressViews) {
        progressView.indeterminate = self.indeterminateSwitch.on;
    }
}

- (IBAction)step:(id)sender
{
    [self stopAnimation];
    [self progressChange];
}

@end
