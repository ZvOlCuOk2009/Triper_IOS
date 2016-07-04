//
//  TSCardViewController.m
//  Triper_IOS
//
//  Created by Mac on 25.06.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSCardViewController.h"
#import "SWRevealViewController.h"

@interface TSCardViewController ()

@property (weak, nonatomic) IBOutlet UIView *personalDataView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@end

@implementation TSCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

@end
