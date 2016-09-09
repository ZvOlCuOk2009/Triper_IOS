//
//  TSFireUser.m
//  Triper_IOS
//
//  Created by Mac on 17.08.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSFireUser.h"

@implementation TSFireUser


+ (TSFireUser *)initWithSnapshot:(FIRDataSnapshot *)snapshot
{
    
    TSFireUser *user = [[TSFireUser alloc] init];
    
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"token"])
    {
        NSString *currentID = [FIRAuth auth].currentUser.uid;
        NSString *key = [NSString stringWithFormat:@"users/%@/username", currentID];
        
        FIRDataSnapshot *fireUser = [snapshot childSnapshotForPath:key];
        
        FIRDataSnapshot *userIdent = fireUser.value[@"userID"];
        FIRDataSnapshot *userName = fireUser.value[@"displayName"];
        FIRDataSnapshot *userEmail = fireUser.value[@"email"];
        FIRDataSnapshot *userPhoto = fireUser.value[@"photoURL"];
        FIRDataSnapshot *userProfession = fireUser.value[@"profession"];
        FIRDataSnapshot *userCommingFrom = fireUser.value[@"commingFrom"];
        FIRDataSnapshot *userCoingTo = fireUser.value[@"coingTo"];
        FIRDataSnapshot *userCurrentArrea = fireUser.value[@"city"];
        FIRDataSnapshot *userLaunguage = fireUser.value[@"launguage"];
        FIRDataSnapshot *userAge = fireUser.value[@"age"];
        FIRDataSnapshot *userMission = fireUser.value[@"mission"];
        FIRDataSnapshot *userAbout = fireUser.value[@"about"];
        FIRDataSnapshot *userBackground = fireUser.value[@"background"];
        FIRDataSnapshot *userInterest = fireUser.value[@"interest"];
        
        
        user.uid = (NSString *)userIdent;
        user.displayName = (NSString *)userName;
        user.email = (NSString *)userEmail;
        user.photoURL = (NSString *)userPhoto;
        user.profession = (NSString *)userProfession;
        user.commingFrom = (NSString *)userCommingFrom;
        user.coingTo = (NSString *)userCoingTo;
        user.currentArrea = (NSString *)userCurrentArrea;
        user.launguage = (NSString *)userLaunguage;
        user.age = (NSString *)userAge;
        user.mission = (NSString *)userMission;
        user.about = (NSString *)userAbout;
        user.background = (NSString *)userBackground;
        user.interest = (NSString *)userInterest;
    }

    return user;
}


@end

