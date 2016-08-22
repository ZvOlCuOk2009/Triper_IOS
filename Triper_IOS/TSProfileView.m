//
//  TSProfileView.m
//  Triper_IOS
//
//  Created by Mac on 13.07.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

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
    UINib *nib = [UINib nibWithNibName:@"TSProfileView" bundle:nil];
    TSProfileView *view = [nib instantiateWithOwner:self options:nil][0];
    view.frame = CGRectMake(8, 20, 304, 482);
    return view;
}

@end
