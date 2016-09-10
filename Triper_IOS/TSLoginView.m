//
//  TSLoginView.m
//  Triper_IOS
//
//  Created by Mac on 10.09.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//


#define IS_IPHONE_4 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)480) < DBL_EPSILON)
#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)568) < DBL_EPSILON)
#define IS_IPHONE_6 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)667) < DBL_EPSILON)
#define IS_IPHONE_6_PLUS (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)736) < DBL_EPSILON)

#import "TSLoginView.h"

@implementation TSLoginView


- (void)drawRect:(CGRect)rect {
    // Drawing code
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

+ (instancetype)loginView
{
    TSLoginView *view = nil;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if (IS_IPHONE_4) {
            
            UINib *nib = [UINib nibWithNibName:@"TSLoginView" bundle:nil];
            view = [nib instantiateWithOwner:self options:nil][0];
            view.frame = CGRectMake(0, 0, 320, 568);
            
        } else if (IS_IPHONE_5) {
            
            UINib *nib = [UINib nibWithNibName:@"TSLoginView" bundle:nil];
            view = [nib instantiateWithOwner:self options:nil][0];
            view.frame = CGRectMake(0, 0, 320, 568);
            
        } else if (IS_IPHONE_6) {
            
            UINib *nib = [UINib nibWithNibName:@"TSLoginView6" bundle:nil];
            view = [nib instantiateWithOwner:self options:nil][0];
            view.frame = CGRectMake(0, 0, 375, 667);
            
        } else if (IS_IPHONE_6_PLUS) {
            
            UINib *nib = [UINib nibWithNibName:@"TSProfileView6" bundle:nil];
            view = [nib instantiateWithOwner:self options:nil][0];
            view.frame = CGRectMake(0, 0, 414, 736);
        }
    }
    
    return view;
}

@end
