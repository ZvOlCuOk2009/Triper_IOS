//
//  TSCellView.m
//  Triper_IOS
//
//  Created by Mac on 24.07.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSCellView.h"
#import "TSPrefixHeader.pch"

@interface TSCellView ()

@property (strong, nonatomic) UIImage *avatar;

@end

@implementation TSCellView

- (void)drawRect:(CGRect)rect
{
    
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

+ (instancetype)cellView
{
    
    TSCellView *view = nil;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if (IS_IPHONE_4) {
            
            UINib *nib = [UINib nibWithNibName:@"TSCellView" bundle:nil];
            view = [nib instantiateWithOwner:self options:nil][0];
            view.frame = CGRectMake(0, 0, 320, 100);
            
        } else if (IS_IPHONE_5) {
            
            UINib *nib = [UINib nibWithNibName:@"TSCellView" bundle:nil];
            view = [nib instantiateWithOwner:self options:nil][0];
            view.frame = CGRectMake(0, 0, 320, 100);
            
        } else if (IS_IPHONE_6) {
            
            UINib *nib = [UINib nibWithNibName:@"TSCellView6" bundle:nil];
            view = [nib instantiateWithOwner:self options:nil][0];
            view.frame = CGRectMake(0, 0, 375, 118);
            
        } else if (IS_IPHONE_6_PLUS) {
            
            UINib *nib = [UINib nibWithNibName:@"TSCellView6Plus" bundle:nil];
            view = [nib instantiateWithOwner:self options:nil][0];
            view.frame = CGRectMake(0, 0, 414, 130);
        }
    }
    
    return view;
}

@end
