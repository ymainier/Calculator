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
@synthesize programDescription = _programDescription;

- (void)setProgram:(id)program {
    _program = program;
    [self.graphView setNeedsDisplay];
}

- (void)setGraphView:(GraphView *)graphView {
    _graphView = graphView;
    [self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pinch:)]];
    [self.graphView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pan:)]];

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
    self.programDescription.text = [CalculatorBrain descriptionOfProgram:self.program];
}

- (void)viewDidUnload
{
    [self setGraphView:nil];
    [self setProgramDescription:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (float)getY:(GraphView *)sender fromX:(float)x {
    return [CalculatorBrain runProgram:self.program usingVariableValues:[NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:x] forKey:@"x"]];
}

@end
