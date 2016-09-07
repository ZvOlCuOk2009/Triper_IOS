//
//  TSUserViewController.m
//  Triper_IOS
//
//  Created by Mac on 23.07.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSUserViewController.h"
#import "TSServerManager.h"
#import "TSUser.h"
//#import "TSLoginViewController.h"
#import "TSProfileView.h"
#import "TSContact.h"
#import "TSFireUser.h"
#import "TSParsingManager.h"

#import <AddressBook/AddressBook.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@import Firebase;
@import FirebaseDatabase;

@interface TSUserViewController ()
 
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) TSFireUser *fireUser;

@end

@implementation TSUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    self.ref = [[FIRDatabase database] reference];
    
    
    [self.ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        self.fireUser = [TSFireUser initWithSnapshot:snapshot];
        
    }];
    
    [self reloadView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self reloadView];
    });
    
//    dispatch_async(dispatch_get_main_queue(), ^
//    {
//        
//    });
        
}


- (void)reloadView
{
    [self.ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        self.fireUser = [TSFireUser initWithSnapshot:snapshot];
        
        TSProfileView *profileView = [TSProfileView profileView];
        
        NSURL *url = [NSURL URLWithString:self.fireUser.photoURL];
        
        profileView.nameLabel.text = self.fireUser.displayName;
        profileView.miniNameLabel.text = self.fireUser.displayName;
        
        if (url && url.scheme && url.host) {
            
            profileView.avatarImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:
                                                                        [NSURL URLWithString:self.fireUser.photoURL]]];
        } else {
            
            NSData *data = [[NSData alloc]initWithBase64EncodedString:self.fireUser.photoURL options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *convertImage = [UIImage imageWithData:data];
            profileView.avatarImageView.image = convertImage;
        }
        
        [self.view addSubview:profileView];
    }];
}


- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
}


- (void)phoneNumber
{
    self.navigationController.navigationBarHidden = true;
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    
    if (status == kABAuthorizationStatusDenied || status == kABAuthorizationStatusRestricted) {
        
        [[[UIAlertView alloc] initWithTitle:nil message:@"This app requires access to your contacts to function properly. Please visit to the \"Privacy\" section in the iPhone Settings app." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    
    if (!addressBook) {
        NSLog(@"ABAddressBookCreateWithOptions error: %@", CFBridgingRelease(error));
        return;
    }
    
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        if (error) {
            NSLog(@"ABAddressBookRequestAccessWithCompletion error: %@", CFBridgingRelease(error));
        }
        
        if (granted) {

            [self listPeopleInAddressBook:addressBook];
        } else {

            dispatch_async(dispatch_get_main_queue(), ^{

                [[[UIAlertView alloc] initWithTitle:nil message:@"This app requires access to your contacts to function properly. Please visit to the \"Privacy\" section in the iPhone Settings app." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            });
        }
        CFRelease(addressBook);
    });
}


- (NSArray *)listPeopleInAddressBook:(ABAddressBookRef)addressBook
{

    NSArray *allPeople = CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(addressBook));
    
    NSMutableArray *contacts = [NSMutableArray array];
    NSInteger numberOfPeople = [allPeople count];
    
    for (NSInteger i = 0; i < numberOfPeople; i++) {
        ABRecordRef person = (__bridge ABRecordRef)allPeople[i];

        NSString *firstName = CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty));
        NSString *lastName  = CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty));
//        NSLog(@"Name:%@ %@", firstName, lastName);
        
        ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
        NSString *phoneNumber = CFBridgingRelease(ABMultiValueCopyValueAtIndex(phoneNumbers, 0));
//        NSLog(@"phone:%@", phoneNumber);
//        NSLog(@"=============================================");
       
        [contacts addObject:[NSString stringWithFormat:@"%@ %@ %@", firstName, lastName, phoneNumber]];
    }
    return contacts;
}


- (NSString *)retriveNumberPhoneContacts:(NSString *)contact
{
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    
    NSArray *contacts = [self listPeopleInAddressBook:addressBook];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", contact];
    NSArray *searchArray = [contacts filteredArrayUsingPredicate:predicate];
    NSString *serchContact = nil;
    
    if ([searchArray count] > 0) {
        serchContact = [searchArray objectAtIndex:0];
    } else {
        serchContact = nil;
    }
    
    return serchContact;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
