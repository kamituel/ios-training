//
//  UserManager.m
//  CoreDataDemo
//
//  Created by Kamil on 27/02/14.
//  Copyright (c) 2014 Kamil. All rights reserved.
//

#import "UserManager.h"

#define kUserEmail @"kUserEmail"

@implementation UserManager

static id sharedInstance;

/* instancetype - returns type which is in outer @implementation block. Better than return generic id.  */
+ (instancetype)sharedManager {
    if (!sharedInstance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedInstance = [UserManager new];
        });
    }
    return sharedInstance;
}

- (BOOL) isLogin
{
    return (nil != [DEFAULTS objectForKey:kUserEmail]);
}

- (void) loginWithEmail:(NSString*)email
            andPassword:(NSString*)password
{
    [DEFAULTS setObject:email forKey:kUserEmail];
    
    if (self.delegate != nil) {
        if ([self.delegate respondsToSelector:@selector(user:didLoginWithEmail:)]) {
            [self.delegate user:self didLoginWithEmail:email];
        }
    }
    
    if (self.block != nil) {
        self.block(email);
    }
}

@end
