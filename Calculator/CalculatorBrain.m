//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Yann Mainier on 17/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"
//#include <math.h>

@interface CalculatorBrain()

@property (nonatomic, strong) NSMutableArray *programStack;

@end


@implementation CalculatorBrain

@synthesize programStack = _programStack;

- (NSMutableArray *)programStack {
    if (!_programStack) {
        _programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
}

- (id)program
{
    return [self.programStack copy];
}

- (void)clear {
    self.programStack = nil;
}

- (void)pushOperand:(double)operand {
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (void)pushVariable:(NSString *)variable {
    [self.programStack addObject:variable];
}

- (double)performOperation:(NSString *)operation {
    [self.programStack addObject:operation];
    return [[self class] runProgram:self.program];
}


+ (BOOL)isHighPriorityTwoOperandOperation:(NSString *)operation {
    NSSet *allOperations = [NSSet setWithObjects:@"*", @"/", nil];
    return [allOperations containsObject:operation];
}
+ (BOOL)isLowPriorityTwoOperandOperation:(NSString *)operation {
    NSSet *allOperations = [NSSet setWithObjects:@"+", @"-", nil];
    return [allOperations containsObject:operation];
}
+ (BOOL)isTwoOperandOperation:(NSString *)operation {
    return [self isHighPriorityTwoOperandOperation:operation] || [self isLowPriorityTwoOperandOperation:operation];
}

+ (BOOL)isOneOperandOperation:(NSString *)operation {
    NSSet *allOperations = [NSSet setWithObjects:@"cos", @"sin", @"sqrt", nil];
    return [allOperations containsObject:operation];
}
+ (BOOL)isZeroOperandOperation:(NSString *)operation {
    NSSet *allOperations = [NSSet setWithObjects:@"pi", nil];
    return [allOperations containsObject:operation];
}

+ (BOOL)isOperation:(NSString *)operation {
    return [self isTwoOperandOperation:operation] || [self isOneOperandOperation:operation] || [self isZeroOperandOperation:operation];
}

+ (NSString *)zeroIfEmpty:(NSString *)operand {
    if ([operand isEqualToString:@""]) {
        return @"0";
    } else {
        return operand;
    }
}

+ (BOOL)hasSurroundingParenthesis:(NSString *)operand {
    return [operand hasPrefix:@"("] && [operand hasSuffix:@")"];
}

+ (NSString *)descriptionOfTopOfStack:(NSMutableArray *)stack lastOperation:(NSString *)theLastOperation {
    NSString *result = @"";
    

    id topOfStack = [stack lastObject];
    if (topOfStack) {
        [stack removeLastObject];
    }
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        result = [topOfStack stringValue];
    } else if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString *operation = topOfStack;
        
        if ([self isTwoOperandOperation:operation]) {
            NSString *secondOperand = [self zeroIfEmpty:[self descriptionOfTopOfStack:stack lastOperation:operation]];
            NSString *firstOperand = [self zeroIfEmpty:[self descriptionOfTopOfStack:stack lastOperation:operation]];
            if (
                [theLastOperation isEqualToString:@""] ||
                [operation isEqualToString:@"*"] ||
                ([theLastOperation isEqualToString:@"+"] && [operation isEqualToString:@"+"])
                ) {
                result = [NSString stringWithFormat:@"%@ %@ %@", firstOperand, operation, secondOperand];
            } else {
                result = [NSString stringWithFormat:@"(%@ %@ %@)", firstOperand, operation, secondOperand];
            }
        } else if ([self isOneOperandOperation:operation]) {
            NSString *operand = [self zeroIfEmpty:[self descriptionOfTopOfStack:stack lastOperation:operation]];
            result = [NSString stringWithFormat:@"%@(%@)", operation, operand];
        } else {
            result = operation;
        }
    }

    return result;
}

+ (NSString *)descriptionOfProgram:(id)program {
    NSMutableArray *stack;
    NSString *result = @"";
    
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    result = [self descriptionOfTopOfStack:stack lastOperation:@""];
    while ([stack count] > 0) {
        result = [NSString stringWithFormat:@"%@, %@", result, [self descriptionOfTopOfStack:stack lastOperation:@""]];
    }
    
    return result;
}


+ (double)popOperandOffProgramStack:(NSMutableArray *)stack with:(NSDictionary *)dictionnary {
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        result = [topOfStack doubleValue];
    } else if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString *operation = topOfStack;
        
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffProgramStack:stack with:dictionnary] + [self popOperandOffProgramStack:stack with:dictionnary];
        } else if ([operation isEqualToString:@"*"]) {
            result = [self popOperandOffProgramStack:stack with:dictionnary] * [self popOperandOffProgramStack:stack with:dictionnary];
        } else if ([operation isEqualToString:@"-"]) {
            double substractor = [self popOperandOffProgramStack:stack with:dictionnary];
            result = [self popOperandOffProgramStack:stack with:dictionnary] - substractor;
        } else if ([operation isEqualToString:@"/"]) {
            double divisor = [self popOperandOffProgramStack:stack with:dictionnary];
            if (divisor) {
                result = [self popOperandOffProgramStack:stack with:dictionnary] / divisor;
            }
        } else if ([operation isEqualToString:@"cos"]) {
            result = cos([self popOperandOffProgramStack:stack with:dictionnary]);
        } else if ([operation isEqualToString:@"sin"]) {
            result = sin([self popOperandOffProgramStack:stack with:dictionnary]);
        } else if ([operation isEqualToString:@"sqrt"]) {
            double operand = [self popOperandOffProgramStack:stack with:dictionnary];
            if (operand >= 0) {
                result = sqrt(operand);
            }
        } else if ([operation isEqualToString:@"pi"]) {
            result = M_PI;
        } else {
            // This should be a variable here
            result = [[dictionnary valueForKey:topOfStack] doubleValue];
        }
    }
    
    return result;
}

+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues {
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    
    return [self popOperandOffProgramStack:stack with:variableValues];
}

+ (double)runProgram:(id)program {
    return [self runProgram:program usingVariableValues:nil];
}


+ (NSSet *)variablesUsedInProgram:(id)program {
    if ([program isKindOfClass:[NSArray class]]) {
        
        NSMutableArray *variablesArray = [[NSMutableArray alloc] init];
        for(id element in program) {
            if ([element isKindOfClass:[NSString class]] && ![self isOperation:element]) {
                [variablesArray addObject:element];
            }
        }
        if ([variablesArray count] > 0) {
            return [NSSet setWithArray:variablesArray];
        }
    }
    return nil;
}

- (void)undo {
    if ([self.programStack count] > 0) {
        [self.programStack removeLastObject];
    }
}

@end
