//
//  NSString+URLStringValidation.h
//  MyBrowser
//
//  Created by Michał Dziadkowiec on 11/17/12.
//  Copyright (c) 2012 PoznajXcode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URLStringValidation)

- (BOOL)isURLValid;

+ (NSString *)prepareURLString:(NSString *)someValidURL;

@end
