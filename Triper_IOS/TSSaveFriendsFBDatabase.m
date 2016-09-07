//
//  TSSaveFriendsFBDatabase.m
//  Triper_IOS
//
//  Created by Mac on 26.08.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSSaveFriendsFBDatabase.h"
#import "TSServerManager.h"
#import "TSParsingManager.h"

@interface TSSaveFriendsFBDatabase ()

@end

@implementation TSSaveFriendsFBDatabase


+ (void)saveFriendsDatabase:(FIRUser *)user
{
    
    FIRDatabaseReference *ref = [[FIRDatabase database] reference];
    
    __block NSDictionary *friendsData = nil;
    __block NSArray *myFriends = nil;
    __block NSMutableArray *ID = nil;
    __block NSMutableArray *photoURLs = nil;
    
    [ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        ID = [NSMutableArray array];
        photoURLs = [NSMutableArray array];
        NSString *key = [NSString stringWithFormat:@"users"];
        
        FIRDataSnapshot *fireUser = [snapshot childSnapshotForPath:key];
        
        friendsData = fireUser.value;
        NSArray *keys = [friendsData allKeys];
        
        NSMutableDictionary *userFriends = [NSMutableDictionary dictionary];
        
        //убрать минус 1 !!!
        
        for (int i = 0; i < myFriends.count - 1; i++) {
            NSDictionary *pairFriend = [myFriends objectAtIndex:i];
            NSArray *dataName = [pairFriend objectForKey:@"items"];
            NSString *name = [dataName objectAtIndex:0];
            
            for (NSString *key in keys) {
                
                NSDictionary *intermediaryPair = [friendsData objectForKey:key];
                NSString *nameOfTheDatabase = [[intermediaryPair objectForKey:@"username"] objectForKey:@"displayName"];
                NSString *photoURL = [[intermediaryPair objectForKey:@"username"] objectForKey:@"photoURL"];
                
                if ([name isEqualToString:nameOfTheDatabase]) {
                    [ID addObject:key];
                    [photoURLs addObject:photoURL];
                }
            }
            NSDictionary *pair = [myFriends objectAtIndex:i];
            [pair setValue:[ID objectAtIndex:i] forKey:@"fireUserID"];
            [pair setValue:[photoURLs objectAtIndex:i] forKey:@"photoURL"];
            NSString *key = [NSString stringWithFormat:@"key%d", i];
            [userFriends setValue:pair forKey:key];
        }
        
        [[[[ref child:@"users"] child:user.uid] child:@"friends"] setValue:userFriends];
    }];
    
    
    [[TSServerManager sharedManager] requestUserFriendsTheServerFacebook:^(NSArray *friends)
     {
         myFriends = [TSParsingManager parsingFriendsFacebook:friends];
     }];
    
}



@end
