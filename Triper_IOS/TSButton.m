//
//  TSButton.m
//  Triper_IOS
//
//  Created by Mac on 04.07.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue: b/255.0 alpha:1.0]
#define MAIN_COLOR RGB(255, 110, 50)
#define SEPARATOR_COLOR RGB(200, 200, 200)

#import "TSButton.h"

@implementation TSButton

- (instancetype)initWithFrame:(CGRect)frame avatarUser:(UIImageView *)avatarUser
                     nameUser:(NSString *)nameUser titleUser:(NSString *)titleUser
                  companyUser:(NSString *)companyUser locationUser:(NSString *)locationUser
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        CGRect frameAvatar = CGRectMake(6, 10, 60, 60);
        UIImageView *avatar = [[UIImageView alloc] initWithFrame:frameAvatar];
        avatar = avatarUser;
        [self addSubview:avatarUser];
        
        CGRect frameName = CGRectMake(74, 4, 107, 21);
        UILabel *nameUserLabel = [[UILabel alloc] initWithFrame:frameName];
        nameUserLabel.frame = frameName;
        nameUserLabel.text = nameUser;
        [self addSubview:nameUserLabel];
        
        CGRect frameTitle = CGRectMake(114, 24, 132, 13);
        UILabel *titleUserLabel = [[UILabel alloc] initWithFrame:frameTitle];
        titleUserLabel.frame = frameTitle;
        titleUserLabel.text = titleUser;
        [self addSubview:titleUserLabel];
        
        CGRect frameCompany = CGRectMake(146, 40, 98, 13);
        UILabel *companyUserLabel = [[UILabel alloc] initWithFrame:frameCompany];
        companyUserLabel.frame = frameCompany;
        companyUserLabel.text = companyUser;
        [self addSubview:companyUserLabel];
        
        CGRect frameLocation = CGRectMake(80, 56, 132, 13);
        UILabel *locationUserLabel = [[UILabel alloc] initWithFrame:frameLocation];
        locationUserLabel.frame = frameLocation;
        locationUserLabel.text = locationUser;
        [self addSubview:locationUserLabel];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame avatarUser:(UIImageView *)avatarUser nameUser:(NSString *)nameUser
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        CGRect frameAvatar = CGRectMake(6, 10, 60, 60);
        UIImageView *avatar = [[UIImageView alloc] initWithFrame:frameAvatar];
        avatar = avatarUser;
        [self addSubview:avatarUser];
        
        CGRect frameName = CGRectMake(74, 4, 107, 21);
        UILabel *nameUserLabel = [[UILabel alloc] initWithFrame:frameName];
        nameUserLabel.frame = frameName;
        nameUserLabel.text = nameUser;
        [self addSubview:nameUserLabel];
    }
    return self;
}

@end
