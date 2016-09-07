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
    
    CGSize newSize = CGSizeMake(300, 300);
    
    UIGraphicsBeginImageContext(newSize);
    [self.image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    NSData *dataImage = UIImagePNGRepresentation(newImage);
    NSString *stringImage = [dataImage base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    
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
                                         
                                         //save friends
                                         /*
                                         
                                         NSDictionary *pair = [myFriends objectAtIndex:i];
                                         NSArray *itemsArray = [pair objectForKey:@"items"];
                                         NSArray *idFBArray = [pair objectForKey:@"id"];
                                         
                                         NSString *items = [itemsArray objectAtIndex:0];
                                         NSString *idFB = [idFBArray objectAtIndex:0];
                                         NSString *idFireUser = [IDs objectAtIndex:i];
                                         NSString *photoURL = [photoURLs objectAtIndex:i];
                                         
                                         NSDictionary *newPairs = @{@"fireUserID":idFireUser,
                                                                    @"photoURL":photoURL,
                                                                    @"items":items,
                                                                    @"id":idFB};
                                         
                                         NSString *key = [NSString stringWithFormat:@"key%d", i];
                                         [userFriends setValue:newPairs forKey:key];
                                          
                                          [[[[ref child:@"users"] child:user.uid] child:@"friends"] setValue:userFriends];
                                          */
                                         
                                     }
                                     
                                     TSTabBarController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TSTabBarController"];
                                     [self presentViewController:controller animated:YES completion:nil];
                                     
                                 } else {
                                     NSLog(@"Error - %@", error.localizedDescription);
                                     
                                     [self alertController];
                                 }
                             }];
    
}


- (IBAction)actionBackPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}


- (void)alertController
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"This e-mail address has already been registered in the database, or it does not exist..."
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          
                                                      }];
    
    [alertController addAction:action];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)keyboardDidShow:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3 animations:^{
        [self.view setFrame:CGRectMake(0, -110, self.view.bounds.size.width, 460)];
    }];
   
}


- (void)keyboardDidHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3 animations:^{
        [self.view setFrame:CGRectMake(0, 0, self.view.bounds.size.width, 460)];
    }];
    
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
