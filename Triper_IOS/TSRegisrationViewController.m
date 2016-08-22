//
//  TSRegisrationViewController.m
//  Triper_IOS
//
//  Created by Mac on 20.08.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSRegisrationViewController.h"
#import "TSFireUser.h"

@import Firebase;
@import FirebaseAuth;
@import FirebaseDatabase;

@interface TSRegisrationViewController ()

@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) TSFireUser *fireUser;

@property (weak, nonatomic) IBOutlet UITextField *emailRegistrationTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordRegistrationTextField;

@end

@implementation TSRegisrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)registerButton:(id)sender
{
    NSString *email = self.emailRegistrationTextField.text;
    NSString *password = self.passwordRegistrationTextField.text;
    
//    FIRAuthCredential *credential = [FIREmailPasswordAuthProvider credentialWithEmail:email password:password];
//    [[FIRAuth auth] signInWithCredential:credential completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
//        if (!error) {
////            self.fireUser = [[TSFireUser alloc] initWithDictionary:userData];
//
//        } else {
//            NSLog(@"Error - %@", error.localizedDescription);
//        }
//    }];
    
    [[FIRAuth auth] createUserWithEmail:email
                               password:password
                             completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
                                 if (!error) {
                                     
                                     self.fireUser = [[TSFireUser alloc] initWithDictionary:(NSDictionary *)user];
                                     
                                 } else {
                                     NSLog(@"Error - %@", error.localizedDescription);
                                 }
                             }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
