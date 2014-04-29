//
//  PrettyViewController.m
//  HelloWorld
//
//  Created by Kamil on 26/02/14.
//  Copyright (c) 2014 Kamil. All rights reserved.
//

#import "PrettyViewController.h"
#import "iOSConstants.h"

@interface PrettyViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *loaderOn;
@property (weak, nonatomic) IBOutlet UIImageView *outerLoader;
@property (weak, nonatomic) IBOutlet UIImageView *innerLoader;
@property (weak, nonatomic) IBOutlet UIButton *button;

@property BOOL isAnimating;
@end

@implementation PrettyViewController

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
    [self.button addTarget:self action:@selector(powerOn) forControlEvents:UIControlEventTouchUpInside];
    
    [self setIsAnimating:NO];
    [self.loaderOn setHidden:YES];
    
    [self.innerLoader setAlpha:0.0];
    [self.outerLoader setAlpha:0.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - handlers

- (void)powerOn
{
    if ([self isAnimating]) {
        return;
    }
    
    if ([self.button isSelected]) {
        [self.button setSelected:NO];
        
        [self.loaderOn.layer removeAllAnimations];
        [UIView animateWithDuration:1 animations:^{
            [self.loaderOn setAlpha:0.0];
        }];
    } else {
        [self.button setSelected:YES];
        [self startRotate];
        [self performSelector:@selector(poweringOnDone) withObject:nil afterDelay:3];
    }
}

- (void)poweringOnDone
{
    [self.loaderOn setAlpha:0.0];
    [self.loaderOn setHidden:NO];
    
    [UIView animateWithDuration:2 animations:^{
        [self.loaderOn setAlpha:1.0];
        [self.innerLoader setAlpha:0.0];
        [self.outerLoader setAlpha:0.0];
    } completion:^(BOOL finished) {
        [self.innerLoader.layer removeAllAnimations];
        [self.outerLoader.layer removeAllAnimations];
        
        [self setIsAnimating:NO];
        
        [self glow_button];
    }];
}

#pragma mark - animations
- (void)startRotate
{
    DLog();
    
    [self setIsAnimating:YES];
    
    [self.loaderOn setHidden:YES];
    [self.innerLoader setAlpha:0.0];
    [self.outerLoader setAlpha:0.0];
    
    [UIView animateWithDuration:1 animations:^{
        [self.loaderOn setAlpha:0.0];
        [self.innerLoader setAlpha:1.0];
        [self.outerLoader setAlpha:1.0];
    } completion:^(BOOL finished) {
        
    }];
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
    rotationAnimation.duration = 2.0;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = INFINITY;
    rotationAnimation.autoreverses = NO;
    
    [self.outerLoader.layer addAnimation:rotationAnimation forKey:@"mojaNazwa"];
    
    CABasicAnimation *rotationAnimation2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation2.toValue = [NSNumber numberWithFloat: -1 * M_PI * 2.0];
    rotationAnimation2.duration = 0.3;
    rotationAnimation2.cumulative = YES;
    rotationAnimation2.repeatCount = INFINITY;
    rotationAnimation2.autoreverses = NO;
    
    [self.innerLoader.layer addAnimation:rotationAnimation2 forKey:@"mojaNazwa"];
}

- (void) glow_button
{
    CABasicAnimation *glowAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    glowAnimation.toValue = @(0.4);
    glowAnimation.fromValue = @(1.0);
    glowAnimation.duration = 2.0;
    glowAnimation.cumulative = YES;
    glowAnimation.repeatCount = INFINITY;
    glowAnimation.autoreverses = YES;
    
    [self.loaderOn.layer addAnimation:glowAnimation forKey:@"mojaNazwa"];
}

@end
