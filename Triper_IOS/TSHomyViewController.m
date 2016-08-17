//
//  TSTest2ViewController.m
//  Triper_IOS
//
//  Created by Mac on 08.07.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSHomyViewController.h"
#import "TSServerManager.h"
#import "TSUser.h"
#import "TSLoginViewController.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface TSHomyViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (strong, nonatomic) TSUser *user;
@property (weak, nonatomic) IBOutlet UIButton *outButton;

@end

@implementation TSHomyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    FBSDKProfilePictureView *avatar = [[TSServerManager sharedManager]
                                       requestUserImageFromTheServerFacebook:self.avatarImageView ID:@"me"];
    avatar.layer.cornerRadius = avatar.frame.size.width / 2;
    avatar.clipsToBounds = YES;
    [self.view addSubview:avatar];
    
    self.outButton.layer.cornerRadius = self.outButton.frame.size.width / 2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.    
}


- (IBAction)addFriendsList:(id)sender
{
    
}


- (IBAction)actionInviteFriends:(id)sender
{
    [[TSServerManager sharedManager] inviteUserFriendsTheServerFacebook:self];
}

- (IBAction)actionLogOut:(id)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Do you want to exit"
                                                                             message:@"the application?"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actionYes = [UIAlertAction actionWithTitle:@"Yes"
                                                        style:UIAlertActionStyleDestructive
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          [[TSServerManager sharedManager] logOutFacebook];
                                                          TSLoginViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TSLoginViewController"];
                                                          [self presentViewController:controller animated:YES completion:nil];
                                                      }];
    
    UIAlertAction *actionNo = [UIAlertAction actionWithTitle:@"No"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) { }];
    
    [alertController addAction:actionYes];
    [alertController addAction:actionNo];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
