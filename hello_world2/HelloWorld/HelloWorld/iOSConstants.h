//
//  iOSConstants.h
//  HelloWorld
//
//  Created by Kamil on 24/02/14.
//  Copyright (c) 2014 Kamil. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif