//
//  ViewController.m
//  HelloWorld
//
//  Created by Kamil on 24/02/14.
//  Copyright (c) 2014 Kamil. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "iOSConstants.h"
#import "NSString+URLStringValidation.h"
#import <Reachability.h>
#import <SVProgressHUD.h>

#define kAlertViewQuestionTag 4
#define kSerializationPath @"~/Documents/User.plist"

@interface ViewController () <UITextFieldDelegate>
@property Person *user;
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (weak, nonatomic) IBOutlet UITextField *urlbar;
@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSString *path = [kSerializationPath stringByExpandingTildeInPath];
    self.user = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    NSLog(@"%@", self.user);
    
    if (self.user.imie != nil) {
        self.statusLabel.text = [NSString stringWithFormat:@"Witaj %@", self.user.imie];
    }
    
    [self.urlbar setDelegate:self];
    [self loadDefaultPage];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.urlbar becomeFirstResponder];
}

- (void)loadPage
{
    if (![self.urlbar.text isURLValid]) {
        [self showWeather:self.urlbar.text];
        /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Niepoprawny adres"
                                   message:@"Niepoprawny adres"
                                  delegate:nil
                         cancelButtonTitle:@"Ok"
                         otherButtonTitles:nil];
        [alert show];*/
    } else {
        Reachability *reach = [Reachability reachabilityForInternetConnection];
        if (![reach isReachable]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Brak połączenia"
                                                            message:@"Brak połączenia"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        NSString *urlString = [NSString prepareURLString:[self.urlbar text]];
        NSURL *url = [[NSURL alloc] initWithString:urlString];
        DLog(@"compoennts %@", [url pathComponents]);
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webview loadRequest:request];
    }
}

- (void)loadDefaultPage
{
    NSString *indexPath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:indexPath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webview loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onClick:(id)sender {
    [self loadPage];
    
    /*DLog(@"clicked");
    
    NSString *indexPath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:indexPath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    DLog(@"Openinig path: %@ (url=%@)", indexPath, url);
    
    //[self.webview loadHTMLString:@"<html><body><h1>title</h1></body></html>" baseURL:nil];
    //[self.webview ]
    [self.webview loadRequest:request];*/
}

- (IBAction)onClick2:(id)sender {
    NSLog(@"asdasdasdasdasd");
    self.statusLabel.text = @"adad";
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"uwaga"
                                                    message:@"Jak się nazywasz?"
                                                   delegate:self
                                          cancelButtonTitle:@"Nie"
                                          otherButtonTitles:@"Tak", @"Być może", nil];
    
    //alert.tag = kAlertViewQuestionTag;
    [alert setTag:kAlertViewQuestionTag];

    //NSString *imie = [[NSUserDefaults standardUserDefaults] objectForKey:@"imie"];
    //Person *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    
    NSLog(@"%@", self.user);
    
    if (self.user.imie == nil) {
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    }
    
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSArray *odpowiedzi = [[NSArray alloc] initWithObjects:
                           @"Głupek Ty",
                           @"Dobrze!",
                           @"No to do dzieła",
                           nil];
    
    if (alertView.tag == kAlertViewQuestionTag) {
        if (self.user.imie == nil) {
            NSString *imie = [[alertView textFieldAtIndex:0] text];
            self.user = [Person alloc];
            self.user.imie = imie;
            
            NSString *path = [kSerializationPath stringByExpandingTildeInPath];
            [NSKeyedArchiver archiveRootObject:self.user toFile:path];
        }
        
        self.statusLabel.text = [NSString stringWithFormat:@"%@ %@", self.user.imie, [odpowiedzi objectAtIndex:buttonIndex]];
        
       
        
        
        
        
        
        
//        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//        [userDefaults setObject:userSerialized forKey:@"user"];
//        
//        [userDefaults synchronize];
    }

    NSLog(@"asdasdasd clicked");
}

#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self loadPage];
    [self.urlbar resignFirstResponder];
    return YES;
}

#pragma mark - Weather
- (void)showWeather:(NSString*)location
{
    /*NSRegularExpression *locationRegex = [NSRegularExpression regularExpressionWithPattern:@"(\\S+),\\s*(\\S+)" options:0 error:nil];
    NSArray *matches = [locationRegex matchesInString:location options:0 range: NSMakeRange(0, [location length])];
    
    for ( NSTextCheckingResult* match in matches )
    {
        NSString* matchText = [location substringWithRange:[match range]];
        NSLog(@"match: %@", matchText);
    }*/
    
    [SVProgressHUD showWithStatus:@"Bla!"];
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?q=%@&lang=pl&units=metric", location]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:true];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
//        NSString *res_str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        DLog(@"Response: %@", res_str);
        
        NSError *error = nil;
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                             options:0
                                                               error:&error];
        
        DLog(@"JSON: %@ - %@", json, json[@"main"][@"temp"]);
        
        [NSThread detachNewThreadSelector:@selector(parseBigJson:) toTarget:self withObject:data];
        
        
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            
            
            
        }];
        
        [SVProgressHUD dismiss];
    }];
}

- (void)parseBigJson:(NSData*) data
{
    @autoreleasepool {
        
        
        
    }
}

@end
