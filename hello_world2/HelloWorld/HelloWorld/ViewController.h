//
//  ViewController.h
//  HelloWorld
//
//  Created by Kamil on 24/02/14.
//  Copyright (c) 2014 Kamil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
- (IBAction)onClick:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end
