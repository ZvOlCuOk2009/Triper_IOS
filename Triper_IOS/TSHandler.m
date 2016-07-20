//
//  TSHandler.m
//  Triper_IOS
//
//  Created by Mac on 19.07.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSHandler.h"

@implementation TSHandler

+ (CGRect)hendlerPositionArrow:(NSInteger)tag
{
    CGRect frame;
    if (tag == 1) {
        frame = CGRectMake(22, 298, 24, 8);
    } else if (tag == 2) {
        frame = CGRectMake(93, 298, 24, 8);
    } else if (tag == 3) {
        frame = CGRectMake(176, 298, 24, 8);
    } else if (tag == 4) {
        frame = CGRectMake(262, 298, 24, 8);
    }
    return frame;
}

@end
