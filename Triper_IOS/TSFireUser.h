//
//  TSFireUser.h
//  Triper_IOS
//
//  Created by Mac on 17.08.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import <Foundation/Foundation.h>

@import Firebase;
@import FirebaseDatabase;

@interface TSFireUser : NSObject

@property (strong, nonatomic) NSString *displayName;
@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *photoURL;
@property (strong, nonatomic) NSString *displayName;
@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *photoURL;
@property (strong, nonatomic) NSString *displayName;
@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *photoURL;
@property (strong, nonatomic) NSDictionary *friends;

+ (TSFireUser *)initWithSnapshot:(FIRDataSnapshot *)snapshot;

@end



