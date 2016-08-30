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
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    
//    NSLog(@"contacts %@", contacts.description);
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:[sender tag]];
    
//    NSLog(@"TAG %ld", sender.tag);
//    NSLog(@"indexPath %ld", indexPath.section);
//    NSDictionary *indexSection = [friends objectAtIndex:indexPath.section];
//    NSArray *dataIDFriend = [indexSection objectForKey:@"id"];
//    NSString *idFriend = [dataIDFriend objectAtIndex:0];
//    NSLog(@"indexPath %@", indexSection.description);
}

- (IBAction)actionChatButton:(UIButton *)sender
{
    
}

- (IBAction)actionSkypeButton:(UIButton *)sender
{

}

@end
