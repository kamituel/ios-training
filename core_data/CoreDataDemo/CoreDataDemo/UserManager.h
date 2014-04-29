//
//  UserManager.h
//  CoreDataDemo
//
//  Created by Kamil on 27/02/14.
//  Copyright (c) 2014 Kamil. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserManager;

@protocol UserManagerDelegate <NSObject>

- (void)user:(UserManager*)user didLoginWithEmail:(NSString*)email;

@end

@interface UserManager : NSObject

@property (weak) id<UserManagerDelegate> delegate;


@property (nonatomic, copy) void (^block)(NSString *email);


+ (instancetype)sharedManager;

- (BOOL) isLogin;

- (void) loginWithEmail:(NSString*)email
            andPassword:(NSString*)password;


@end
