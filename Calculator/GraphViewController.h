//
//  GraphViewController.h
//  Calculator
//
//  Created by Yann Mainier on 29/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GraphViewController : UIViewController

@property (nonatomic, strong) id program;
@property (weak, nonatomic) IBOutlet UILabel *programDescription;

@end
