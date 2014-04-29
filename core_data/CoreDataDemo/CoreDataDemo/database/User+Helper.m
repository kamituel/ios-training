//
//  User+Helper.m
//  CoreDataDemo
//
//  Created by Kamil on 27/02/14.
//  Copyright (c) 2014 Kamil. All rights reserved.
//

#import "User+Helper.h"

@implementation User (Helper)
- (NSString*)fullName
{
    return [NSString stringWithFormat:@"%@ %@", self.lastname, self.firstname];
}

- (void)didChangeValueForKey:(NSString *)key
{
    DLog(@"key = %@", key);
    
    if ([key isEqualToString:@"lastname"]) {
        [self setFirstLetter:[self.lastname substringToIndex:1]];
    }
    
    if ([key isEqualToString:@"firstLetter"]) {
        DLog(@"%@", self.firstLetter);
    }
}

- (void)awakeFromFetch
{
    [self didChangeValueForKey:@"lastname"];
}

@end
