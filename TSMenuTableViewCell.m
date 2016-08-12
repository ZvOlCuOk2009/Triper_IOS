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
    NSLog(@"Phone %ld", (long)sender.tag);
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:+38-067-775-6449"]];
}

- (IBAction)actionChatButton:(UIButton *)sender
{
    NSLog(@"Chat %ld", (long)sender.tag);
}

- (IBAction)actionSkypeButton:(UIButton *)sender
{
    NSLog(@"Skype %ld", (long)sender.tag);
    
    BOOL installed = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"skype:"]];
    if(installed) {
        NSString * userNameString = @"valia.ts.2016";
        NSString* urlString = [NSString stringWithFormat:@"skype:%@?call", userNameString];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://appsto.re/ru/Uobls.i"]];
    }
}

@end
