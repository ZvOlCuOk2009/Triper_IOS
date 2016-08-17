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

#import <Contacts/Contacts.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface TSUserViewController ()
 
@property (strong, nonatomic) TSUser *user;
@property (strong, nonatomic) NSMutableArray *contacts;

@end

@implementation TSUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSArray *contacts = [self contactsFromAddressBook];
    for (TSContact *contact in contacts) {
        NSLog(@"phomne number is %@ %@", contact.phone, [NSString stringWithFormat:@"%@ %@", contact.firstName, contact.lastName]);
    }
    
    
    [[TSServerManager sharedManager] requestUserDataFromTheServerFacebook:^(TSUser *user) {
        TSProfileView *profileView = [TSProfileView profileView];
        profileView.nameLabel.text = user.name;
        profileView.miniNameLabel.text = user.name;
        profileView.avatarImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:user.avatar]];
        [self.view addSubview:profileView];
    }];
}


- (NSArray *)contactsFromAddressBook
{
    self.contacts = [NSMutableArray array];
    
    CNContactStore *store = [[CNContactStore alloc] init];
    
    if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusNotDetermined) {
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            
            if (granted == YES) {
                [self retrieveContacts:store];
            } else {
                NSLog(@"access error %@", [error localizedDescription]);
            }
        }];
    } else if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusAuthorized) {
        [self retrieveContacts:store];
    }
    return self.contacts;
}

- (void)retrieveContacts:(CNContactStore *)store {
    NSArray *keys = @[CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey];
    NSString *containerId = store.defaultContainerIdentifier;
    NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:containerId];
    NSError *error;
    NSArray *cnContacts = [store unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&error];
    
    if (!error) {
        for (CNContact *contact in cnContacts) {
            
            TSContact *newContact = [[TSContact alloc] init];
            newContact.firstName = contact.givenName;
            newContact.lastName = contact.familyName;
            
            for (CNLabeledValue *label in contact.phoneNumbers) {
                
                NSString *phone = [label.value stringValue];
                
                if ([phone length] > 0) {
                    newContact.phone = phone;
                }
            }
            [self.contacts addObject:newContact];
        }
    } else {
        NSLog(@"error fetching contacts %@", [error localizedDescription]);
    }
    
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
