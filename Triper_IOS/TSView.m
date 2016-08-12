//
//  TSView.m
//  Triper_IOS
//
//  Created by Mac on 12.08.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue: b/255.0 alpha:1.0]
#define GRAY_COLOR RGB(65, 70, 80)

#import "TSView.h"

@implementation TSView


- (instancetype)initWithView:(UIView *)view
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, view.frame.size.width, 36);
        self.backgroundColor = GRAY_COLOR;
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}

@end
