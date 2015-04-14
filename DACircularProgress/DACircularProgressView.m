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
@property(nonatomic, strong) UIColor *innerTintColor;
@property(nonatomic) NSInteger roundedCorners;
@property(nonatomic) CGFloat startPosition;
@property(nonatomic) CGFloat thicknessRatio;
@property(nonatomic) CGFloat progress;
@property(nonatomic) NSInteger clockwiseProgress;

@end

@implementation DACircularProgressLayer

@dynamic trackTintColor;
@dynamic progressTintColor;
@dynamic innerTintColor;
@dynamic roundedCorners;
@dynamic startPosition;
@dynamic thicknessRatio;
@dynamic progress;
@dynamic clockwiseProgress;

+ (BOOL)needsDisplayForKey:(NSString *)key
{
    if ([key isEqualToString:@"progress"]) {
        return YES;
    } else {
        return [super needsDisplayForKey:key];
    }
}

- (void)drawInContext:(CGContextRef)context
{
    CGRect rect = self.bounds;
    CGPoint centerPoint = CGPointMake(rect.size.width / 2.0f, rect.size.height / 2.0f);
    CGFloat radius = MIN(rect.size.height, rect.size.width) / 2.0f;
    
    CGFloat thicknessRatio = self.thicknessRatio;
    BOOL clockwise = (self.clockwiseProgress != 0);
    
    CGFloat progress = MIN(self.progress, 1.0f - FLT_EPSILON);
    CGFloat startRadians = -self.startPosition;
    CGFloat radians = 0;
    if (clockwise)
    {
        radians = (float)(startRadians + (progress * 2 * M_PI));
    }
    else
    {
        radians = (float)(startRadians - (progress * 2 * M_PI));
    }
    
    CGContextSetFillColorWithColor(context, self.trackTintColor.CGColor);
    CGMutablePathRef trackPath = CGPathCreateMutable();
    CGPathMoveToPoint(trackPath, NULL, centerPoint.x, centerPoint.y);
    CGPathAddArc(trackPath, NULL, centerPoint.x, centerPoint.y, radius, (float)(2.0f * M_PI), 0.0f, TRUE);
    CGPathCloseSubpath(trackPath);
    CGContextAddPath(context, trackPath);
    CGContextFillPath(context);
    CGPathRelease(trackPath);
    
    if (progress > 0.0f) {
        CGContextSetFillColorWithColor(context, self.progressTintColor.CGColor);
        CGMutablePathRef progressPath = CGPathCreateMutable();
        CGPathMoveToPoint(progressPath, NULL, centerPoint.x, centerPoint.y);
        CGPathAddArc(progressPath, NULL, centerPoint.x, centerPoint.y, radius, startRadians, radians, !clockwise);
        CGPathCloseSubpath(progressPath);
        CGContextAddPath(context, progressPath);
        CGContextFillPath(context);
        CGPathRelease(progressPath);
    }
    
    if (progress > 0.0f && self.roundedCorners) {
        CGFloat pathWidth = radius * thicknessRatio;
        CGFloat tmp = 1.0f - (thicknessRatio / 2.0f);
        
        CGFloat startXOffset = radius * (1.0f + (tmp * cosf(startRadians)));
        CGFloat startYOffset = radius * (1.0f + (tmp * sinf(startRadians)));
        CGPoint startPoint = CGPointMake(startXOffset, startYOffset);
        
        CGFloat endXOffset = radius * (1.0f + (tmp * cosf(radians)));
        CGFloat endYOffset = radius * (1.0f + (tmp * sinf(radians)));
        CGPoint endPoint = CGPointMake(endXOffset, endYOffset);
        
        CGRect startEllipseRect = (CGRect) {
            .origin.x = startPoint.x - pathWidth / 2.0f,
            .origin.y = startPoint.y - pathWidth / 2.0f,
            .size.width = pathWidth,
            .size.height = pathWidth
        };
        CGContextAddEllipseInRect(context, startEllipseRect);
        CGContextFillPath(context);
        
        CGRect endEllipseRect = (CGRect) {
            .origin.x = endPoint.x - pathWidth / 2.0f,
            .origin.y = endPoint.y - pathWidth / 2.0f,
            .size.width = pathWidth,
            .size.height = pathWidth
        };
        CGContextAddEllipseInRect(context, endEllipseRect);
        CGContextFillPath(context);
    }

    CGContextSetBlendMode(context, kCGBlendModeClear);
    CGFloat innerRadius = radius * (1.0f - thicknessRatio);
    CGRect clearRect = (CGRect) {
        .origin.x = centerPoint.x - innerRadius,
        .origin.y = centerPoint.y - innerRadius,
        .size.width = innerRadius * 2.0f,
        .size.height = innerRadius * 2.0f
    };
    CGContextAddEllipseInRect(context, clearRect);
    CGContextFillPath(context);

    if (self.innerTintColor) {
        CGContextSetBlendMode(context, kCGBlendModeNormal);
        CGContextSetFillColorWithColor(context, [self.innerTintColor CGColor]);
        CGContextAddEllipseInRect(context, clearRect);
        CGContextFillPath(context);
    }
}

