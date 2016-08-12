//
//  TSUser.h
//  Triper_IOS
//
//  Created by Mac on 02.07.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSUser : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *bio;
@property (strong, nonatomic) NSString *friendlists;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSURL *avatar;

- (id)initWithDictionary:(NSDictionary *)responseValue;

@end
