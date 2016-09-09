//
//  TSSaveFriendsFBDatabase.h
//  Triper_IOS
//
//  Created by Mac on 26.08.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import <Foundation/Foundation.h>

@import Firebase;
@import FirebaseDatabase;

@interface TSSaveFriendsFBDatabase : NSObject

+ (void)saveFriendsDatabase:(FIRUser *)user userFriend:(NSArray *)friends;

@end
