//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Martin Holman on 20/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController()

@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
- (void)addToDisplay:(UIButton *)button withSpacePrefix:(BOOL)addSpacePrefix;

@end

@implementation CalculatorViewController

@synthesize display = _display; 
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;
@synthesize brainDisplay = _brainDisplay;

- (CalculatorBrain *)brain
{
    if (!_brain) {
        _brain = [[CalculatorBrain alloc] init];
    }
    
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = [sender currentTitle];
    
    //we allow a period if we do not have one currently in the input or the user is not in the middle of entering a number
    BOOL allowPeriod = [self.display.text rangeOfString:@"."].location == NSNotFound || !self.userIsInTheMiddleOfEnteringANumber;
    BOOL inputContainsPeriod = [digit rangeOfString:@"."].location != NSNotFound;
    BOOL newNumberBeingEntered = NO;
    
    //the input doesnt have a period, the input has a period but we havent typed one yet
    if (!inputContainsPeriod || (inputContainsPeriod && allowPeriod)) {
        if (self.userIsInTheMiddleOfEnteringANumber) {
            self.display.text = [self.display.text stringByAppendingString:digit];
        } else {
            self.display.text = digit;
            self.userIsInTheMiddleOfEnteringANumber = YES;
            newNumberBeingEntered = YES;
        }
        
        [self addToDisplay:sender withSpacePrefix:newNumberBeingEntered];
    }
}

- (IBAction)enterPressed:(UIButton *)sender {
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    
    if (sender != nil) {
        [self addToDisplay:sender withSpacePrefix:YES];
    }
}
- (IBAction)operationPressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed:nil];
    }
    NSString *operation = sender.currentTitle;
    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g", result];
    [self addToDisplay:sender withSpacePrefix:YES];
}

- (void)addToDisplay:(UIButton *)button withSpacePrefix:(BOOL)addSpacePrefix {
    NSString *newText = self.brainDisplay.text;
    
    if (addSpacePrefix) {
        newText = [newText stringByAppendingString:@" "];
    }
    
    newText = [newText stringByAppendingString:button.currentTitle];
    
    self.brainDisplay.text = newText;
}

- (IBAction)clearPressed {
    [self.brain clear];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.brainDisplay.text = @"";
    self.display.text = @"0";
}

@end
