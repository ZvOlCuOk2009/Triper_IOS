//
//  TSRetriveFriendsFBDatabase.h
//  Triper_IOS
//
//  Created by Mac on 26.08.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import <Foundation/Foundation.h>

@import Firebase;
@import FirebaseDatabase;

@interface TSRetriveFriendsFBDatabase : NSObject

+ (NSMutableArray *)retriveFriendsDatabase:(FIRDataSnapshot *)snapshot;

@end
