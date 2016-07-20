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
#import "TSProfileView.h"
#import "TSRandomFriendsTest.h"
#import "TSProfileViewController.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Quickblox/Quickblox.h>

@interface TSHomyViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) TSUser *user;

@end

@implementation TSHomyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    FBSDKProfilePictureView *avatar = [[TSServerManager sharedManager]
//                                       requestUserImageFromTheServerFacebook:self.avatarImageView];
//    avatar.layer.cornerRadius = avatar.frame.size.width / 2;
//    avatar.layer.borderWidth = 4;
//    avatar.layer.borderColor = [[UIColor whiteColor] CGColor];
//    avatar.clipsToBounds = YES;
//    [self.view addSubview:avatar];
    
    TSProfileView *profileView = [TSProfileView profileView];
    [self.view addSubview:profileView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}
- (IBAction)actionInviteFriends:(id)sender
{
    [[TSServerManager sharedManager] requestUserFriendsTheServerFacebook:^(TSUser *user) {
        self.user = user;
        NSLog(@"User = %@", user.description);
    }];
}

- (IBAction)actionLogOut:(id)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Вы хотите выйти"
                                                                             message:@"из приложения?"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actionYes = [UIAlertAction actionWithTitle:@"Да"
                                                        style:UIAlertActionStyleDestructive
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          [[TSServerManager sharedManager] logOutFacebook];
                                                          TSLoginViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TSLoginViewController"];
                                                          [self presentViewController:controller animated:YES completion:nil];
                                                      }];
    
    UIAlertAction *actionNo = [UIAlertAction actionWithTitle:@"Нет"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) { }];
    
    [alertController addAction:actionYes];
    [alertController addAction:actionNo];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
