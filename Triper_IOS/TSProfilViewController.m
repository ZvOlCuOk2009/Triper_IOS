//
//  TSProfilViewController.m
//  Triper_IOS
//
//  Created by Mac on 01.07.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSProfilViewController.h"
#import "SWRevealViewController.h"
#import "TSServerManager.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface TSProfilViewController ()

@property (weak, nonatomic) IBOutlet UIView *personalDataView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *miniUserNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageUserLabel;

@end

@implementation TSProfilViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Profil";
    
    _barButton.target = self.revealViewController;
    _barButton.action = @selector(revealToggle:);
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    FBSDKProfilePictureView *avatar = [[TSServerManager sharedManager]
                                       requestUserImageFromTheServerFacebook:self.avatarImageView];
    avatar.layer.cornerRadius = avatar.frame.size.width / 2;
    avatar.clipsToBounds = YES;
    [self.personalDataView addSubview:avatar];
    
    [[TSServerManager sharedManager] requestUserDataFromTheServerFacebook:^(TSUser *user) {
        if (user) {
            self.userNameLabel.text = user.name;
            self.miniUserNameLabel.text = user.name;
        } else {
            NSLog(@"Error");
        }
    }];
}

@end
