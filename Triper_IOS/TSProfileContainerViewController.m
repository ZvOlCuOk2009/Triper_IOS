//
//  TSProfileContainerViewController.m
//  Triper_IOS
//
//  Created by Mac on 13.08.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSProfileContainerViewController.h"
#import "TSServerManager.h"
#import "TSProfileView.h"
#import "TSView.h"

@interface TSProfileContainerViewController ()

@end

@implementation TSProfileContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[TSServerManager sharedManager] requestUserDataFromTheServerFacebook:^(TSUser *user) {
        TSProfileView *profileView = [TSProfileView profileView];
        profileView.frame = CGRectMake((self.view.frame.size.width - profileView.frame.size.width) / 2, 55, profileView.frame.size.width, profileView.frame.size.height);
        profileView.nameLabel.text = user.name;
        profileView.miniNameLabel.text = user.name;
        profileView.likeView.hidden = YES;
        profileView.avatarImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:user.avatar]];
        [self.view addSubview:profileView];
    }];
    
    TSView *grayRect = [[TSView alloc] initWithView:self.view];
    [self.view addSubview:grayRect];
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
