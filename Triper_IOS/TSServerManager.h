//
//  TSServerManager.h
//  Triper_IOS
//
//  Created by Mac on 23.06.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSServerManager : NSObject

+ (TSServerManager *)sharedManager;
- (void)authorizationOfNewUser:(NSString *)userID userLogin:(NSString *)userLogin;

@end
