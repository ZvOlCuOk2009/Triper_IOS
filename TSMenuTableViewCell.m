//
//  TSMenuTableViewCell.m
//  Triper_IOS
//
//  Created by Mac on 30.06.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSMenuTableViewCell.h"
#import "TSUserViewController.h"

@implementation TSMenuTableViewCell

- (IBAction)actionPhoneButton:(UIButton *)sender
{
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:+38-067-775-6449"]];
}

- (IBAction)actionChatButton:(UIButton *)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:+38-067-775-6449"]];
}

- (IBAction)actionSkypeButton:(UIButton *)sender
{

}

@end
