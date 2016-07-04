//
//  ViewController.m
//  Triper_IOS
//
//  Created by Mac on 23.06.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSLoginViewController.h"
#import "TSServerManager.h"
#import "TSMenuViewController.h"
#import "TSUser.h"
#import "TSHomeViewController.h"
#import "TSHomeNavigationController.h"
#import "SWRevealViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface TSLoginViewController ()

@property (strong, nonatomic) NSArray *token;

@end

@implementation TSLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *myLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    myLoginButton.frame = CGRectMake(165, 457, 55, 55);
    [myLoginButton setImage:[UIImage imageNamed:@"fb_login"] forState:UIControlStateNormal];
    [myLoginButton addTarget:self action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myLoginButton];
}

-(void)loginButtonClicked
{
    if ([FBSDKAccessToken currentAccessToken]) {
        
        NSLog(@"Token is available : %@", [[FBSDKAccessToken currentAccessToken]tokenString]);
        
        NSDictionary * parameters = @{@"fields": @"id, name, link, first_name, last_name, picture.type(large), email, birthday, bio, location, friends, hometown, friendlists"};
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error)
             {
                 NSLog(@"resultis:%@", result);
                 SWRevealViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
                 CATransition *transition = [CATransition animation];
                 transition.duration = 0.4;
                 transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                 transition.type = kCATransitionPush;
                 transition.subtype = kCATransitionFromRight;
                 [self.view.window.layer addAnimation:transition forKey:nil];
                 TSUser *user = [[TSUser alloc] initWithDictionary:result];
                 //[controller receiveUserData:user];
                 [self presentViewController:controller animated:NO completion:nil];
                 
             } else {
                 NSLog(@"Error %@",error);
             }
         }];
    } else {
        
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logInWithReadPermissions: @[@"public_profile"]
                     fromViewController:self
                                handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                    if (error) {
                                        NSLog(@"Process error");
                                    } else if (result.isCancelled) {
                                        NSLog(@"Cancelled");
                                    } else {
                                        NSLog(@"Logged in");
                                    }
                                }];
    }
}

- (IBAction)registerButton:(id)sender
{
    // For more complex open graph stories, use `FBSDKShareAPI`
    // with `FBSDKShareOpenGraphContent`
    /* make the API call */
    
    /*
    NSDictionary *params = @{@"fields":@"id, first_name, last_name, cover"};
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"https://www.facebook.com/sasha.tsvigun"
                                                                   parameters:params
                                                                   HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        if (error) {
            NSLog(@"Error = %@", [error localizedDescription]);
        }
    }];
     
    
    
     
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me/feed"
                                       parameters:@{@"message":@"This is a status update"}
                                       HTTPMethod:@"POST"]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if ([error.userInfo[FBSDKGraphRequestErrorGraphErrorCode] isEqual:@200]) {
             NSLog(@"permission error = %@", [error localizedDescription]);
         }
     }];
      */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        
    UIColor *color = [UIColor blackColor];
    self.userNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Username" attributes:@{NSForegroundColorAttributeName: color}];
    
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];}

- (IBAction)userNameTextField:(UITextField *)sender
{
    NSLog(@"%@", sender.text);
}

- (IBAction)passwordTextField:(UITextField *)sender
{
    NSLog(@"%@", sender.text);
}

#pragma mark - API

- (void)sendingUserDataToTheServer
{
    [[TSServerManager sharedManager] authorizationOfNewUser:self.userNameTextField.text
                                                  userLogin:self.passwordTextField.text
                                                  onSuccess:^(NSArray *token) {
                                                      self.token = token;
                                                  }];
}

- (IBAction)signInButtonAction:(UIButton *)sender
{
    if (![self.userNameTextField.text isEqualToString:@""] && ![self.passwordTextField.text isEqualToString:@""]) {
        [self sendingUserDataToTheServer];
    }
}

@end
