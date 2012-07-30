//
//  GraphView.m
//  Calculator
//
//  Created by Yann Mainier on 29/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"

@implementation GraphView

@synthesize scale = _scale;
@synthesize origin = _origin;
@synthesize dataSource = _dataSource;

- (void) setScale:(CGFloat)scale {
    _scale = scale;
    [self setNeedsDisplay];
}
- (CGFloat) scale {
    if (_scale <= 0) {
        return 10;
    } else {
        return _scale;
    }
}
- (void) setOrigin:(CGPoint)origin {
    _origin = origin;
    [self setNeedsDisplay];
}
- (CGPoint) origin {
    if (_origin.x == 0 && _origin.y == 0) {
        return CGPointMake(self.bounds.origin.x + self.bounds.size.width / 2, self.bounds.origin.y + self.bounds.size.height / 2);
    } else {
        return _origin;
    }
}

- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        self.scale *= gesture.scale; // adjust our scale
        gesture.scale = 1;           // reset gestures scale to 1 (so future changes are incremental, not cumulative)
    }
}

- (void)pan:(UIPanGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        CGPoint translation = [gesture translationInView:self];
        self.origin = CGPointMake(self.origin.x + translation.x, self.origin.y + translation.y);
        [gesture setTranslation:CGPointZero inView:self];
    }
}

- (void)tripleTap:(UITapGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateEnded) {
        self.origin = [gesture locationInView:self];
    }
}

- (void)setup
{
    self.contentMode = UIViewContentModeRedraw; // if our bounds changes, redraw ourselves
}

- (void)awakeFromNib
{
    [self setup]; // get initialized when we come out of a storyboard
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup]; // get initialized if someone uses alloc/initWithFrame: to create us
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);
    [AxesDrawer drawAxesInRect:rect originAtPoint:self.origin scale:self.scale];
    
	UIGraphicsPushContext(context);
    [[UIColor blueColor] setStroke];
    
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, 0, self.origin.y - [self.dataSource getY:self fromX:((-self.origin.x) / self.scale)] * self.scale);

    for (float i = 1; i < self.bounds.size.width; i++) {
        CGContextAddLineToPoint(context, i, self.origin.y - [self.dataSource getY:self fromX:((i - self.origin.x) / self.scale)] * self.scale);
    }
	CGContextStrokePath(context);
    
	UIGraphicsPopContext();
}

@end
