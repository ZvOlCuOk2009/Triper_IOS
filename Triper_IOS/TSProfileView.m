//
//  TSProfileView.m
//  Triper_IOS
//
//  Created by Mac on 13.07.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#define IS_IPHONE_4 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)480) < DBL_EPSILON)
#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)568) < DBL_EPSILON)
#define IS_IPHONE_6 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)667) < DBL_EPSILON)
#define IS_IPHONE_6_PLUS (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)736) < DBL_EPSILON)

#import "TSProfileView.h"
#import "TSServerManager.h"
#import "TSRandomFriendsTest.h"
#import "TSHandler.h"
#import "TSDisplayContent.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface TSProfileView ()

@end

@implementation TSProfileView

- (void)awakeFromNib
{
    [super awakeFromNib];
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // initialization
    }    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // initialization
    }
    return self;
}

- (IBAction)getEmailAction:(UIButton *)sender
{
    
}

- (IBAction)mainButtonsAction:(UIButton *)sender
{
    switch (sender.tag) {
        case 1:
        {[UIView animateWithDuration:0.3 animations:^{
            self.arrowImageView.frame = [TSHandler hendlerPositionArrow:1];
            self.contentTextView.text = [TSDisplayContent displayContent:1];
        }];}
            break;
        case 2:
        {[UIView animateWithDuration:0.3 animations:^{
            self.arrowImageView.frame = [TSHandler hendlerPositionArrow:2];
            self.contentTextView.text = [TSDisplayContent displayContent:2];
        }];}
            break;
        case 3:
        {[UIView animateWithDuration:0.3 animations:^{
            self.arrowImageView.frame = [TSHandler hendlerPositionArrow:3];
            self.contentTextView.text = [TSDisplayContent displayContent:3];
        }];}
            break;
        case 4:
        {[UIView animateWithDuration:0.3 animations:^{
            self.arrowImageView.frame = [TSHandler hendlerPositionArrow:4];
            self.contentTextView.text = [TSDisplayContent displayContent:4];
        }];}
            break;
        default:
            break;
    }
}

+ (instancetype)profileView
{
    
    TSProfileView *view = nil;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if (IS_IPHONE_4) {
            UINib *nib = [UINib nibWithNibName:@"TSProfileView" bundle:nil];
            view = [nib instantiateWithOwner:self options:nil][0];
            view.frame = CGRectMake(8, 20, 304, 482);
        } else if (IS_IPHONE_5) {
            UINib *nib = [UINib nibWithNibName:@"TSProfileView" bundle:nil];
            view = [nib instantiateWithOwner:self options:nil][0];
            view.frame = CGRectMake(8, 20, 304, 482);
        } else if (IS_IPHONE_6) {
            UINib *nib = [UINib nibWithNibName:@"TSProfileView6" bundle:nil];
            view = [nib instantiateWithOwner:self options:nil][0];
            view.frame = CGRectMake(11, 25, 356, 567);
        } else if (IS_IPHONE_6_PLUS) {
            
        }
    }
    
    return view;
}

@end
