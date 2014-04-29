//
//  RegisterViewController.m
//  CoreDataDemo
//
//  Created by Kamil on 27/02/14.
//  Copyright (c) 2014 Kamil. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController () <UITextFieldDelegate>

@end

@implementation RegisterViewController

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
    
    [self loadNavigationButtons];
}

- (void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [self.emailTextField setDelegate:self];
    [self.passwordTextField setDelegate:self];
}

- (void)viewDidDisappear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadNavigationButtons {
    UIBarButtonItem *bbCancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel

                                                                              target:self
                                                                              action:@selector(actionCancel)];
    [self.navigationItem setLeftBarButtonItem:bbCancel];
    
    UIBarButtonItem *bbRegister = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                 
                                                                              target:self
                                                                              action:@selector(actionRegister)];
    [self.navigationItem setRightBarButtonItem:bbRegister];
}

#pragma mark - Actions

- (void) actionCancel
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void) actionRegister
{
    if (self.emailTextField.text.length == 0) {
        // TODO:
        return;
    }
    
    if (self.passwordTextField.text.length == 0) {
        // TODO:
        return;
    }
    
    [[UserManager sharedManager] loginWithEmail:self.emailTextField.text
                                    andPassword:self.passwordTextField.text];
    
    [self dismissViewControllerAnimated:YES
                             completion:^{
        
    }];
}

#pragma mark - Keyboard handlers

- (void)keyboardWillShow
{
    self.scrollView.contentSize = CGSizeMake(320, 2000);
}

- (void)keyboardWillHide
{
    self.scrollView.contentSize = _scrollView.frame.size;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.emailTextField) {
        [self.passwordTextField becomeFirstResponder];
        DLog(@"frame.origin.y %f navbar height %f", self.passwordTextField.frame.origin.y, self.navigationController.navigationBar.frame.size.height);
        [self.scrollView setContentOffset:CGPointMake(0, self.passwordTextField.frame.origin.y - self.navigationController.navigationBar.frame.size.height)];
    } else {
        [textField resignFirstResponder];
    }
    
    return YES;
}

@end
