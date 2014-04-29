//
//  iOSConstants.h
//
//  Created by Michał Dziadkowiec on 23/01/14.
//  Copyright (c) 2014 Michał Dziadkowiec. All rights reserved.
//

#ifndef GraphView_iOSConstants_h
#define GraphView_iOSConstants_h

#define APP (AppDelegate *)[UIApplication sharedApplication].delegate

#define CENTER [NSNotificationCenter defaultCenter]
#define DEFAULTS [NSUserDefaults standardUserDefaults]
#define FILE_MANAGER [NSFileManager defaultManager]

#define NibName(X) [UINib nibWithNibName:X bundle:nil]
#define NavigationController(X) [[UINavigationController alloc] initWithRootViewController:X]

#define kTableViewCell @"kTableViewCell"

#define main_queue dispatch_get_main_queue()

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

#endif
