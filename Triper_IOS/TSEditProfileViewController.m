//
//  TSEditProfileViewController.m
//  Triper_IOS
//
//  Created by Mac on 01.09.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSEditProfileViewController.h"

@import Firebase;
@import FirebaseDatabase;

@interface TSEditProfileViewController ()

@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) FIRUser *user;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *professionTextField;
@property (weak, nonatomic) IBOutlet UITextField *commingFromTextField;
@property (weak, nonatomic) IBOutlet UITextField *coingToTextField;
@property (weak, nonatomic) IBOutlet UITextField *currentArreaTextField;
@property (weak, nonatomic) IBOutlet UITextField *launguageTextField;
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;
@property (weak, nonatomic) IBOutlet UITextField *missionTextField;
@property (weak, nonatomic) IBOutlet UITextField *aboutTextField;
@property (weak, nonatomic) IBOutlet UITextField *backgroundTextField;
@property (weak, nonatomic) IBOutlet UITextField *interestTextField;
@property (weak, nonatomic) IBOutlet UIButton *avatarButton;

- (IBAction)actionUpdate:(id)sender;

@end

@implementation TSEditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.ref = [[FIRDatabase database] reference];
    self.user = [FIRAuth auth].currentUser;
}

- (IBAction)actionBackPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionUpdate:(id)sender
{
    NSDictionary *userData = @{@"name":self.nameTextField.text,
                               @"email":self.emailTextField.text,
                               @"password":self.passwordTextField.text,
                               @"profession":self.professionTextField.text,
                               @"commingFrom":self.commingFromTextField.text,
                               @"coingTo":self.coingToTextField.text,
                               @"currentArrea":self.currentArreaTextField.text,
                               @"launguage":self.launguageTextField.text,
                               @"age":self.ageTextField.text,
                               @"mission":self.missionTextField.text,
                               @"about":self.aboutTextField.text,
                               @"background":self.backgroundTextField.text,
                               @"nterest":self.interestTextField.text,
                               @"avatar":self.avatarButton.imageView.image};
    
    
    [[[[self.ref child:@"users"] child:self.user.uid] child:@"username"] setValue:userData];
}

@end
