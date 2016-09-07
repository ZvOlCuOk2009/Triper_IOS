//
//  TSRetriveFriendsFBDatabase.m
//  Triper_IOS
//
//  Created by Mac on 26.08.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSRetriveFriendsFBDatabase.h"

@implementation TSRetriveFriendsFBDatabase

+ (NSMutableArray *)retriveFriendsDatabase:(FIRDataSnapshot *)snapshot
{
    
    FIRUser *user = [FIRAuth auth].currentUser;
    NSString *key = [NSString stringWithFormat:@"users/%@/friends", user.uid];
    FIRDataSnapshot *userFriends = [snapshot childSnapshotForPath:key];
    NSMutableArray *arrayFriends = [NSMutableArray array];
    NSUInteger count = userFriends.childrenCount;
    
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithFormat:@"key%d", i];
        NSDictionary *data = userFriends.value[key];
        NSString *name = [data objectForKey:@"items"];
        NSString *photoURL = [data objectForKey:@"photoURL"];
        NSString *fireUserID = [data objectForKey:@"fireUserID"];
        
        NSDictionary *pair = @{@"items":name,
                               @"photoURL":photoURL,
                               @"fireUserID":fireUserID};
        [arrayFriends addObject:pair];
        
    }
    
    return arrayFriends;
}

@end

