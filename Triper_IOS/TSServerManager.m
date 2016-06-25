//
//  TSServerManager.m
//  Triper_IOS
//
//  Created by Mac on 23.06.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSServerManager.h"
#import "AFNetworking.h"

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
        //NSURL *url = [NSURL URLWithString:@"http://www.golinkder.com/process.php/MyApi/login"];
        self.sessionManager = [[AFHTTPSessionManager alloc] init];
    }
    return self;
}

- (void)authorizationOfNewUser:(NSString *)userID
                     userLogin:(NSString *)userLogin
                     onSuccess:(void(^)(NSArray *token)) success
{
    NSDictionary *parameters = @{@"id":userID,
                                 @"name":userLogin};
    
    [self.sessionManager POST:@"http://www.golinkder.com/process.php/MyApi/login"
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
