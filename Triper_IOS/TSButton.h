//
//  TSButton.h
//  Triper_IOS
//
//  Created by Mac on 04.07.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSButton : UIButton

@property (strong, nonatomic) UIImageView *avatarUser;
@property (strong, nonatomic) NSString *nameUser;
@property (strong, nonatomic) NSString *titleUser;
@property (strong, nonatomic) NSString *companyUser;
@property (strong, nonatomic) NSString *locationUser;

- (instancetype)initWithFrame:(CGRect)frame avatarUser:(UIImageView *)avatarUser
                     nameUser:(NSString *)nameUser titleUser:(NSString *)titleUser
                  companyUser:(NSString *)companyUser locationUser:(NSString *)locationUser;

- (instancetype)initWithFrame:(CGRect)frame avatarUser:(UIImageView *)avatarUser nameUser:(NSString *)nameUser;

@end
