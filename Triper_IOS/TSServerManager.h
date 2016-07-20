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
- (void)requestUserFriendsTheServerFacebook:(void(^)(TSUser *user)) success;
- (FBSDKProfilePictureView *)requestUserImageFromTheServerFacebook:(UIImageView *)currentImageView;
- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didCompleteWithResults:(NSDictionary *)results;
- (void)logOutFacebook;
- (void)authorizationOfNewUser:(NSString *)userID
                     userLogin:(NSString *)userLogin
                     onSuccess:(void(^)(NSArray *token)) success;


@end
