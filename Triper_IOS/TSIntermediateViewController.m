//
//  TSIntermediateViewController.m
//  Triper_IOS
//
//  Created by Mac on 07.09.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSIntermediateViewController.h"
#import "TSRetriveFriendsFBDatabase.h"
#import "TSMatchViewController.h"
#import "TSContainerMatchViewController.h"

@import Firebase;
@import FirebaseDatabase;

@interface TSIntermediateViewController ()

@property (strong, nonatomic) NSMutableArray *friends;
@property (strong, nonatomic) FIRDatabaseReference *ref;

@end

@implementation TSIntermediateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.ref = [[FIRDatabase database] reference];
    
    [self.ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        self.friends = [TSRetriveFriendsFBDatabase retriveFriendsDatabase:snapshot];
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        TSMatchViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TSMatchViewController"];
        controller.friends = self.friends;
        
        TSContainerMatchViewController *container = [self.storyboard instantiateViewControllerWithIdentifier:@"TSContainerMatchViewController"];
        [container hideIntermediaController];
//        [self presentViewController:controller animated:YES completion:nil];
        
    });
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
