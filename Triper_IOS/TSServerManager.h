//
//  TSServerManager.h
//  Triper_IOS
//
//  Created by Mac on 23.06.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "TSUser.h"

@interface TSServerManager : NSObject <FBSDKAppInviteDialogDelegate>

+ (TSServerManager *)sharedManager;
- (void)requestUserDataFromTheServerFacebook:(void(^)(TSUser *user))success;
- (void)inviteUserFriendsTheServerFacebook:(UIViewController *)controller;
- (void)requestUserFriendsTheServerFacebook:(void(^)(NSArray *friends)) success;
- (FBSDKProfilePictureView *)requestUserImageFromTheServerFacebook:(UIImageView *)currentImageView ID:(NSString *)ID;
- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didCompleteWithResults:(NSDictionary *)results;
- (void)authorizationOfNewUser:(NSString *)userID userLogin:(NSString *)userLogin onSuccess:(void(^)(NSArray *token)) success;
- (void)logOutFacebook;


- (void)requestUserServerFacebook:(void(^)(NSDictionary *friends))success;

@end
