//
//  DetailViewController.h
//  CoreDataSample
//
//  Created by Kamil on 28/02/14.
//  Copyright (c) 2014 Kamil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
