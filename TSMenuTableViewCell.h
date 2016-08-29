//
//  TSMenuTableViewCell.h
//  Triper_IOS
//
//  Created by Mac on 30.06.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSMenuTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarUser;

@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (weak, nonatomic) IBOutlet UIButton *chatButton;
@property (weak, nonatomic) IBOutlet UIButton *skypeButton;
@property (weak, nonatomic) IBOutlet UIView *orangeRectangle;

- (IBAction)actionPhoneButton:(UIButton *)sender;
- (IBAction)actionChatButton:(UIButton *)sender;
- (IBAction)actionSkypeButton:(UIButton *)sender;

@end
