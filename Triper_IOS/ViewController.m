//
//  ViewController.m
//  Triper_IOS
//
//  Created by Mac on 03.07.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "ViewController.h"
#import "SWRevealViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _barButton.target = self.revealViewController;
    _barButton.action = @selector(revealToggle:);
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
//    SWRevealViewController *revealViewController = self.revealViewController;
//    if ( revealViewController )
//    {
//        [self.barButton setTarget: self.revealViewController];
//        [self.barButton setAction: @selector(revealToggle:)];
//        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
//    }
}


@end
