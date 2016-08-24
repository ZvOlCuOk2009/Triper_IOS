//
//  TSRegisrationViewController.m
//  Triper_IOS
//
//  Created by Mac on 20.08.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSRegisrationViewController.h"
#import "TSFireUser.h"
#import "TSTabBarController.h"

@import Firebase;
@import FirebaseAuth;
@import FirebaseDatabase;

@interface TSRegisrationViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) FIRDatabaseReference *ref;

@property (weak, nonatomic) IBOutlet UITextField *emailRegistrationTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordRegistrationTextField;
@property (weak, nonatomic) IBOutlet UITextField *displayNameRegiatration;
@property (weak, nonatomic) IBOutlet UIButton *avatarPlaceholder;

@property (strong, nonatomic) IBOutlet UIImagePickerController *picker;
@property (strong, nonatomic) IBOutlet UIImage *image;

@end

@implementation TSRegisrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loa
    
    self.ref = [[FIRDatabase database] reference];
    
    self.avatarPlaceholder.layer.cornerRadius = self.avatarPlaceholder.bounds.size.width / 2;
    self.avatarPlaceholder.layer.masksToBounds = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)tapSelectImageButton:(id)sender
{
    self.picker = [[UIImagePickerController alloc] init];
    self.picker.delegate = self;
    self.picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    self.picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:self.picker.sourceType];
    self.picker.allowsEditing = NO;
    self.picker.edgesForExtendedLayout = YES;
    
    [self presentViewController:self.picker animated:YES completion:nil]; 
}


- (void)imagePickerController:(UIImagePickerController *) Picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [self.picker dismissViewControllerAnimated:YES completion:nil];
    self.image = [info objectForKey:UIImagePickerControllerOriginalImage];
//    self.avatarPlaceholder.imageView.image = image;
    
    [self.avatarPlaceholder setImage:self.image forState:UIControlStateNormal];
    
}


- (IBAction)registerButton:(id)sender
{
    
    NSData *dataImage = UIImagePNGRepresentation(self.image);
    NSString *stringImage = [dataImage base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    
//    NSData *data = [[NSData alloc]initWithBase64EncodedString:stringImage options:NSDataBase64DecodingIgnoreUnknownCharacters];
//    UIImage *convertImage = [UIImage imageWithData:data];
    
    NSString *email = self.emailRegistrationTextField.text;
    NSString *password = self.passwordRegistrationTextField.text;
    NSString *displayName = self.displayNameRegiatration.text;
    
    [[FIRAuth auth] createUserWithEmail:email
                               password:password
                             completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
                                 if (!error) {
                                     
                                     if (user.uid) {
                                         
                                         NSDictionary *userData = @{@"userID":user.uid,
                                                                    @"displayName":displayName,
                                                                    @"email":email,
                                                                    @"photoURL":stringImage};
                                         
                                         NSString *token = user.uid;
                                         
                                         [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
                                         [[NSUserDefaults standardUserDefaults] synchronize];
                                         
                                         [[[[self.ref child:@"users"] child:user.uid] child:@"username"] setValue:userData];
                                     }
                                     
                                     TSTabBarController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TSTabBarController"];
                                     [self presentViewController:controller animated:YES completion:nil];
                                     
                                 } else {
                                     NSLog(@"Error - %@", error.localizedDescription);
                                     
                                     [self alertController];
                                 }
                             }];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}


- (void)alertController
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"This e-mail address is already registered in the database. Or this e-mail address does not exist..."
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actionYes = [UIAlertAction actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          
                                                      }];
    
    [alertController addAction:actionYes];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)keyboardDidShow:(NSNotification *)notification
{
    [self.view setFrame:CGRectMake(0, -110, self.view.bounds.size.width, 460)];
}


- (void)keyboardDidHide:(NSNotification *)notification
{
    [self.view setFrame:CGRectMake(0, 0, self.view.bounds.size.width, 460)];
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
