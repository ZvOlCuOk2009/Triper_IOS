//
//  TSMenuTableViewCell.m
//  Triper_IOS
//
//  Created by Mac on 30.06.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSMenuTableViewCell.h"

@implementation TSMenuTableViewCell

- (IBAction)actionPhoneButton:(UIButton *)sender
{
    NSLog(@"Phone %ld", sender.tag);
}

- (IBAction)actionChatButton:(UIButton *)sender
{
    NSLog(@"Chat %ld", sender.tag);
}

- (IBAction)actionSkypeButton:(UIButton *)sender
{
    NSLog(@"Skype %ld", sender.tag);
}

@end
