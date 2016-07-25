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
    
    TSRandomFriendsTest *testUser = [[TSRandomFriendsTest alloc] init];
    
    NSString *name = [NSString stringWithFormat:@"%@ %@", [testUser.firstNames objectAtIndex:arc4random_uniform(8)],
                                                          [testUser.lastNames objectAtIndex:arc4random_uniform(8)]];
    NSString *profession = [testUser.profession objectAtIndex:arc4random_uniform(10)];
    NSString *countryComing = [testUser.countryComing objectAtIndex:arc4random_uniform(14)];
    NSString *countryCoing = [testUser.countryCoing objectAtIndex:arc4random_uniform(14)];
    NSString *cityCurrent = [testUser.cityCurrent objectAtIndex:arc4random_uniform(11)];
    NSString *age = [NSString stringWithFormat:@"%d", arc4random_uniform(15) + 30];
    NSString *launguage = [testUser.launguage objectAtIndex:arc4random_uniform(7)];
    UIImage *avatar = [UIImage imageNamed:[testUser.avatars objectAtIndex:arc4random_uniform(16)]];
    NSString *match = [NSString stringWithFormat:@"%d", arc4random_uniform(500) + 200];
    
    self.nameLabel.text = name;
    self.professionLabel.text = profession;
    self.comingFromLabel.text = countryComing;
    self.coingToLabel.text = countryCoing;
    self.currentArreaLabel.text = cityCurrent;
    self.ageLabel.text = age;
    self.launguageLabel.text = launguage;
    self.avatarImageView.image = avatar;
    self.miniNameLabel.text = name;
    self.countMatchLabel.text = match;
    self.contentTextView.text = [TSDisplayContent displayContent:1];
}

- (void)_init
{
    NSLog(@"init");
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _init];
    }    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _init];
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
