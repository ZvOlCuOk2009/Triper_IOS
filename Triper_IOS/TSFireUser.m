//
//  TSFireUser.m
//  Triper_IOS
//
//  Created by Mac on 17.08.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSFireUser.h"

@implementation TSFireUser


- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.displayName = [dictionary valueForKey:@"displayName"];
        self.uid = [dictionary valueForKey:@"userID"];
        self.email = [dictionary valueForKey:@"email"];
        self.photoURL = [dictionary valueForKey:@"photoURL"];
    }
    return self;
}


+ (TSFireUser *)initWithSnapshot:(FIRDataSnapshot *)snapshot
{
    
    TSFireUser *user = [[TSFireUser alloc] init];
    
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"token"])
    {
//        NSString *currentID = [FIRAuth auth].currentUser.uid;
//        
//        NSString *key = [NSString stringWithFormat:@"users/%@/username", currentID];
//        
//        FIRDataSnapshot *fireUser = [snapshot childSnapshotForPath:key];
//        
//        FIRDataSnapshot *userIdent = fireUser.value[@"userID"];
//        FIRDataSnapshot *userName = fireUser.value[@"displayName"];
//        FIRDataSnapshot *userEmail = fireUser.value[@"email"];
//        FIRDataSnapshot *userPhoto = fireUser.value[@"photoURL"];
//        
//        user.uid = (NSString *)userIdent;
//        user.displayName = (NSString *)userName;
//        user.email = (NSString *)userEmail;
//        user.photoURL = (NSString *)userPhoto;
    }

    return user;
}


@end

