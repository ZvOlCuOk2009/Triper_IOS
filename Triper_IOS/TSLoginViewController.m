//
//  ViewController.m
//  Triper_IOS
//
//  Created by Mac on 23.06.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSLoginViewController.h"
#import "TSServerManager.h"
#import "TSTabBarController.h"
#import "TSUser.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>

@import Firebase;
@import FirebaseAuth;

@interface TSLoginViewController () <FBSDKLoginButtonDelegate>

@property (strong, nonatomic) NSArray *token;
@property (strong, nonatomic) IBOutlet FBSDKLoginButton *loginButton;

@end

@implementation TSLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    _loginButton = [[FBSDKLoginButton alloc] init];
//    _loginButton.frame = CGRectMake(135, 45, 55, 55);
//    [_loginButton setImage:[UIImage imageNamed:@"fb_login"] forState:UIControlStateNormal];
//    [_loginButton addTarget:self action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_loginButton];
    //self.loginButton = (FBSDKLoginButton *)myLoginButton;
    
    self.loginButton = [[FBSDKLoginButton alloc] init];
    self.loginButton.frame = CGRectMake(135, 45, 55, 55);
    [self.loginButton setImage:[UIImage imageNamed:@"fb_login"] forState:UIControlStateNormal];
    self.loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    [self.view addSubview:self.loginButton];
    
    _loginButton.delegate = self;
}

-(void)loginButtonClicked
{
    if ([FBSDKAccessToken currentAccessToken]) {
        
        NSString *token = [[FBSDKAccessToken currentAccessToken]tokenString];
        
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSDictionary * parameters = @{@"fields": @"id, name, link, first_name, last_name, picture.type(large), email, birthday, bio, location, friends, hometown, friendlists"};
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me"
                                           parameters:parameters]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error)
             {
                 [self openTheTabBarController];
                 
                 NSLog(@"resultis:%@", result);
             } else {
                 NSLog(@"Error %@", error);
             }
         }];
                
    } else {
        
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logInWithReadPermissions:@[@"public_profile"]
                     fromViewController:self
                                handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                    if (error) {
                                        NSLog(@"Process error");
                                    } else if (result.isCancelled) {
                                        NSLog(@"Cancelled");
                                    } else {
                                        NSLog(@"Logged in");
                                        [self openTheTabBarController];
                                    }
                                }];
    }
}

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
              error:(NSError *)error
{
    if ([FBSDKAccessToken currentAccessToken]) {
        
        NSString *token = [[FBSDKAccessToken currentAccessToken]tokenString];
        
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSDictionary * parameters = @{@"fields": @"id, name, link, first_name, last_name, picture.type(large), email, birthday, bio, location, friends, hometown, friendlists"};
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me"
                                           parameters:parameters]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error)
             {
                 [self openTheTabBarController];
                 NSLog(@"resultis:%@", result);
             } else {
                 NSLog(@"Error %@", error);
             }
         }];

    } else {
        
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logInWithReadPermissions:@[@"public_profile"]
                     fromViewController:self
                                handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                    if (error) {
                                        NSLog(@"Process error");
                                    } else if (result.isCancelled) {
                                        NSLog(@"Cancelled");
                                    } else {
                                        NSLog(@"Logged in");
                                        [self openTheTabBarController];
                                    }
                                }];
    }
    
    FIRAuthCredential *credential = [FIRFacebookAuthProvider
                                     credentialWithAccessToken:[FBSDKAccessToken currentAccessToken].tokenString];
    
    [[FIRAuth auth] signInWithCredential:credential
                              completion:^(FIRUser *user, NSError *error) {
                                  NSLog(@"User login firebase App");
                              }];
    NSLog(@"User log In");
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
{
    NSLog(@"User log Out");
}

- (void)openTheTabBarController
{
    TSTabBarController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TSTabBarController"];
    [self presentViewController:controller animated:YES completion:nil];
}


- (IBAction)registerButton:(id)sender
{
    
    NSDictionary *params = @{@"fields":@"id, first_name, last_name, cover"};
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me"
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
