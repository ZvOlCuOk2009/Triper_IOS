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
        FIRDataSnapshot *data = userFriends.value[key];
        NSString *name = [(NSDictionary *)data objectForKey:@"items"];
        NSString *ID = [(NSDictionary *)data objectForKey:@"id"];
        NSDictionary *dataFriend = @{@"items":name,
                                     @"id":ID};
        [arrayFriends addObject:dataFriend];
    }

    
//    for (int i = 0; i < count; i++) {
//        NSString *key = [NSString stringWithFormat:@"key%d", i];
//        NSDictionary *data = userFriends.value[key];
//        NSString *transitName = [data objectForKey:@"items"];
//        NSString *dataName = [NSString stringWithFormat:@"%@", transitName];
//        NSScanner* nameScanner = [NSScanner scannerWithString:dataName];
//        NSString *name;
//        while (![nameScanner isAtEnd]) {
//            [nameScanner scanUpToString:@"" intoString:nil];
//            [nameScanner scanUpToString:@"\\" intoString:&name];
//        }
//        NSString *firsName = [NSString stringWithFormat:@"%@", name];
//        NSString *ID = [data objectForKey:@"id"];
//        NSArray *arrayNameFriend = [NSArray arrayWithObjects:name, nil];
//        NSArray *idFriend = [NSArray arrayWithObjects:ID, nil];
//        NSMutableDictionary *friend = [NSMutableDictionary dictionary];
//        [friend setObject:arrayNameFriend forKey:@"items"];
//        [friend setObject:idFriend forKey:@"id"];
//        [arrayFriends addObject:friend];
//    }
    
    return arrayFriends;
}

@end

