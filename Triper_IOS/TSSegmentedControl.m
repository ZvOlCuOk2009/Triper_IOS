//
//  TSSegmentedControl.m
//  Triper_IOS
//
//  Created by Mac on 06.07.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSSegmentedControl.h"

@implementation TSSegmentedControl

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys: [UIFont boldSystemFontOfSize:11], NSFontAttributeName, [UIColor grayColor], NSForegroundColorAttributeName, nil];
        [self setTitleTextAttributes:attributes forState:UIControlStateNormal];
        
        NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:[UIColor orangeColor]
                                                                          forKey:NSForegroundColorAttributeName];
        [self setTitleTextAttributes:highlightedAttributes forState:UIControlStateSelected];
    }
    return self;
}

@end