@end

@interface DACircularProgressView ()

@end

@implementation DACircularProgressView

+ (void) initialize
{
    if (self == [DACircularProgressView class]) {
        DACircularProgressView *circularProgressViewAppearance = [DACircularProgressView appearance];
        [circularProgressViewAppearance setTrackTintColor:[[UIColor whiteColor] colorWithAlphaComponent:0.3f]];
        [circularProgressViewAppearance setProgressTintColor:[UIColor whiteColor]];
        [circularProgressViewAppearance setInnerTintColor:nil];
        [circularProgressViewAppearance setBackgroundColor:[UIColor clearColor]];
        [circularProgressViewAppearance setThicknessRatio:0.3f];
        [circularProgressViewAppearance setRoundedCorners:NO];
        [circularProgressViewAppearance setClockwiseProgress:YES];
        [circularProgressViewAppearance setStartPosition:DACircularStartPositionTop];
        
        [circularProgressViewAppearance setIndeterminateDuration:2.0f];
        [circularProgressViewAppearance setIndeterminate:NO];
    }
}

+ (Class)layerClass
{
    return [DACircularProgressLayer class];
}

- (DACircularProgressLayer *)circularProgressLayer
{
    return (DACircularProgressLayer *)self.layer;
}

- (id)init
{
    return [super initWithFrame:CGRectMake(0.0f, 0.0f, 40.0f, 40.0f)];
}

- (void)didMoveToWindow
{
    CGFloat windowContentsScale = self.window.screen.scale;
    self.circularProgressLayer.contentsScale = windowContentsScale;
    [self.circularProgressLayer setNeedsDisplay];
}

#pragma mark - Progress

- (CGFloat)progress
{
    return self.circularProgressLayer.progress;
}

- (void)setProgress:(CGFloat)progress
{
    [self setProgress:progress animated:NO];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated
{
    [self setProgress:progress animated:animated initialDelay:0.0];
}

- (void)setProgress:(CGFloat)progress
           animated:(BOOL)animated
       initialDelay:(CFTimeInterval)initialDelay
{
    CGFloat pinnedProgress = MIN(MAX(progress, 0.0f), 1.0f);
    [self setProgress:progress
             animated:animated
         initialDelay:initialDelay
         withDuration:fabsf(self.progress - pinnedProgress)];
}

- (void)setProgress:(CGFloat)progress
           animated:(BOOL)animated
       initialDelay:(CFTimeInterval)initialDelay
       withDuration:(CFTimeInterval)duration
{
    [self.layer removeAnimationForKey:@"indeterminateAnimation"];
    [self.circularProgressLayer removeAnimationForKey:@"progress"];
    
    CGFloat pinnedProgress = MIN(MAX(progress, 0.0f), 1.0f);
    if (animated) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"progress"];
        animation.duration = duration;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.fillMode = kCAFillModeForwards;
        animation.fromValue = [NSNumber numberWithFloat:self.progress];
        animation.toValue = [NSNumber numberWithFloat:pinnedProgress];
        animation.beginTime = CACurrentMediaTime() + initialDelay;
        animation.delegate = self;
        [self.circularProgressLayer addAnimation:animation forKey:@"progress"];
    } else {
        [self.circularProgressLayer setNeedsDisplay];
        self.circularProgressLayer.progress = pinnedProgress;
    }
}

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag
{
   NSNumber *pinnedProgressNumber = [animation valueForKey:@"toValue"];
   self.circularProgressLayer.progress = [pinnedProgressNumber floatValue];
}

