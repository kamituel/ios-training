//
//  WelcomeViewController.m
//  CoreDataDemo
//
//  Created by Kamil on 27/02/14.
//  Copyright (c) 2014 Kamil. All rights reserved.
//

#import "WelcomeViewController.h"
#import "RegisterViewController.h"

@interface WelcomeViewController () <UserManagerDelegate>

@end

@implementation WelcomeViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)actionShowRegisterVC:(id)sender {
    [[UserManager sharedManager] setDelegate:self];
    [UserManager sharedManager].block = ^(NSString *email) {
        DLog(@"block ooo %@", email);
    };
    
    RegisterViewController *registerVC = [RegisterViewController new];
    //[self.navigationController pushViewController:registerVC animated:YES];
    
    UINavigationController *navCtrl = NavigationController(registerVC);
    [navCtrl setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    
    [self presentViewController:navCtrl animated:YES completion:^{
        
    }];
}

#pragma mark - UserManagerDelegate methods
- (void)user:(UserManager*)user didLoginWithEmail:(NSString*)email
{
    DLog(@"ooooo %@", email);
}

@end
