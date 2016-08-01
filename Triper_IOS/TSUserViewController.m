//
//  TSUserViewController.m
//  Triper_IOS
//
//  Created by Mac on 23.07.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSUserViewController.h"
#import "TSServerManager.h"
#import "TSUser.h"
#import "TSLoginViewController.h"
#import "TSProfileView.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface TSUserViewController ()
 
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) TSUser *user;

@end

@implementation TSUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    TSProfileView *profileView = [TSProfileView profileView];
    [self.view addSubview:profileView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
