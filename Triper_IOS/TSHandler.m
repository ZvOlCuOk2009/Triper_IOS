//
//  TSHandler.m
//  Triper_IOS
//
//  Created by Mac on 19.07.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#define IS_IPHONE_4 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)480) < DBL_EPSILON)
#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)568) < DBL_EPSILON)
#define IS_IPHONE_6 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)667) < DBL_EPSILON)
#define IS_IPHONE_6_PLUS (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)736) < DBL_EPSILON)

#import "TSHandler.h"

@implementation TSHandler

+ (CGRect)hendlerPositionArrow:(NSInteger)tag
{
    CGFloat yValue = 0.0;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if (IS_IPHONE_4) {
            
        } else if (IS_IPHONE_5) {
            yValue = 298;
        } else if (IS_IPHONE_6) {
            yValue = 350;
        } else if (IS_IPHONE_6_PLUS) {
            
        }
    }
    
    CGRect frame;
    if (tag == 1) {
        frame = CGRectMake(22, yValue, 24, 8);
    } else if (tag == 2) {
        frame = CGRectMake(93, yValue, 24, 8);
    } else if (tag == 3) {
        frame = CGRectMake(176, yValue, 24, 8);
    } else if (tag == 4) {
        frame = CGRectMake(262, yValue, 24, 8);
    }
    return frame;
}

@end
