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
    if  (!self.friends.count)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Here you will see your friends..."
                                                                                 message:@""
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action  = [UIAlertAction actionWithTitle:@"Ok"
                                                          style:UIAlertActionStyleCancel
                                                        handler:^(UIAlertAction * _Nonnull action) { }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
        
        return nil;
    }
    
    self.profileView = [TSProfileView profileView];
    
    NSInteger max = [self.friends count];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:counter inSection:0];
    NSDictionary *indexCard = [self.friends objectAtIndex:indexPath.row];
    NSArray *arrayID = [indexCard objectForKey:@"id"];
    NSArray *arrayName = [indexCard objectForKey:@"items"];
    NSString *idFriend = [arrayID objectAtIndex:0];
    NSString *nameFriend = [arrayName objectAtIndex:0];
    
    self.profileView.nameLabel.text = nameFriend;
    self.profileView.miniNameLabel.text = nameFriend;
    
    FBSDKProfilePictureView *avatar = [[TSServerManager sharedManager]
                                       requestUserImageFromTheServerFacebook:self.profileView.avatarImageView
                                                                          ID:idFriend];
    avatar.layer.cornerRadius = avatar.frame.size.width / 2;
    avatar.clipsToBounds = YES;
    [self.profileView addSubview:avatar];
    
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
