//
//  GraphViewController.m
//  Calculator
//
//  Created by Yann Mainier on 29/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GraphViewController.h"
#import "GraphView.h"
#import "CalculatorBrain.h"

@interface GraphViewController () <GraphViewDataSource>

@property (weak, nonatomic) IBOutlet GraphView *graphView;

@end

@implementation GraphViewController

@synthesize graphView = _graphView;
@synthesize program = _program;

- (void)setProgram:(id)program {
    _program = program;
    NSLog(@"Program in setProgram : %@", _program);
    [self.graphView setNeedsDisplay];
}

- (void)setGraphView:(GraphView *)graphView {
    _graphView = graphView;
    self.graphView.dataSource = self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setGraphView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (float)getY:(GraphView *)sender fromX:(float)x {
    NSLog(@"Program in getY : %@", self.program);
    return x;
}

@end
