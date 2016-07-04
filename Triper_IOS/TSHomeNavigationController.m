//
//  TSHomeNavigationController.m
//  Triper_IOS
//
//  Created by Mac on 02.07.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSHomeNavigationController.h"
#import "TSHomeViewController.h"

@interface TSHomeNavigationController ()

@property (strong, nonatomic) TSUser *currentUser;

@end

@implementation TSHomeNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    TSHomeViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TSHomeViewController"];
    [controller receiveUserData:self.currentUser];
    
    NSLog(@"SELF CURRENTUSER NAV = %@", self.currentUser);
}

- (void)receiveUserData:(TSUser *)user
{
    self.currentUser = user;
}

@end
