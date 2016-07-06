//
//  TSHomeViewController.m
//  Triper_IOS
//
//  Created by Mac on 02.07.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSHomeViewController.h"
#import "TSMenuViewController.h"
#import "TSServerManager.h"
#import "SWRevealViewController.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface TSHomeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) TSUser *currentUser;

@end

@implementation TSHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Home";
    
    _barButton.target = self.revealViewController;
    _barButton.action = @selector(revealToggle:);
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    FBSDKProfilePictureView *avatar = [[TSServerManager sharedManager]
                                       requestUserImageFromTheServerFacebook:self.avatarImageView];
    avatar.layer.cornerRadius = avatar.frame.size.width / 2;
    avatar.clipsToBounds = YES;
    [self.view addSubview:avatar];

}

@end
