//
//  TSServerManager.m
//  Triper_IOS
//
//  Created by Mac on 23.06.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSServerManager.h"
#import "AFNetworking.h"
#import "TSUserViewController.h"

#import <GoogleSignIn/GoogleSignIn.h>

@import Firebase;
@import FirebaseAuth;

@interface TSServerManager ()

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;

@end

@implementation TSServerManager


#pragma mark - Singleton


+ (TSServerManager *)sharedManager
{
    static TSServerManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TSServerManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sessionManager = [[AFHTTPSessionManager alloc] init];
    }
    return self;
}


#pragma mark - FBSDKAccessToken


- (void)requestUserDataFromTheServerFacebook:(void(^)(TSUser *user)) success
{
    NSLog(@"Token is available = %@", [[FBSDKAccessToken currentAccessToken]tokenString]);
    
    NSDictionary * parameters = @{@"fields": @"id, name, link, first_name, last_name, picture.type(large), email, birthday, bio, location, friends, hometown, friendlists"};

    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me"
                                       parameters:parameters]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (!error)
         {
             TSUser *user = [[TSUser alloc] initWithDictionary:result];
             if (success) {
                 success(user);
             }
             NSLog(@"resultis:%@", result);
         } else {
             NSLog(@"Error %@", error);
         }
     }];
}


#pragma mark - FBSDKProfilePictureView


- (FBSDKProfilePictureView *)requestUserImageFromTheServerFacebook:(UIImageView *)currentImageView ID:(NSString *)ID
{
    
    FBSDKProfilePictureView *profilePictureview = [[FBSDKProfilePictureView alloc]initWithFrame:currentImageView.frame];
    [profilePictureview setProfileID:ID];
    return profilePictureview;
}


#pragma mark - FBSDKGraphRequest


- (void)requestUserFriendsTheServerFacebook:(void(^)(NSArray *friends))success
{
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me/friends"
                                       parameters:nil]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
     {
         if (!error) {
             NSArray * friendList = [result objectForKey:@"data"];
             if (success) {
                 success(friendList);
             }
         } else {
             NSLog(@"Error %@", [error localizedDescription]);
         }
     }];
}


#pragma mark - FBSDKAppInviteDialogDelegate



- (void)inviteUserFriendsTheServerFacebook:(UIViewController *)controller
{
    FBSDKAppInviteContent *content =[[FBSDKAppInviteContent alloc] init];
    content.appLinkURL = [NSURL URLWithString:@"https://fb.me/1745102679089901"];
    [FBSDKAppInviteDialog showFromViewController:controller withContent:content delegate:self];
}


- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didCompleteWithResults:(NSDictionary *)results {
    NSLog(@"results = %@", results);
}


- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didFailWithError:(NSError *)error {
    NSLog(@"error = %@", error);
}


#pragma mark - logOutFacebook


- (void)logOutUser
{
    [[[FBSDKLoginManager alloc] init] logOut];
    [FBSDKAccessToken setCurrentAccessToken:nil];
    [FBSDKProfile setCurrentProfile:nil];
    [[GIDSignIn sharedInstance] signOut];
    NSError *error;
    [[FIRAuth auth] signOut:&error];
    if (!error) {
        NSLog(@"Log out");
    }
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
}


#pragma mark - AFNetworking


- (void)authorizationOfNewUser:(NSString *)userID
                     userLogin:(NSString *)userLogin
                     onSuccess:(void(^)(NSArray *token)) success
{
    NSDictionary *parameters = @{@"response_type":@"https://www.linkedin.com/developer/apps",
                                 @"client_id":@4561613,
                                 @"redirect_uri":@"https://www.linkedin.com/developer/apps/4561613/mobile"};
    
    [self.sessionManager GET:@"https://www.linkedin.com/oauth/v2/authorization"
                   parameters:parameters
                     progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          NSMutableArray *objectArray = [NSMutableArray arrayWithArray:responseObject];
                          if (success) {
                              success(objectArray);
                          }
                      }
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          NSLog(@"Error - %@", error.localizedDescription);
                      }
     ];
}

@end
