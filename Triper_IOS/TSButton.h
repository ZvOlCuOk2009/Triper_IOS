//
//  TSButton.h
//  Triper_IOS
//
//  Created by Mac on 04.07.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSButton : UIButton

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *icon;
@property (assign, nonatomic) BOOL isOpen;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title icon:(NSString *)icon;

@end
