//
//  MMDebugDrawView.m
//  LooseLeaf
//
//  Created by Adam Wulf on 9/7/13.
//  Copyright (c) 2013 Milestone Made, LLC. All rights reserved.
//

#import "MMDebugDrawView.h"
#import "AVHexColor.h"


@implementation MMDebugDrawView {
    NSMutableArray* curves;
    NSMutableArray* colors;
}

static MMDebugDrawView* _instance = nil;

- (id)initWithFrame:(CGRect)frame {
    if (_instance)
        return _instance;
    if ((self = [super initWithFrame:frame])) {
        _instance = self;
        curves = [NSMutableArray array];
        colors = [NSMutableArray array];
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        self.layer.borderColor = [UIColor redColor].CGColor;
        self.layer.borderWidth = 5;
    }
    return _instance;
}

+ (MMDebugDrawView*)sharedInstance {
    if (!_instance) {
        _instance = [[MMDebugDrawView alloc] initWithFrame:[[[UIScreen mainScreen] fixedCoordinateSpace] bounds]];
    }
    return _instance;
}

#pragma mark - Draw

- (void)clear {
    [curves removeAllObjects];
    [self setNeedsDisplay];
}

- (void)addCurve:(UIBezierPath*)path {
    path = [path copy];
    CGAffineTransform flippedTransform = CGAffineTransformMake(1, 0, 0, -1, 0, self.bounds.size.height);
    [path applyTransform:flippedTransform];

    [curves addObject:path];
    if ([curves count] > [colors count]) {
        [colors addObject:[AVHexColor randomColor]];
    }
    [self setNeedsDisplay];
    [self setNeedsDisplayInRect:path.bounds];
}

- (void)drawRect:(CGRect)rect {
    for (int i = 0; i < [curves count]; i++) {
        UIBezierPath* path = [curves objectAtIndex:i];
        UIColor* color = [colors objectAtIndex:i];
        [color setStroke];
        path.lineWidth = 1;
        [path stroke];
    }
}

- (void)drawPoint:(CGPoint)p {
    UIBezierPath* path = [UIBezierPath bezierPathWithArcCenter:p radius:2 startAngle:0 endAngle:2 * M_PI clockwise:YES];
    [curves addObject:path];
    if ([curves count] > [colors count]) {
        [colors addObject:[AVHexColor randomColor]];
    }
    [self setNeedsDisplay];
}

#pragma mark - Ignore Touches

/**
 * these two methods make sure that the ruler view
 * can never intercept any touch input. instead it will
 * effectively pass through this view to the views behind it
 */
- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event {
    return nil;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event {
    return NO;
}

@end
