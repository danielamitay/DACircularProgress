//
//  DACircularProgressView.m
//  DACircularProgress
//
//  Created by Daniel Amitay on 2/6/12.
//  Copyright (c) 2012 Daniel Amitay. All rights reserved.
//

#import "DACircularProgressView.h"

#import <QuartzCore/QuartzCore.h>

@interface DACircularProgressLayer : CALayer

@property(nonatomic, strong) UIColor *trackTintColor;
@property(nonatomic, strong) UIColor *progressTintColor;
@property(nonatomic) BOOL roundedCorners;
@property(nonatomic) CGFloat thicknessRatio;
@property(nonatomic) CGFloat progress;

@end

@implementation DACircularProgressLayer

@synthesize trackTintColor = _trackTintColor;
@synthesize progressTintColor = _progressTintColor;
@synthesize roundedCorners = _roundedCorners;
@synthesize thicknessRatio = _thicknessRatio;
@synthesize progress = _progress;

+ (BOOL)needsDisplayForKey:(NSString *)key
{
    return [key isEqualToString:@"progress"] ? YES : [super needsDisplayForKey:key];
}

- (id)initWithLayer:(DACircularProgressLayer *)layer
{
    self = [super initWithLayer:layer];
    if (self)
    {
        self.trackTintColor = layer.trackTintColor;
        self.progressTintColor = layer.progressTintColor;
        self.roundedCorners = layer.roundedCorners;
        self.thicknessRatio = layer.thicknessRatio;
        self.progress = layer.progress;
    }
    return self;
}

- (void)drawInContext:(CGContextRef)context
{
    CGRect rect = self.bounds;
    CGPoint centerPoint = CGPointMake(rect.size.height / 2, rect.size.width / 2);
    CGFloat radius = MIN(rect.size.height, rect.size.width) / 2;
    
    CGFloat progress = MIN(self.progress, 1.f - FLT_EPSILON);
    CGFloat radians = (progress * 2 * M_PI) - M_PI_2;
    
    CGContextSetFillColorWithColor(context, self.trackTintColor.CGColor);
    CGMutablePathRef trackPath = CGPathCreateMutable();
    CGPathMoveToPoint(trackPath, NULL, centerPoint.x, centerPoint.y);
    CGPathAddArc(trackPath, NULL, centerPoint.x, centerPoint.y, radius, 3 * M_PI_2, -M_PI_2, NO);
    CGPathCloseSubpath(trackPath);
    CGContextAddPath(context, trackPath);
    CGContextFillPath(context);
    CGPathRelease(trackPath);
    
    if (progress > 0.f)
    {
        CGContextSetFillColorWithColor(context, self.progressTintColor.CGColor);
        CGMutablePathRef progressPath = CGPathCreateMutable();
        CGPathMoveToPoint(progressPath, NULL, centerPoint.x, centerPoint.y);
        CGPathAddArc(progressPath, NULL, centerPoint.x, centerPoint.y, radius, 3 * M_PI_2, radians, NO);
        CGPathCloseSubpath(progressPath);
        CGContextAddPath(context, progressPath);
        CGContextFillPath(context);
        CGPathRelease(progressPath);
    }
    
    if (progress > 0.f && self.roundedCorners == YES)
    {
        CGFloat pathWidth = radius * self.thicknessRatio;
        CGFloat xOffset = radius * (1.f + ((1 - (self.thicknessRatio / 2.f)) * cosf(radians)));
        CGFloat yOffset = radius * (1.f + ((1 - (self.thicknessRatio / 2.f)) * sinf(radians)));
        CGPoint endPoint = CGPointMake(xOffset, yOffset);
        
        CGContextAddEllipseInRect(context, CGRectMake(centerPoint.x - pathWidth / 2, 0, pathWidth, pathWidth));
        CGContextFillPath(context);
        
        CGContextAddEllipseInRect(context, CGRectMake(endPoint.x - pathWidth / 2, endPoint.y - pathWidth / 2, pathWidth, pathWidth));
        CGContextFillPath(context);
    }
    
    CGContextSetBlendMode(context, kCGBlendModeClear);
    CGFloat innerRadius = radius * (1.f - self.thicknessRatio);
    CGPoint newCenterPoint = CGPointMake(centerPoint.x - innerRadius, centerPoint.y - innerRadius);
    CGContextAddEllipseInRect(context, CGRectMake(newCenterPoint.x, newCenterPoint.y, innerRadius * 2, innerRadius * 2));
    CGContextFillPath(context);
}

@end

@implementation DACircularProgressView

@dynamic trackTintColor;
@dynamic progressTintColor;
@dynamic roundedCorners;
@dynamic thicknessRatio;
@dynamic progress;

+ (Class)layerClass
{
    return [DACircularProgressLayer class];
}

- (id)init
{
    return [self initWithFrame:CGRectMake(0.0f, 0.0f, 40.0f, 40.0f)];
}

- (void)commonInit
{
    self.layer.contentsScale = [UIScreen mainScreen].scale;
    self.trackTintColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.3f];
    self.progressTintColor = [UIColor whiteColor];
    self.thicknessRatio = 0.3f;
    self.roundedCorners = NO;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

#pragma mark - Progress

- (void)setProgress:(CGFloat)progress
{
    [self setProgress:progress animated:NO];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated
{
    DACircularProgressLayer *layer = (DACircularProgressLayer *)self.layer;
    CGFloat pinnedProgress = MIN(MAX(progress, 0.f), 1.f);
    if (animated)
    {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"progress"];
        animation.duration = fabsf(self.progress - pinnedProgress); // Same duration as UIProgressView animation
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.fromValue = [NSNumber numberWithFloat:self.progress];
        animation.toValue = [NSNumber numberWithFloat:pinnedProgress];
        [layer addAnimation:animation forKey:@"progress"];
    }
    else
    {
        [layer setNeedsDisplay];
    }
    layer.progress = pinnedProgress;
}

- (void)setThicknessRatio:(CGFloat)thicknessRatio
{
    DACircularProgressLayer *layer = (DACircularProgressLayer *)self.layer;
    layer.thicknessRatio = MIN(MAX(thicknessRatio, 0.f), 1.f);
}

#pragma mark - Dynamic Properties

- (id)forwardingTargetForSelector:(SEL)selector
{
    if ([NSStringFromSelector(selector) hasPrefix:@"set"])
    {
        [self.layer setNeedsDisplay];
    }
    return self.layer;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    [self.layer setNeedsDisplay];
    [self.layer setValue:value forKey:key];
}

@end
