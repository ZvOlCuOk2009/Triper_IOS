//
//  TSProfileView.h
//  Triper_IOS
//
//  Created by Mac on 13.07.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSProfileView : UIView

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *professionLabel;
@property (weak, nonatomic) IBOutlet UILabel *comingFromLabel;
@property (weak, nonatomic) IBOutlet UILabel *coingToLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentArreaLabel;
@property (weak, nonatomic) IBOutlet UILabel *launguageLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *miniNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *countMatchLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIView *likeView;

- (IBAction)mainButtonsAction:(UIButton *)sender;
- (IBAction)getEmailAction:(UIButton *)sender;

+ (instancetype)profileView:(NSDictionary *)content;

@end
