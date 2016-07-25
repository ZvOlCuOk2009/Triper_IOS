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

@interface TSServerManager ()

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;

@end

@implementation TSServerManager

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

- (FBSDKProfilePictureView *)requestUserImageFromTheServerFacebook:(UIImageView *)currentImageView
{
    NSLog(@"Token is available = %@", [[FBSDKAccessToken currentAccessToken]tokenString]);
    
    FBSDKProfilePictureView *profilePictureview = [[FBSDKProfilePictureView alloc]initWithFrame:currentImageView.frame];
    [profilePictureview setProfileID:@"me"];
    return profilePictureview;
}

- (void)requestUserFriendsTheServerFacebook:(void(^)(TSUser *user)) success controller:(UIViewController *)controller
{
    FBSDKAppInviteContent *content =[[FBSDKAppInviteContent alloc] init];
    content.appLinkURL = [NSURL URLWithString:@"https://fb.me/1745102679089901"];

    content.appInvitePreviewImageURL = [NSURL URLWithString:@"https://3.bp.blogspot.com/-W__wiaHUjwI/Vt3Grd8df0I/AAAAAAAAA78/7xqUNj8ujtY/s1600/image02.png"];
    
    [FBSDKAppInviteDialog showFromViewController:controller withContent:content delegate:self];
}

#pragma mark - FBSDKAppInviteDialogDelegate

- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didCompleteWithResults:(NSDictionary *)results {
    NSLog(@"results = %@", results);
}

- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didFailWithError:(NSError *)error {
    NSLog(@"error = %@", error);
}


- (void)logOutFacebook
{
    [[[FBSDKLoginManager alloc] init] logOut];
}


///************************************



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
