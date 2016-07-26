//
//  User.m
//  Triper_IOS
//
//  Created by Mac on 26.07.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)init {
    return [self initWithUsername:@""];
}

- (instancetype)initWithUsername:(NSString *)username {
    self = [super init];
    if (self) {
        self.username = username;
    }
    return self;
}

@end
