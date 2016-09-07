//
//  TSContainerMatchViewController.m
//  Triper_IOS
//
//  Created by Mac on 07.09.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSContainerMatchViewController.h"
#import "TSIntermediateViewController.h"

@interface TSContainerMatchViewController ()
@property (weak, nonatomic) IBOutlet UIView *matchView;
@property (weak, nonatomic) IBOutlet UIView *intermediaView;

@end

@implementation TSContainerMatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)hideIntermediaController
{
    self.intermediaView.alpha = 0.0;
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
