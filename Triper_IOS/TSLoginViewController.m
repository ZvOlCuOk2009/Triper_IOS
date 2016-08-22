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
#import "TSFireUser.h"

#import <GoogleSignIn/GoogleSignIn.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <linkedin-sdk/LISDK.h>

@import Firebase;
@import FirebaseAuth;
@import FirebaseDatabase;

@interface TSLoginViewController () <FBSDKLoginButtonDelegate, GIDSignInUIDelegate>

@property (strong, nonatomic) IBOutlet FBSDKLoginButton *loginButton;
@property (weak, nonatomic) IBOutlet GIDSignInButton *signInButton;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) TSFireUser *fireUser;

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
//    [self.loginButton setImage:[UIImage imageNamed:@"fb_login"] forState:UIControlStateNormal];
//    self.loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
//    self.loginButton.layer.cornerRadius = self.loginButton.frame.size.width / 2;
    self.loginButton.hidden = YES;
    [self.view addSubview:self.loginButton];
    
    _loginButton.delegate = self;
    
    self.ref = [[FIRDatabase database] reference];    
    
    [GIDSignIn sharedInstance].uiDelegate = self;
    [[GIDSignIn sharedInstance] signInSilently];
    
    
//    linkedin
    
//    NSString *linkedinInKey = @"776i4jzlob18oz";
//    NSString *linkedinInSecret = @"D9CWpr620WbmIZEl";
}


#pragma mark - Autorization Facebook


- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
              error:(NSError *)error
{
    if ([FBSDKAccessToken currentAccessToken]) {
        
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
    
    if ([FBSDKAccessToken currentAccessToken]) {
        
        FIRAuthCredential *credential = [FIRFacebookAuthProvider
                                         credentialWithAccessToken:[FBSDKAccessToken currentAccessToken].tokenString];
        
        [[FIRAuth auth] signInWithCredential:credential
                                  completion:^(FIRUser *user, NSError *error) {
                                      
                                      NSDictionary *userData = @{@"userID":user.uid,
                                                                 @"displayName":user.displayName,
                                                                 @"email":user.email,
                                                                 @"photoURL":user.photoURL.absoluteString};
                                      
                                      //                                  NSString *displayName = [userData objectForKey:@"displayName"];
                                      //                                  NSArray *initials = [displayName componentsSeparatedByString:@" "];
                                      //                                  NSString *firstLetter = [[initials firstObject] substringToIndex:1];
                                      //                                  NSString *secondWord = [initials lastObject];
                                      //                                  NSString *keyNode = [NSString stringWithFormat:@"%@%@", firstLetter, secondWord];
                                      
                                      self.fireUser = [[TSFireUser alloc] initWithDictionary:userData];
                                      
                                      NSString *token = [userData objectForKey:@"userID"];
                                      
                                      [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
                                      [[NSUserDefaults standardUserDefaults] synchronize];
                                      
                                      [[[[self.ref child:@"users"] child:user.uid] child:@"username"] setValue:self.fireUser];
                                  }];
        NSLog(@"User log In");
    }
    
}


- (void)openTheTabBarController
{
    TSTabBarController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TSTabBarController"];
    [self presentViewController:controller animated:YES completion:nil];
}


- (IBAction)myFacebookButton:(id)sender
{
    [self.loginButton sendActionsForControlEvents:UIControlEventTouchUpInside];
}


- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
{
    NSLog(@"User log Out");
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
    
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
}



#pragma mark - API


- (IBAction)signInButtonAction:(UIButton *)sender
{
    if (![self.userNameTextField.text isEqualToString:@""] && ![self.passwordTextField.text isEqualToString:@""]) {
        [self signInWithEmailAndPassword];
    }
}


- (void)signInWithEmailAndPassword
{
    [[FIRAuth auth] signInWithEmail:self.userNameTextField.text
                           password:self.passwordTextField.text
                         completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
                             if (!error) {
                                 
                             } else {
                                 NSLog(@"Error %@", error.localizedDescription);
                             }
                         }];
}



#pragma mark - Autorization Google


- (IBAction)googlePlusButtonTouchUpInside:(id)sender
{
    [[GIDSignIn sharedInstance] signIn];
}


- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error
{
    
}


- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController
{
    [self presentViewController:viewController animated:YES completion:nil];
}


- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error
{
    
}



#pragma mark - Autorization Linkedin


- (IBAction)actionButtonLinkedin:(id)sender
{
    [LISDKSessionManager createSessionWithAuth:[NSArray arrayWithObjects:LISDK_BASIC_PROFILE_PERMISSION, LISDK_EMAILADDRESS_PERMISSION, nil]
                                         state:@"code"
                        showGoToAppStoreDialog:YES
                                  successBlock:^(NSString *returnState) {
                                      
                                      [[LISDKAPIHelper sharedInstance] getRequest:@"https://api.linkedin.com/v1/people/~"
                                                                          success:^(LISDKAPIResponse *response) {
                                                                              
                                                                              NSData* data = [response.data dataUsingEncoding:NSUTF8StringEncoding];
                                                                              NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                                                              
                                                                              NSString *authUsername = [NSString stringWithFormat: @"%@ %@", [dictResponse valueForKey: @"firstName"], [dictResponse valueForKey: @"lastName"]];
                                                                              NSLog(@"Authenticated user name  : %@", authUsername);
                                                                              
                                                                          } error:^(LISDKAPIError *error) {
                                      
                                       }];
                                  } errorBlock:^(NSError *error) {
                                        NSLog(@"%s %@","error called! ", [error description]);
                                    }];
}


@end



