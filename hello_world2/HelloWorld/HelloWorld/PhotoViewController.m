//
//  PhotoViewController.m
//  HelloWorld
//
//  Created by Kamil on 25/02/14.
//  Copyright (c) 2014 Kamil. All rights reserved.
//

#import "PhotoViewController.h"
#import "iOSConstants.h"

#define kPhotoCount 5
#define kPhotoMargin 30
#define kPhotoAnimationDuration 1
#define kPhotoSlideshowDelay 1

@interface PhotoViewController () <UIScrollViewDelegate>
@property (strong) UIScrollView *scroll;
@property (strong) NSMutableArray *backgroundArray;
@property (strong) NSTimer *timer;
@end

@implementation PhotoViewController

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
    
    self.backgroundArray = [[NSMutableArray alloc] init];
    [self addBackgrounds];
    [self addScrollView];
    [self addPhotos];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(toggleSlideshow)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)viewDidAppear:(BOOL)animated {
    [self toggleSlideshow];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)toggleSlideshow
{
    DLog();
    
    if ([self.timer isValid]) {
        [self.timer invalidate];
    } else {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:kPhotoSlideshowDelay
                                                      target:self
                                                    selector:@selector(nextPhoto)
                                                    userInfo:nil
                                                     repeats:true];
    }
}

- (void)nextPhoto
{
    static int current_photo = 0;
    
    current_photo++;
    if (current_photo >= kPhotoCount) {
        current_photo = 0;
    }
    
    CGRect appFrame = [[UIScreen mainScreen] bounds];
    
    [UIView animateWithDuration:kPhotoAnimationDuration
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         CGFloat offset = appFrame.size.height * current_photo;
                         [_scroll setContentOffset:CGPointMake(offset, 0) animated:NO];
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    
}

- (void)addBackgrounds
{
    //self.view.backgroundColor = [UIColor yellowColor];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    
    CGRect appFrame = [[UIScreen mainScreen] bounds];
    
    for (int i = 1; i <= 3; i += 1) {
        int tag = 0;

        switch (i) {
            case 1: tag = 8; break;
            case 2: tag = 4; break;
            case 3: tag = 2; break;
        }
        
        CGRect frame = CGRectMake(-appFrame.size.height / 2,
                                  0,
                                  appFrame.size.height * kPhotoCount + (appFrame.size.height / 2),
                                  appFrame.size.width);
        
        UIView *bg = [[UIView alloc] initWithFrame:frame];
        [bg setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:[NSString stringWithFormat:@"bg%d.png", i]]]];
        [bg setTag:tag];
        
        [self.view addSubview:bg];
        [self.backgroundArray addObject:bg];
    }
}

- (void) addPhotos
{
    CGRect appFrame = [[UIScreen mainScreen] bounds];
    
    for (int i = 1; i <= kPhotoCount; i += 1) {
        CGRect frame = CGRectMake((i-1) * appFrame.size.height + kPhotoMargin,
                                                     kPhotoMargin,
                                                     appFrame.size.height - 2 * kPhotoMargin,
                                                     appFrame.size.width - 2 * kPhotoMargin);
        
        UIImageView *photo = [[UIImageView alloc] initWithFrame:frame];
        [photo setImage:[UIImage imageNamed:[NSString stringWithFormat:@"sample0%d.jpg", i]]];
        [_scroll addSubview:photo];
    }
}

- (void) addScrollView
{
    CGRect appFrame = [[UIScreen mainScreen] bounds];
    _scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                            0,
                                                            appFrame.size.height,
                                                            appFrame.size.width)];
    
    [_scroll setDelegate:self];
    [_scroll setContentSize:CGSizeMake(appFrame.size.height * kPhotoCount,
                                       appFrame.size.width)];
    
    [self.view addSubview:_scroll];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.x;
    
    for (UIView *bg in _backgroundArray) {
        bg.transform = CGAffineTransformMakeTranslation(-offset / bg.tag, 0);
    }
}

- (BOOL) shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

@end
