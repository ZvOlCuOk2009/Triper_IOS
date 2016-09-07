//
//  TSTestViewController.m
//  Triper_IOS
//
//  Created by Mac on 08.07.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSMatchViewController.h"
#import "TSProfileView.h"
#import "ZLSwipeableView.h"
#import "TSServerManager.h"
#import "TSParsingManager.h"
#import "TSRetriveFriendsFBDatabase.h"

static NSInteger counter = 0;

@import Firebase;
@import FirebaseDatabase;

@interface TSMatchViewController () <ZLSwipeableViewDataSource, ZLSwipeableViewDelegate>

@property (weak, nonatomic) TSProfileView *profileView;
@property (strong, nonatomic) ZLSwipeableView *swipeableView;
@property (strong, nonatomic) FIRDatabaseReference *ref;

@end

@implementation TSMatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.ref = [[FIRDatabase database] reference];
    
    [self.ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        self.friends = [TSRetriveFriendsFBDatabase retriveFriendsDatabase:snapshot];
    }];
    
    CGRect frame = CGRectMake(0, - 20, self.view.bounds.size.width, self.view.bounds.size.height);

    self.swipeableView = [[ZLSwipeableView alloc] initWithFrame:self.view.frame];
    self.swipeableView.frame = frame;
    [self.view addSubview:self.swipeableView];
    
    self.swipeableView.dataSource = self;
    self.swipeableView.delegate = self;
    
    [self.swipeableView swipeTopViewToLeft];
    [self.swipeableView swipeTopViewToRight];
    
    [self.swipeableView discardAllViews];
    [self.swipeableView loadViewsIfNeeded];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


#pragma mark - ZLSwipeableViewDataSource


- (UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView
{
//    if  (!self.friends.count)
//    {
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Here you will see your friends..."
//                                                                                 message:@""
//                                                                          preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *action  = [UIAlertAction actionWithTitle:@"Ok"
//                                                          style:UIAlertActionStyleCancel
//                                                        handler:^(UIAlertAction * _Nonnull action) { }];
//        [alertController addAction:action];
//        [self presentViewController:alertController animated:YES completion:nil];
//        
//        return nil;
//    }
    
    self.profileView = [TSProfileView profileView];
    
    NSInteger max = [self.friends count];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:counter inSection:0];
    NSDictionary *indexCard = [self.friends objectAtIndex:indexPath.row];
    NSString *nameFriend = [indexCard objectForKey:@"items"];
    NSString *photoURL = [indexCard objectForKey:@"photoURL"];
    NSURL *url = [NSURL URLWithString:photoURL];
    
    self.profileView.nameLabel.text = nameFriend;
    self.profileView.miniNameLabel.text = nameFriend;
    
    if (url && url.scheme && url.host) {
        
        NSData *dataImage = [NSData dataWithContentsOfURL:url];
        self.profileView.avatarImageView.image = [UIImage imageWithData:dataImage];
        
    } else {
        
        if (!photoURL) {
            photoURL = @"";
        }
        
        NSData *data = [[NSData alloc]initWithBase64EncodedString:photoURL options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage *convertImage = [UIImage imageWithData:data];
        self.profileView.avatarImageView.image = convertImage;
    }
    
    ++counter;
    
    if (counter == max) {
        counter = 0;
    }
    
    return self.profileView;
}


#pragma mark - ZLSwipeableViewDelegate

- (void)swipeableView:(ZLSwipeableView *)swipeableView didSwipeView:(UIView *)view
          inDirection:(ZLSwipeableViewDirection)direction
{

}

- (void)swipeableView:(ZLSwipeableView *)swipeableView didCancelSwipe:(UIView *)view
{

}

- (void)swipeableView:(ZLSwipeableView *)swipeableView didStartSwipingView:(UIView *)view atLocation:(CGPoint)location
{

}

- (void)swipeableView:(ZLSwipeableView *)swipeableView swipingView:(UIView *)view
           atLocation:(CGPoint)location translation:(CGPoint)translation
{

}

- (void)swipeableView:(ZLSwipeableView *)swipeableView didEndSwipingView:(UIView *)view atLocation:(CGPoint)location
{

}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
