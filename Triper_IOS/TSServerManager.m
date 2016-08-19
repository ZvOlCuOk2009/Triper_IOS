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

@class FBGraphLocation;
@class FBGraphPlace;
@class FBGraphUser;

@interface TSServerManager ()

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;

@property (strong, nonatomic) NSString * after;

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
//    NSLog(@"Token is available = %@", [[FBSDKAccessToken currentAccessToken]tokenString]);
    
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

//test block

- (void)requestUserServerFacebook:(void(^)(NSDictionary *friends))success
{
    NSDictionary * parameters = @{@"fields": @"id, name, link, first_name, last_name, picture.type(large), email, birthday, bio, location, friends, hometown, friendlists"};
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"me"
                                  parameters:parameters
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        if (!error) {
            NSDictionary * friendList = [[result objectForKey:@"friends"] objectForKey:@"paging"];
            self.after = [[friendList objectForKey:@"cursors"] objectForKey:@"after"];
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


- (void)logOutFacebook
{
    [[[FBSDKLoginManager alloc] init] logOut];
    [FBSDKAccessToken setCurrentAccessToken:nil];
    [FBSDKProfile setCurrentProfile:nil];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
}


#pragma mark - AFNetworking


- (void)authorizationOfNewUser:(NSString *)userID
                     userLogin:(NSString *)userLogin
                     onSuccess:(void(^)(NSArray *token)) success
{
    NSDictionary *parameters = @{@"id":userID,
                                 @"name":userLogin};
    
    [self.sessionManager POST:@"http://www.golinkder.com/process.php/MyApi/login&id=519465bf-da1f-e682-70a7-052722f7da5a&name=Sasha-Tsvigun&"
                   parameters:parameters
                     progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          NSMutableArray *objectArray = [NSMutableArray array];
                          if (success) {
                              success(objectArray);
                          }
                      }
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          
                      }
     ];
}

@end
