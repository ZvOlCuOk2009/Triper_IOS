//
//  TSTabBarController.m
//  Triper_IOS
//
//  Created by Mac on 08.07.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSTabBarController.h"

@interface TSTabBarController ()

@end

@implementation TSTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    
    [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger idx, BOOL *stop) {
        vc.title = nil;
        //vc.tabBarItem.imageInsets = UIEdgeInsetsMake(7, 0, -5, 0);
    }];
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