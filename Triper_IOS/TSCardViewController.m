//
//  TSCardViewController.m
//  Triper_IOS
//
//  Created by Mac on 25.06.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSCardViewController.h"
#import "TSMenuViewController.h"
#import "SWRevealViewController.h"
#import "TSServerManager.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface TSCardViewController ()

@property (weak, nonatomic) IBOutlet UIView *personalDataView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeOfWorkLabel;
@property (weak, nonatomic) IBOutlet UILabel *miniUserNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *webSiteLabel;

@end

@implementation TSCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"Card";
    
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
            self.locationLabel.text = user.location;
        } else {
            NSLog(@"Error");
        }
    }];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    
}

@end
