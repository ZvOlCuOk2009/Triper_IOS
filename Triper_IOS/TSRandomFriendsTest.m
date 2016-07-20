//
//  TSRandomFriendsTest.m
//  Triper_IOS
//
//  Created by Mac on 18.07.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSRandomFriendsTest.h"

@interface TSRandomFriendsTest ()

@end

@implementation TSRandomFriendsTest

+ (TSRandomFriendsTest *)sharedManager
{
    static TSRandomFriendsTest *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TSRandomFriendsTest alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.firstNames = @[@"Preston", @"Ethan", @"John", @"Anthony", @"William", @"Christopher", @"Jacob", @"Randolph"];
        self.lastNames = @[@"Shelton", @"Cross", @"Mitchell", @"Bishop", @"Poole", @"Dawson", @"Ferguson", @"Armstrong"];
        self.avatars = @[@"av1", @"av2", @"av3", @"av4", @"av5", @"av6", @"av7", @"av8",
                         @"av9", @"av10", @"av11", @"av12", @"av13", @"av14", @"av15", @"av16"];
        self.profession = @[@"developer", @"PR manager", @"banker", @"loader", @"driver", @"doctor", @"builder", @"director", @"seo", @"designer"];
        self.countryComing = @[@"Paris, France", @"London, England", @"Berlin, Germany", @"Lisbon portugal", @"Barcelona, Spain", @"Kiev, Ukraine", @"Toronto Canada", @"Los Angeles, USA", @"Washington, USA", @"Rome, Italy", @"Tokyo, Japan", @"Delhi, India", @"Shanghai, China", @"Istanbul, Turkey"];
        self.countryCoing = @[@"Paris, France", @"London, England", @"Berlin, Germany", @"Lisbon portugal", @"Barcelona, Spain", @"Kiev, Ukraine", @"Toronto Canada", @"Los Angeles, USA", @"Washington, USA", @"Rome, Italy", @"Tokyo, Japan", @"Delhi, India", @"Shanghai, China", @"Istanbul, Turkey"];
        self.cityCurrent = @[@"Marseilles", @"Amsterdam", @"Venice", @"Mexico", @"NY", @"Dallas", @"Moscow", @"San Francisco", @"San Jose", @"Rio de Janeiro", @"Santa Monica"];
        self.age = @[@"32", @"34", @"35", @"37", @"41", @"43", @"45", @"47", @"51", @"38"];
        self.launguage = @[@"English", @"Spanish", @"English", @"German", @"French", @"German", @"English"];  
    }
    return self;
}

@end
