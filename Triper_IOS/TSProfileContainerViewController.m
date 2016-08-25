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
#import "TSFireUser.h"

@import Firebase;
@import FirebaseDatabase;

@interface TSProfileContainerViewController ()

@property (strong, nonatomic) FIRDatabaseReference *ref;

@end

@implementation TSProfileContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ref = [[FIRDatabase database] reference];
    
    [self.ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        TSFireUser *fireUser = [TSFireUser initWithSnapshot:snapshot];
        
        TSProfileView *profileView = [TSProfileView profileView];
        profileView.frame = CGRectMake((self.view.frame.size.width - profileView.frame.size.width) / 2, 55, profileView.frame.size.width, profileView.frame.size.height);
        profileView.likeView.hidden = YES;
        profileView.nameLabel.text = fireUser.displayName;
        profileView.miniNameLabel.text = fireUser.displayName;
        
        profileView.nameLabel.text = fireUser.displayName;
        profileView.miniNameLabel.text = fireUser.displayName;
        
        NSURL *url = [NSURL URLWithString:fireUser.photoURL];
        
        if (url && url.scheme && url.host) {
            
            profileView.avatarImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:
                                                                        [NSURL URLWithString:fireUser.photoURL]]];
        } else {
            
            NSData *data = [[NSData alloc]initWithBase64EncodedString:fireUser.photoURL options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *convertImage = [UIImage imageWithData:data];
            profileView.avatarImageView.image = convertImage;
        }
        
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
