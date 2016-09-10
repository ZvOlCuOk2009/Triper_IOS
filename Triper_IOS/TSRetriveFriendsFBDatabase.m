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
        NSString *profession = [data objectForKey:@"profession"];
        NSString *commingFrom = [data objectForKey:@"commingFrom"];
        NSString *coingTo = [data objectForKey:@"coingTo"];
        NSString *city = [data objectForKey:@"city"];
        NSString *launguage = [data objectForKey:@"launguage"];
        NSString *age = [data objectForKey:@"age"];
        NSString *mission = [data objectForKey:@"mission"];
        NSString *about = [data objectForKey:@"about"];
        NSString *background = [data objectForKey:@"background"];
        NSString *interest = [data objectForKey:@"interest"];
        
        
        if (name == nil) {
            name = @"";
        }
        
        
        if (photoURL == nil) {
            photoURL = @"";
        }
        
        
        if (fireUserID == nil) {
            fireUserID = @"";
        }
        
        
        if (profession == nil) {
            profession = @"";
        }
        
        
        if (commingFrom == nil) {
            commingFrom = @"";
        }
        
        
        if (coingTo == nil) {
            coingTo = @"";
        }
        
        
        if (city == nil) {
            city = @"";
        }
        
        
        if (launguage == nil) {
            launguage = @"";
        }
        
        
        if (age == nil) {
            age = @"";
        }
        
        
        if (mission == nil) {
            mission = @"";
        }
        
        
        if (about == nil) {
            about = @"";
        }
        
        
        if (background == nil) {
            background = @"";
        }
        
        
        if (interest == nil) {
            interest = @"";
        }
        
        NSDictionary *pair = @{@"items":name,
                               @"photoURL":photoURL,
                               @"fireUserID":fireUserID,
                               @"profession":profession,
                               @"commingFrom":commingFrom,
                               @"coingTo":coingTo,
                               @"city":city,
                               @"launguage":launguage,
                               @"age":age,
                               @"mission":mission,
                               @"about":about,
                               @"background":background,
                               @"interest":interest};
        
        [arrayFriends addObject:pair];
        
    }
    
    
    return arrayFriends;
}

@end

