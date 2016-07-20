//
//  ViewController.h
//  Triper_IOS
//
//  Created by Mac on 23.06.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface TSLoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)signInButtonAction:(UIButton *)sender;

@end

