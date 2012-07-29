//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Yann Mainier on 17/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsEnteringANumber;
@property (nonatomic) BOOL userHasEnteredADot;
@property (nonatomic, strong) CalculatorBrain *brain;

- (void) updateLog;
- (void) updateAllLabels;

@end

@implementation CalculatorViewController
@synthesize display = _display;
@synthesize log = _log;
@synthesize userIsEnteringANumber = _userIsEnteringANumber;
@synthesize brain = _brain;
@synthesize userHasEnteredADot = _userHasEnteredADot;

- (void) updateLog {
    self.log.text = [[self.brain class] descriptionOfProgram:self.brain.program];
}


- (CalculatorBrain *)brain {
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = [sender currentTitle];
    if (self.userIsEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.userIsEnteringANumber = YES;
        self.display.text = digit;
    }
}

- (IBAction)dotPressed {
    if (!self.userHasEnteredADot) {
        if (!self.userIsEnteringANumber) {
            self.display.text = @"0";
        }
        self.display.text = [self.display.text stringByAppendingString:@"."];
    }
    self.userHasEnteredADot = YES;
    self.userIsEnteringANumber = YES;
}

- (void)updateAllLabels {
    self.display.text = [NSString stringWithFormat:@"%g", [[self.brain class] runProgram:self.brain.program usingVariableValues:nil]];
    
    [self updateLog];
}

- (IBAction)enterIsPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsEnteringANumber = NO;
    self.userHasEnteredADot = NO;

    [self updateLog];
}

- (IBAction)operationPressed:(UIButton *)sender {
    if (self.userIsEnteringANumber) {
        [self enterIsPressed];
    }
    
    NSString *operation = [sender currentTitle];
    [self.brain performOperation:operation];

    [self updateAllLabels];
}

- (IBAction)cancelPressed {
    self.log.text = @"";
    self.display.text = @"0";
    [self.brain clear];
}

- (IBAction)variablePressed:(id)sender {
    if (self.userIsEnteringANumber) {
        [self enterIsPressed];
    }
    [self.brain pushVariable:[sender currentTitle]];

    [self updateLog];
}

- (IBAction)undoPressed:(id)sender {
    if (self.userIsEnteringANumber) {
        NSUInteger length = [self.display.text length];
        if (length > 0) {
            NSString *lastChar = [self.display.text substringFromIndex:(length - 1)];
            NSString *beginningOfDisplay = [self.display.text substringToIndex:(length - 1)];
            if ([beginningOfDisplay isEqualToString:@""]) {
                beginningOfDisplay = @"0";
                self.userIsEnteringANumber = NO;
                self.userHasEnteredADot = NO;
            }
            self.display.text = beginningOfDisplay;
            if ([lastChar isEqualToString:@"."]) {
                self.userHasEnteredADot = NO;
            }
            [self updateLog];
        }
    } else {
        [self.brain undo];
        [self updateAllLabels];
    }
}

- (IBAction)graphPressed {
    [self performSegueWithIdentifier:@"ShowGraph" sender:self];
}


@end
