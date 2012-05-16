//
//  DACircularProgressView.h
//  DACircularProgress
//
//  Created by Daniel Amitay on 2/6/12.
//  Copyright (c) 2012 Daniel Amitay. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DA_ROUNDED_CORNERS_DEFAULT YES

@interface DACircularProgressView : UIView

@property(nonatomic, strong) UIColor *trackTintColor;
@property(nonatomic, strong) UIColor *progressTintColor;
@property(nonatomic) BOOL roundedCorners;
@property(nonatomic) CGFloat progress;

@end
