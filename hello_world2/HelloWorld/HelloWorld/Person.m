//
//  Person.m
//  HelloWorld
//
//  Created by Kamil on 24/02/14.
//  Copyright (c) 2014 Kamil. All rights reserved.
//

#import "Person.h"
#import "iOSConstants.h"

#define ENCODER_IMIE @"imie"

@interface Person () <NSCoding>

@end

@implementation Person

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.imie forKey:ENCODER_IMIE];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.imie = [aDecoder decodeObjectForKey:ENCODER_IMIE];
    }
    return self;
}

- (NSString *)description {
    DLog(@"Hura");
    return [NSString stringWithFormat:@"Jestem Person o imieniu %@", self.imie];
}


@end
