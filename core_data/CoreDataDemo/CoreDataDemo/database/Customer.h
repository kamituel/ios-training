//
//  Customer.h
//  CoreDataDemo
//
//  Created by Kamil on 27/02/14.
//  Copyright (c) 2014 Kamil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Customer : NSManagedObject

@property (nonatomic, retain) NSString * companyName;
@property (nonatomic, retain) NSNumber * discount;

@end
