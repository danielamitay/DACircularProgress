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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    progressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(140.0f, 20.0f, 40.0f, 40.0f)];
    [self.view addSubview:progressView];
    
    largeProgressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(110.0f, 80.0f, 100.0f, 100.0f)];
    [self.view addSubview:largeProgressView];
    
    largestProgressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(60.0f, 200.0f, 200.0f, 200.0f)];
    [self.view addSubview:largestProgressView];
    
    [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(progressChange) userInfo:nil repeats:YES];
}

- (void)progressChange
{
    progressView.progress += 0.01;
    largeProgressView.progress += 0.01;
    largestProgressView.progress += 0.01;
    
    if (progressView.progress > 1.0f)
    {
        progressView.progress = 0.0f;
    }
    
    if (largeProgressView.progress > 1.0f)
    {
        largeProgressView.progress = 0.0f;
    }
    
    if (largestProgressView.progress > 1.0f)
    {
        largestProgressView.progress = 0.0f;
    }
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
