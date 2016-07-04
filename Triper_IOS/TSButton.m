//
//  TSButton.m
//  Triper_IOS
//
//  Created by Mac on 04.07.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue: b/255.0 alpha:1.0]
#define MAIN_COLOR RGB(255, 110, 50)
#define SEPARATOR_COLOR RGB(200, 200, 200)

#import "TSButton.h"

@implementation TSButton

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title icon:(NSString *)icon
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        CGRect frameTitle = CGRectMake(65, 18, 75, 18);
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:frameTitle];
        titleLabel.frame = frameTitle;
        titleLabel.text = title;
        titleLabel.textColor = MAIN_COLOR;
        [self addSubview:titleLabel];
        
        CGRect frameIcon = CGRectMake(20, 16, 18, 18);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frameIcon];
        imageView.image = [UIImage imageNamed:icon];
        [self addSubview:imageView];
        
        CGRect frameSeparator = CGRectMake(0, 49, 320, 1);
        UIView *separator = [[UIView alloc] initWithFrame:frameSeparator];
        separator.backgroundColor = SEPARATOR_COLOR;
        [self addSubview:separator];
        
    }
    return self;
}

@end
