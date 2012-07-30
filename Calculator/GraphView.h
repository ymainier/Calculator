//
//  GraphView.h
//  Calculator
//
//  Created by Yann Mainier on 29/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GraphView;

@protocol GraphViewDataSource

- (float)getY:(GraphView *)sender fromX:(float)x;

@end

@interface GraphView : UIView
@property (nonatomic) CGFloat scale;
@property (nonatomic) CGPoint origin;

@property (nonatomic, weak) IBOutlet id <GraphViewDataSource> dataSource;

- (void)pinch:(UIPinchGestureRecognizer *)gesture;
- (void)pan:(UIPinchGestureRecognizer *)gesture;
- (void)tripleTap:(UITapGestureRecognizer *)gesture;

@end
