//
//  TSTest2ViewController.m
//  Triper_IOS
//
//  Created by Mac on 08.07.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#define IS_IPHONE_4 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)480) < DBL_EPSILON)
#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)568) < DBL_EPSILON)
#define IS_IPHONE_6 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)667) < DBL_EPSILON)
#define IS_IPHONE_6_PLUS (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)736) < DBL_EPSILON)

#import "TSHomyViewController.h"
#import "TSServerManager.h"
#import "TSUser.h"
#import "TSLoginViewController.h"
#import "TSFireUser.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>

@import Firebase;
@import FirebaseDatabase;

@interface TSHomyViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (weak, nonatomic) IBOutlet UIButton *outButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) TSUser *user;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintInviteButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintButtonEdit;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraintButtonEdit;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintButtonOut;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraintButtonOut;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topButtonEdit;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topButtonOut;


@end

@implementation TSHomyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.ref = [[FIRDatabase database] reference];
    
    [self.ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        TSFireUser *fireUser = [TSFireUser initWithSnapshot:snapshot];
        
        NSURL *url = [NSURL URLWithString:fireUser.photoURL];
        
        if (url && url.scheme && url.host) {
            
            if ([self verificationURL:fireUser.photoURL]) {
                FBSDKProfilePictureView *avatar = [[TSServerManager sharedManager] requestUserImageFromTheServerFacebook:self.avatarImageView ID:@"me"];
                avatar.layer.cornerRadius = avatar.frame.size.width / 2;
                avatar.layer.masksToBounds = YES;
                [self.view addSubview:avatar];
                
            } else {
                self.avatarImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:
                                                                     [NSURL URLWithString:fireUser.photoURL]]];
            }
            
        } else {
            
            NSData *data = [[NSData alloc]initWithBase64EncodedString:fireUser.photoURL options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *convertImage = [UIImage imageWithData:data];
            self.avatarImageView.image = convertImage;
        }
    }];
    
    [self layout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.    
}


- (void)layout
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if (IS_IPHONE_4) {
            self.heightConstraintImageView.constant = 180;
            self.heightConstraintInviteButton.constant = 34;
        } else if (IS_IPHONE_5) {
            self.heightConstraintInviteButton.constant = 40;
        } else if (IS_IPHONE_6) {
            self.heightConstraintImageView.constant = 235;
            self.heightConstraintInviteButton.constant = 47;
            self.heightConstraintButtonEdit.constant = 29;
            self.widthConstraintButtonEdit.constant = 29;
            self.heightConstraintButtonOut.constant = 29;
            self.widthConstraintButtonOut.constant = 29;
            self.topButtonEdit.constant = 15;
            self.topButtonOut.constant = 15;
        } else if (IS_IPHONE_6_PLUS) {
            self.heightConstraintImageView.constant = 266;
            self.heightConstraintInviteButton.constant = 50;
            self.heightConstraintButtonEdit.constant = 32;
            self.widthConstraintButtonEdit.constant = 32;
            self.heightConstraintButtonOut.constant = 32;
            self.widthConstraintButtonOut.constant = 32;
            self.topButtonEdit.constant = 20;
            self.topButtonOut.constant = 20;
        }
    }
}


- (BOOL)verificationURL:(NSString *)url
{
    BOOL verification;
    NSArray *component = [url componentsSeparatedByString:@"."];
    NSString *firstComponent = [component firstObject];
    
    if ([firstComponent isEqualToString:@"https://scontent"]) {
        verification = YES;
    } else {
        verification = NO;
    }
    return verification;
}


- (IBAction)actionInviteFriends:(id)sender
{
    [[TSServerManager sharedManager] inviteUserFriendsTheServerFacebook:self];
}


- (IBAction)actionEditing:(id)sender
{
    
}


- (IBAction)actionLogOut:(id)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Do you want to exit the application?"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actionYes = [UIAlertAction actionWithTitle:@"YES"
                                                        style:UIAlertActionStyleDestructive
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          [[TSServerManager sharedManager] logOutUser];
                                                          TSLoginViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TSLoginViewController"];
                                                          [self presentViewController:controller animated:YES completion:nil];
                                                      }];
    
    UIAlertAction *actionNo = [UIAlertAction actionWithTitle:@"NO"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) { }];
    
    [alertController addAction:actionYes];
    [alertController addAction:actionNo];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