#pragma mark - UIAppearance methods

- (UIColor *)trackTintColor
{
    return self.circularProgressLayer.trackTintColor;
}

- (void)setTrackTintColor:(UIColor *)trackTintColor
{
    self.circularProgressLayer.trackTintColor = trackTintColor;
    [self.circularProgressLayer setNeedsDisplay];
}

- (UIColor *)progressTintColor
{
    return self.circularProgressLayer.progressTintColor;
}

- (void)setProgressTintColor:(UIColor *)progressTintColor
{
    self.circularProgressLayer.progressTintColor = progressTintColor;
    [self.circularProgressLayer setNeedsDisplay];
}

- (UIColor *)innerTintColor
{
    return self.circularProgressLayer.innerTintColor;
}

- (void)setInnerTintColor:(UIColor *)innerTintColor
{
    self.circularProgressLayer.innerTintColor = innerTintColor;
    [self.circularProgressLayer setNeedsDisplay];
}

- (NSInteger)roundedCorners
{
    return self.roundedCorners;
}

- (void)setRoundedCorners:(NSInteger)roundedCorners
{
    self.circularProgressLayer.roundedCorners = roundedCorners;
    [self.circularProgressLayer setNeedsDisplay];
}

- (CGFloat)startPosition
{
    return self.circularProgressLayer.startPosition;
}

- (void)setStartPosition:(CGFloat)startPosition
{
    self.circularProgressLayer.startPosition = startPosition;
    [self.circularProgressLayer setNeedsDisplay];
}

- (CGFloat)thicknessRatio
{
    return self.circularProgressLayer.thicknessRatio;
}

- (void)setThicknessRatio:(CGFloat)thicknessRatio
{
    self.circularProgressLayer.thicknessRatio = MIN(MAX(thicknessRatio, 0.f), 1.f);
    [self.circularProgressLayer setNeedsDisplay];
}

- (NSInteger)indeterminate
{
    CAAnimation *spinAnimation = [self.layer animationForKey:@"indeterminateAnimation"];
    return (spinAnimation == nil ? 0 : 1);
}

- (void)setIndeterminate:(NSInteger)indeterminate
{
    if (indeterminate) {
        if (!self.indeterminate) {
            CABasicAnimation *spinAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
            spinAnimation.byValue = [NSNumber numberWithDouble:indeterminate > 0 ? 2.0f*M_PI : -2.0f*M_PI];
            spinAnimation.duration = self.indeterminateDuration;
            spinAnimation.repeatCount = HUGE_VALF;
            [self.layer addAnimation:spinAnimation forKey:@"indeterminateAnimation"];
        }
    } else {
        [self.layer removeAnimationForKey:@"indeterminateAnimation"];
    }
}

- (NSInteger)clockwiseProgress
{
    return self.circularProgressLayer.clockwiseProgress;
}

- (void)setClockwiseProgress:(NSInteger)clockwiseProgres
{
    self.circularProgressLayer.clockwiseProgress = clockwiseProgres;
    [self.circularProgressLayer setNeedsDisplay];
}

@end
