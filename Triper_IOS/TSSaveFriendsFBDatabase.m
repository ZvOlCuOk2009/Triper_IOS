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

@property (strong, nonatomic) FIRDatabaseReference *ref;

@end

@implementation TSSaveFriendsFBDatabase


+ (void)saveFriendsDatabase:(FIRUser *)user
{
    FIRDatabaseReference *ref = [[FIRDatabase database] reference];
    
    [[TSServerManager sharedManager] requestUserFriendsTheServerFacebook:^(NSArray *friends)
     {
         NSArray *myFriends = [TSParsingManager parsingFriendsFacebook:friends];
         NSMutableDictionary *userFriends = [NSMutableDictionary dictionary];
         
         for (int i = 0; i < [myFriends count]; i++) {
             NSDictionary *pair = [myFriends objectAtIndex:i];
             NSString *key = [NSString stringWithFormat:@"key%d", i];
             [userFriends setValue:pair forKey:key];
         }
         
         [[[[ref child:@"users"] child:user.uid] child:@"friends"] setValue:userFriends];
         
     }];
}

@end
