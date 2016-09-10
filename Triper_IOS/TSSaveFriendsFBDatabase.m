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


+ (void)saveFriendsDatabase:(FIRUser *)user userFriend:(NSArray *)friends
{
    
    NSArray *myFriends = friends;
    
    FIRDatabaseReference *ref = [[FIRDatabase database] reference];
    
    __block NSDictionary *friendsData = nil;
    __block NSMutableArray *IDs = nil;
    __block NSMutableArray *photoURLs = nil;
    
    [ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        IDs = [NSMutableArray array];
        photoURLs = [NSMutableArray array];
        NSString *key = [NSString stringWithFormat:@"users"];
        
        FIRDataSnapshot *fireUser = [snapshot childSnapshotForPath:key];
        
        friendsData = fireUser.value;
        NSArray *keys = [friendsData allKeys];
        
        NSMutableDictionary *userFriends = [NSMutableDictionary dictionary];
        
        
        for (int i = 0; i < myFriends.count; i++) {
            NSDictionary *pairFriend = [myFriends objectAtIndex:i];
            NSArray *dataName = [pairFriend objectForKey:@"items"];
            NSString *name = [dataName objectAtIndex:0];
            
            for (NSString *key in keys) {
                
                NSDictionary *intermediaryPair = [friendsData objectForKey:key];
                NSString *nameOfTheDatabase = [[intermediaryPair objectForKey:@"username"] objectForKey:@"displayName"];
                NSString *photoURL = [[intermediaryPair objectForKey:@"username"] objectForKey:@"photoURL"];
                
                if ([name isEqualToString:nameOfTheDatabase]) {
                    [IDs addObject:key];
                    [photoURLs addObject:photoURL];
                }
            }
            NSDictionary *pair = [myFriends objectAtIndex:i];
            NSArray *itemsArray = [pair objectForKey:@"items"];
            NSArray *idFBArray = [pair objectForKey:@"id"];
            
            NSString *items = [itemsArray objectAtIndex:0];
            NSString *idFB = [idFBArray objectAtIndex:0];
            
            NSString *idFireUser = nil;
            NSString *photoURL = nil;
            
            if (IDs.count > 0) {
                
                idFireUser = [IDs objectAtIndex:i];
                
            } else {
                
                idFireUser = @"";
            }
            
            
            if (photoURLs.count > 0) {
                
                photoURL = [photoURLs objectAtIndex:i];
                
            } else {
                
                photoURL = @"";
            }
            
            
            NSDictionary *newPairs = @{@"fireUserID":idFireUser,
                                       @"photoURL":photoURL,
                                       @"items":items,
                                       @"id":idFB};
            
            NSString *key = [NSString stringWithFormat:@"key%d", i];
            [userFriends setValue:newPairs forKey:key];
            
        }
        
        [[[[ref child:@"users"] child:user.uid] child:@"friends"] setValue:userFriends];
    }];
    
}



@end
