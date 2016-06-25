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

@property (strong, nonatomic) NSArray *token;


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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSArray *textFields = @[self.userNameTextField, self.passwordTextField];
    
    UIColor *color = [UIColor blackColor];
    self.userNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"  Username" attributes:@{NSForegroundColorAttributeName: color}];
    
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"  Password" attributes:@{NSForegroundColorAttributeName: color}];
    
    for (UITextField *textField in textFields) {
        textField.layer.cornerRadius = 2.0f;
        textField.layer.borderWidth = 1.0f;
        textField.layer.borderColor = [[UIColor lightGrayColor]CGColor];
        textField.layer.masksToBounds = YES;
    }
    
    
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
