//
//  TSTextField.m
//  Triper_IOS
//
//  Created by Mac on 07.07.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSTextField.h"

@implementation TSTextField

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.layer.borderColor = UIColor.lightGrayColor.CGColor;
        self.layer.borderWidth = 1;
        self.layer.masksToBounds = YES;
    }
    return self;
}

@end
