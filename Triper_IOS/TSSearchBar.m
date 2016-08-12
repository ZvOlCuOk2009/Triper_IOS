//
//  TSSearchBar.m
//  Triper_IOS
//
//  Created by Mac on 11.08.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue: b/255.0 alpha:1.0]
#define WHITE_COLOR RGB(175, 175, 175)
#define GRAY_COLOR RGB(65, 70, 80)

#import "TSSearchBar.h"

@implementation TSSearchBar


- (instancetype)initWithView:(UIView *)view
{
    self = [super init];
    if (self) {
        self = [[TSSearchBar alloc] initWithFrame:CGRectMake(view.bounds.size.width / 2, - 5,
                                                             view.bounds.size.width / 2, 44)];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    
    self.searchBarStyle = UISearchBarStyleMinimal;
    self.tintColor = WHITE_COLOR;
    UITextField *txtSearchField = [self valueForKey:@"_searchField"];
    txtSearchField.layer.cornerRadius = 4;
    txtSearchField.layer.borderWidth = 1.0f;
    txtSearchField.layer.borderColor = WHITE_COLOR.CGColor;
    txtSearchField.textColor = WHITE_COLOR;
}

@end
