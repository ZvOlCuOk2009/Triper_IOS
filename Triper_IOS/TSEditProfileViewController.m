//
//  TSEditProfileViewController.m
//  Triper_IOS
//
//  Created by Mac on 01.09.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSEditProfileViewController.h"
#import "TSFireUser.h"
#import "TSRetriveFriendsFBDatabase.h"
#import "TSPrefixHeader.pch"

@import Firebase;
@import FirebaseDatabase;

@interface TSEditProfileViewController ()

@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) FIRUser *user;
@property (strong, nonatomic) TSFireUser *fireUser;
@property (strong, nonatomic) NSMutableArray *friends;

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

@property (strong, nonatomic) IBOutletCollection (NSLayoutConstraint) NSArray *xValueCollection;


- (IBAction)actionUpdate:(id)sender;

@end

@implementation TSEditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.ref = [[FIRDatabase database] reference];
    self.user = [FIRAuth auth].currentUser;
    
    
    [self layout];
}

- (IBAction)actionBackPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionUpdate:(id)sender
{
    
    [self saveDataToDataBase];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)saveDataToDataBase
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        [self.ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            
            self.fireUser = [TSFireUser initWithSnapshot:snapshot];
            self.friends = [TSRetriveFriendsFBDatabase retriveFriendsDatabase:snapshot];
            
            NSDictionary *userData = nil;
            
            
            NSString *profession = nil;
            NSString *commingFrom = nil;
            NSString *coingTo = nil;
            NSString *city = nil;
            NSString *launguage = nil;
            NSString *age = nil;
            NSString *mission = nil;
            NSString *about = nil;
            NSString *background = nil;
            NSString *interest = nil;
            
            
            
            if ([self.professionTextField.text isEqualToString:@""]) {
                
                profession = self.fireUser.profession;
                
            } else {
                
                profession = self.professionTextField.text;
            }
            
            
            
            if ([self.commingFromTextField.text isEqualToString:@""]) {
                
                commingFrom = self.fireUser.commingFrom;
                
            } else {
                commingFrom = self.commingFromTextField.text;
            }
            
            
            
            if ([self.coingToTextField.text isEqualToString:@""]) {
                
                coingTo = self.fireUser.coingTo;
                
            } else {
                
                coingTo = self.coingToTextField.text;
            }
            
            
            
            if ([self.currentArreaTextField.text isEqualToString:@""]) {
                
                city = self.fireUser.currentArrea;
                
            } else {
                
                city = self.currentArreaTextField.text;
            }
            
            
            
            if ([self.launguageTextField.text isEqualToString:@""]) {
                
                launguage = self.fireUser.launguage;
                
            } else {
                
                launguage = self.launguageTextField.text;
            }
            
            
            
            if ([self.ageTextField.text isEqualToString:@""]) {
                
                age = self.fireUser.age;
                
            } else {
                
                age = self.ageTextField.text;
            }
            
            
            
            if ([self.missionTextField.text isEqualToString:@""]) {
                
                mission = self.fireUser.mission;
                
            } else {
                
                mission = self.missionTextField.text;
            }
            
            
            
            if ([self.aboutTextField.text isEqualToString:@""]) {
                
                about = self.fireUser.about;
                
            } else {
                
                about = self.aboutTextField.text;
            }
            
            
            
            if ([self.backgroundTextField.text isEqualToString:@""]) {
                
                background = self.fireUser.background;
                
            } else {
                background = self.backgroundTextField.text;
            }
            
            
            
            if ([self.interestTextField.text isEqualToString:@""]) {
                
                interest = self.fireUser.interest;
                
            } else {
                
                interest = self.interestTextField.text;
            }
            
            
            userData = @{@"displayName":self.fireUser.displayName,
                         @"email":self.fireUser.email,
                         @"photoURL":self.fireUser.photoURL,
                         @"userID":self.fireUser.uid,
                         @"profession":profession,
                         @"commingFrom":commingFrom,
                         @"coingTo":coingTo,
                         @"city":city,
                         @"launguage":launguage,
                         @"age":age,
                         @"mission":mission,
                         @"about":about,
                         @"background":background,
                         @"interest":interest};
            
            
            [[[[self.ref child:@"users"] child:self.user.uid] child:@"username"] setValue:userData];
            
            
            for (int i = 0; i < self.friends.count; i++) {
                
                NSString *key = [NSString stringWithFormat:@"key%d", i];
                NSDictionary *pair = [self.friends objectAtIndex:i];
                NSString *IDFromYourFriendsList = [pair objectForKey:@"fireUserID"];
                [[[[[self.ref child:@"users"] child:IDFromYourFriendsList] child:@"friends"] child:key] setValue:userData];
            }
        }];
        
    });
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}


- (void)layout
{
        
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if (IS_IPHONE_4) {
            
        } else if (IS_IPHONE_5) {
            
        } else if (IS_IPHONE_6) {
                        
        } else if (IS_IPHONE_6_PLUS) {
            
        }
    }
}


- (void)keyboardDidShow:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3 animations:^{
        [self.view setFrame:CGRectMake(0, 0, self.view.bounds.size.width, 330)];
    }];
    
}


- (void)keyboardDidHide:(NSNotification *)notification
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if (IS_IPHONE_4) {
            
        } else if (IS_IPHONE_5) {
            
            [UIView animateWithDuration:0.3 animations:^{
                [self.view setFrame:CGRectMake(0, 0, self.view.bounds.size.width, 568)];
            }];
            
        } else if (IS_IPHONE_6) {
            
            [UIView animateWithDuration:0.3 animations:^{
                [self.view setFrame:CGRectMake(0, 0, self.view.bounds.size.width, 736)];
            }];
            
        } else if (IS_IPHONE_6_PLUS) {
            
        }
    }
    
    
    
}

@end
