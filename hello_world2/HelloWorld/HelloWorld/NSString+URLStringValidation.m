//
//  NSString+URLStringValidation.m
//  MyBrowser
//
//  Created by Michał Dziadkowiec on 11/17/12.
//  Copyright (c) 2012 PoznajXcode. All rights reserved.
//

#import "NSString+URLStringValidation.h"

@implementation NSString (URLStringValidation)

- (BOOL)isURLValid {
    
    NSError *error = nil;
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:@"(?i)(?:(?:https?):\\/\\/)?(?:\\S+(?::\\S*)?@)?(?:(?:[1-9]\\d?|1\\d\\d|2[01]\\d|22[0-3])(?:\\.(?:1?\\d{1,2}|2[0-4]\\d|25[0-5])){2}(?:\\.(?:[1-9]\\d?|1\\d\\d|2[0-4]\\d|25[0-4]))|(?:(?:[a-z\\u00a1-\\uffff0-9]+-?)*[a-z\\u00a1-\\uffff0-9]+)(?:\\.(?:[a-z\\u00a1-\\uffff0-9]+-?)*[a-z\\u00a1-\\uffff0-9]+)*(?:\\.(?:[a-z\\u00a1-\\uffff]{2,})))(?::\\d{2,5})?(?:\\/[^\\s]*)?" options:NSRegularExpressionCaseInsensitive error:&error];
    
    if (error)
        NSLog(@"error = %@", error);
    
    NSRange range = [expression rangeOfFirstMatchInString:self
                                                  options:NSMatchingReportCompletion
                                                    range:NSMakeRange(0, [self length])];
    
    if (!NSEqualRanges(range, NSMakeRange(NSNotFound, 0))){
        //NSString *match = [string substringWithRange:range];
        //NSLog(@"%@", match);
        return YES;
    }
    
    return NO;
}

+ (NSString *)prepareURLString:(NSString *)someValidURL {
    
    if ([someValidURL hasPrefix:@"http://"] || [someValidURL hasPrefix:@"https://"]) {
        return someValidURL;
    } else {
        return [NSString stringWithFormat:@"http://%@", someValidURL];
    }
    
    /*
     Starsza implementacja
     
     NSString *substring = [someValidURL substringWithRange:NSMakeRange(0, 7)];
     
    if ([substring isEqualToString:@"http://"]) {
        return someValidURL;
    }
    
    substring = [someValidURL substringWithRange:NSMakeRange(0, 8)];
    
    if ([substring isEqualToString:@"https://"]) {
        return someValidURL;
    }
    
    return [NSString stringWithFormat:@"http://%@", someValidURL]; // add "http//"
     */
}

@end
