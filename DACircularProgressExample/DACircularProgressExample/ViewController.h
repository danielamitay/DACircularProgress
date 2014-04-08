//
//  ViewController.h
//  DACircularProgressExample
//
//  Created by Daniel Amitay on 2/6/12.
//  Copyright (c) 2012 Daniel Amitay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DACircularProgressView.h"
#import "DALabeledCircularProgressView.h"

@interface ViewController : UIViewController

@property (strong, nonatomic) DACircularProgressView *progressView;
@property (strong, nonatomic) IBOutlet DACircularProgressView *largeProgressView;
@property (strong, nonatomic) IBOutlet DACircularProgressView *largestProgressView;
@property (strong, nonatomic) IBOutlet UIProgressView *linearProgressView;

// Labeled progress views
@property (strong, nonatomic) DALabeledCircularProgressView *labeledProgressView;
@property (strong, nonatomic) IBOutlet DALabeledCircularProgressView *labeledLargeProgressView;

@property (strong, nonatomic) IBOutlet UIStepper *stepper;
@property (strong, nonatomic) IBOutlet UILabel *progressLabel;
@property (strong, nonatomic) IBOutlet UISwitch *continuousSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *indeterminateSwitch;

@end
