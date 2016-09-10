//
//  TSLoginView.h
//  Triper_IOS
//
//  Created by Mac on 10.09.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <linkedin-sdk/LISDK.h>

@interface TSLoginView : UIView

@property (strong, nonatomic) IBOutlet FBSDKButton *loginButton;
@property (weak, nonatomic) IBOutlet GIDSignInButton *signInButton;

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)signInButtonAction:(UIButton *)sender;


+ (instancetype)loginView;

@end
