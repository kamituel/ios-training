//
//  User.h
//  CoreDataDemo
//
//  Created by Kamil on 28/02/14.
//  Copyright (c) 2014 Kamil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * firstname;
@property (nonatomic, retain) NSString * lastname;
@property (nonatomic, retain) NSString * firstLetter;

@end
