//
//  ViewController.m
//  Triper_IOS
//
//  Created by Mac on 23.06.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSLoginViewController.h"
#import "TSServerManager.h"

@interface TSLoginViewController ()

@end

@implementation TSLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    [[TSServerManager sharedManager] authorizationOfNewUser:self.userNameTextField.text userLogin:self.passwordTextField.text];
}

- (IBAction)signInButtonAction:(UIButton *)sender
{
    if (![self.userNameTextField.text isEqualToString:@""] && ![self.passwordTextField.text isEqualToString:@""]) {
        [self sendingUserDataToTheServer];
    }
}

@end
