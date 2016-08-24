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
#import "TSLoginViewController.h"
#import "TSProfileView.h"
#import "TSContact.h"
#import "TSFireUser.h"

//#import <Contacts/Contacts.h>
#import <AddressBook/AddressBook.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@import Firebase;
@import FirebaseDatabase;

@interface TSUserViewController ()
 
@property (strong, nonatomic) TSUser *user;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) TSFireUser *fireUser;

@end

@implementation TSUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.ref = [[FIRDatabase database] reference];
    
    [self reloadView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self reloadView];
    });
    
//    [self phoneNumber];
}


- (void)reloadView
{
    [self.ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        TSFireUser *fireUser = [TSFireUser initWithSnapshot:snapshot];
        
        TSProfileView *profileView = [TSProfileView profileView];
        
        NSString *cutUrlString = [fireUser.photoURL substringFromIndex:8];
        
        profileView.nameLabel.text = fireUser.displayName;
        profileView.miniNameLabel.text = fireUser.displayName;
        
        if ([cutUrlString isEqualToString:@"https://"]) {
            
            profileView.avatarImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:
                                                                        [NSURL URLWithString:fireUser.photoURL]]];
        } else {
            
            NSData *data = [[NSData alloc]initWithBase64EncodedString:fireUser.photoURL options:NSDataBase64DecodingIgnoreUnknownCharacters];
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
        // if you got here, user had previously denied/revoked permission for your
        // app to access the contacts, and all you can do is handle this gracefully,
        // perhaps telling the user that they have to go to settings to grant access
        // to contacts
        
//        [[[UIAlertView alloc] initWithTitle:nil message:@"This app requires access to your contacts to function properly. Please visit to the \"Privacy\" section in the iPhone Settings app." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
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
            // if they gave you permission, then just carry on
            [self listPeopleInAddressBook:addressBook];
        } else {
            // however, if they didn't give you permission, handle it gracefully, for example...
            dispatch_async(dispatch_get_main_queue(), ^{
                // BTW, this is not on the main thread, so dispatch UI updates back to the main queue
                [[[UIAlertView alloc] initWithTitle:nil message:@"This app requires access to your contacts to function properly. Please visit to the \"Privacy\" section in the iPhone Settings app." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            });
        }
        CFRelease(addressBook);
    });
    // Do any additional setup after loading the view.
}

- (void)listPeopleInAddressBook:(ABAddressBookRef)addressBook
{
    //Run UI Updates
    NSArray *allPeople = CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(addressBook));
    NSInteger numberOfPeople = [allPeople count];
    
    for (NSInteger i = 0; i < numberOfPeople; i++) {
        ABRecordRef person = (__bridge ABRecordRef)allPeople[i];
        //From Below code you can get what you want.
        NSString *firstName = CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty));
        NSString *lastName  = CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty));
        NSLog(@"Name:%@ %@", firstName, lastName);
        
        ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
        NSString *phoneNumber = CFBridgingRelease(ABMultiValueCopyValueAtIndex(phoneNumbers, 0));
        NSLog(@"phone:%@", phoneNumber);
        NSLog(@"=============================================");
    }
    
}










//
//- (NSArray *)contactsFromAddressBook
//{
//    self.contacts = [NSMutableArray array];
//    
//    CNContactStore *store = [[CNContactStore alloc] init];
//    
//    if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusNotDetermined) {
//        
//        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
//            
//            if (granted == YES) {
//                [self retrieveContacts:store];
//            } else {
//                NSLog(@"access error %@", [error localizedDescription]);
//            }
//        }];
//    } else if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusAuthorized) {
//        [self retrieveContacts:store];
//    }
//    return self.contacts;
//}
//
//- (void)retrieveContacts:(CNContactStore *)store {
//    NSArray *keys = @[CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey];
//    NSString *containerId = store.defaultContainerIdentifier;
//    NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:containerId];
//    NSError *error;
//    NSArray *cnContacts = [store unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&error];
//    
//    if (!error) {
//        for (CNContact *contact in cnContacts) {
//            
//            TSContact *newContact = [[TSContact alloc] init];
//            newContact.firstName = contact.givenName;
//            newContact.lastName = contact.familyName;
//            
//            for (CNLabeledValue *label in contact.phoneNumbers) {
//                
//                NSString *phone = [label.value stringValue];
//                
//                if ([phone length] > 0) {
//                    newContact.phone = phone;
//                }
//            }
//            [self.contacts addObject:newContact];
//        }
//    } else {
//        NSLog(@"error fetching contacts %@", [error localizedDescription]);
//    }
//    
//}

///******************************************


//-(void)addressbookAuthorizationUsingContacts
//{
//    CNContactStore *store = [[CNContactStore alloc] init];
//    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
//        if (granted == YES) {
//
//            NSMutableArray *contacts = [NSMutableArray array];
//            
//            NSArray *keys = @[CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey];
//            NSString *containerId = store.defaultContainerIdentifier;
//            NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:containerId];
//            NSError *error;
//            NSArray *cnContacts = [store unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&error];
//            if (error) {
//                NSLog(@"error fetching contacts %@", error);
//            } else {
//                for (CNContact *contact in cnContacts) {
//
//                    TSContact *newContact = [[TSContact alloc] init];
//                    newContact.firstName = contact.givenName;
//                    newContact.lastName = contact.familyName;
//                    UIImage *image = [UIImage imageWithData:contact.imageData];
//                    newContact.image = image;
//                    for (CNLabeledValue *label in contact.phoneNumbers) {
//                        NSString *phone = [label.value stringValue];
//                        if ([phone length] > 0) {
//                            [contacts addObject:phone];
//                        }
//                    }
//                }
//            }
//        } else {
//            NSLog(@"Error = %@", error.localizedDescription);
//        }
//    }];
//}


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
