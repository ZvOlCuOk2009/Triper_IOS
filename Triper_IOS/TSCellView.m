//
//  TSCellView.m
//  Triper_IOS
//
//  Created by Mac on 24.07.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSCellView.h"
#import "TSRandomFriendsTest.h"

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
    UINib *nib = [UINib nibWithNibName:@"TSCellView" bundle:nil];
    TSCellView *view = [nib instantiateWithOwner:self options:nil][0];
    view.frame = CGRectMake(0, 0, 320, 100);
    return view;
}

@end
