//
//  TSAddressBook.h
//  Triper_IOS
//
//  Created by Mac on 10.08.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSAddressBook : NSObject

+ (TSAddressBook *)sharedManager;
- (NSArray *)contactsFromAddressBook;

@end
