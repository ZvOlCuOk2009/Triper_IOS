//
//  TSHomeViewController.m
//  Triper_IOS
//
//  Created by Mac on 02.07.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSHomeViewController.h"
#import "TSMenuViewController.h"
#import "SWRevealViewController.h"

@interface TSHomeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) TSUser *currentUser;

@end

@implementation TSHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Home";
    
    _barButton.target = self.revealViewController;
    _barButton.action = @selector(revealToggle:);
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    NSData *imageData = [NSData dataWithContentsOfURL:self.currentUser.avatar];
    self.avatarImageView.image = [UIImage imageWithData:imageData];
    NSLog(@"SELF CURRENTUSER VIEW = %@", self.currentUser);
}

- (void)receiveUserData:(TSUser *)user
{
    self.currentUser = user;
}

- (IBAction)actionMenuButton:(UIBarButtonItem *)sender
{
//    TSMenuViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TSMenuViewController"];
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.4;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionPush;
//    transition.subtype = kCATransitionFromLeft;
//    [self.view.window.layer addAnimation:transition forKey:nil];
//    [self presentViewController:controller animated:NO completion:nil];
}

@end
