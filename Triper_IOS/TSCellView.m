//
//  TSCellView.m
//  Triper_IOS
//
//  Created by Mac on 24.07.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSCellView.h"
#import "TSRandomFriendsTest.h"

@interface TSCellView ()

@property (strong, nonatomic) UIImage *avatar;

@end

@implementation TSCellView

- (void)drawRect:(CGRect)rect
{
    TSRandomFriendsTest *testUser = [[TSRandomFriendsTest alloc] init];
    
    NSString *name = [NSString stringWithFormat:@"%@ %@", [testUser.firstNames objectAtIndex:arc4random_uniform(8)],
                      [testUser.lastNames objectAtIndex:arc4random_uniform(8)]];
    NSString *profession = [testUser.profession objectAtIndex:arc4random_uniform(10)];
    NSString *countryComing = [testUser.countryComing objectAtIndex:arc4random_uniform(14)];
    self.avatar = [UIImage imageNamed:[testUser.avatars objectAtIndex:arc4random_uniform(16)]];
    
    self.nameLabel.text = name;
    self.titleLabel.text = profession;
    self.companyLabel.text = @"Terminus";
    self.locationLabel.text = countryComing;
    self.avatarImageView.image = self.avatar;
}

- (UIImage *)avatarImage
{
    TSRandomFriendsTest *testUser = [[TSRandomFriendsTest alloc] init];
    UIImage *avatar = [UIImage imageNamed:[testUser.avatars objectAtIndex:arc4random_uniform(16)]];
    return avatar;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {

    }    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

+ (instancetype)cellView
{
    UINib *nib = [UINib nibWithNibName:@"TSCellView" bundle:nil];
    TSCellView *view = [nib instantiateWithOwner:self options:nil][0];
    view.frame = CGRectMake(0, 0, 320, 100);
    return view;
}

@end
