//
//  TSUser.m
//  Triper_IOS
//
//  Created by Mac on 02.07.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSUser.h"

@implementation TSUser

- (id)initWithDictionary:(NSDictionary *)responseValue
{
    self = [super init];
    if (self) {
        self.name = [responseValue valueForKey:@"name"];
        self.firstName = [responseValue valueForKey:@"first_name"];
        self.lastName = [responseValue valueForKey:@"last_name"];
        self.location = [responseValue valueForKey:@"location"];
        self.bio = [responseValue valueForKey:@"bio"];
        self.friendlists = [responseValue valueForKey:@"friendlists"];
        self.email = [responseValue valueForKey:@"email"];
        NSString *urlString = [[[responseValue valueForKey:@"picture"] valueForKey:@"data"] valueForKey:@"url"];
        self.avatar = [[NSURL alloc] initWithString:urlString];
    }
    return self;
}

@end
