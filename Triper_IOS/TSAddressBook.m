//
//  TSAddressBook.m
//  Triper_IOS
//
//  Created by Mac on 10.08.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSAddressBook.h"
#import "TSContact.h"

#import <Contacts/Contacts.h>

@interface TSAddressBook ()

@property (strong, nonatomic) NSMutableArray *contacts;

@end

@implementation TSAddressBook


+ (TSAddressBook *)sharedManager
{
    static TSAddressBook *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TSAddressBook alloc] init];
    });
    return manager;
}



- (NSArray *)contactsFromAddressBook
{
   self.contacts = [NSMutableArray array];
   
   CNContactStore *store = [[CNContactStore alloc] init];
   [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
      
      if (granted == YES) {
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
      } else {
         NSLog(@"access error %@", [error localizedDescription]);
      }
   }];
   return self.contacts;
}

@end
