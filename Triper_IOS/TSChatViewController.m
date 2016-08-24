//
//  TSChatViewController.m
//  Triper_IOS
//
//  Created by Mac on 08.07.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue: b/255.0 alpha:1.0]
#define WHITE_COLOR RGB(175, 175, 175)
#define GRAY_COLOR RGB(65, 70, 80)

#import "TSChatViewController.h"
#import "TSUserViewController.h"
#import "TSMenuTableViewCell.h"
#import "TSCellView.h"
#import "TSServerManager.h"
#import "TSMessagerViewController.h"
#import "TSContact.h"
#import "TSSearch.h"
#import "TSView.h"
#import "TSParsingManager.h"
#import "TSParsingUserName.h"
#import "TSContainerChatViewController.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Contacts/Contacts.h>

@import Firebase;
@import FirebaseDatabase;

@interface TSChatViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *friends;
@property (strong, nonatomic) NSMutableArray *nameFriends;
@property (strong, nonatomic) NSMutableArray *arrayFriends;
@property (strong, nonatomic) TSCellView *cell;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (assign, nonatomic) BOOL isOpen;

@end

@implementation TSChatViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.ref = [[FIRDatabase database] reference];
    [self requestToServerFacebookListFriends];
    
    TSView *grayRect = [[TSView alloc] initWithView:self.view];
    [self.view addSubview:grayRect];
    
    UISearchBar *searchBar = [[TSSearchBar alloc] initWithView:self.view];
    [self.view addSubview:searchBar];
    searchBar.delegate = self;
    
    self.tableView.contentInset = UIEdgeInsetsMake(36, 0, 0, 0);
}


- (void)requestToServerFacebookListFriends
{
    [[TSServerManager sharedManager] requestUserFriendsTheServerFacebook:^(NSArray *friends)
    {
        self.friends = [TSParsingManager parsingFriendsFacebook:friends];
        [self.tableView reloadData];
        self.arrayFriends = [NSMutableArray arrayWithArray:self.friends];
    }];
    
//    [self.ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
//        FIRDataSnapshot *user = [snapshot childSnapshotForPath:@"users"];
//        NSLog(@"RETRIVE users %@", user);
//    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated
{
    
}


#pragma mark - Actions


- (IBAction)actionPhoneButton:(UIButton *)sender
{
    
}


- (IBAction)actionChatButton:(UIButton *)sender
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:[sender tag]];
    
    NSDictionary *indexSection = [self.friends objectAtIndex:indexPath.section];
    NSArray *dataIDFriend = [indexSection objectForKey:@"id"];
    NSString *idFriend = [dataIDFriend objectAtIndex:0];
    NSLog(@"ID friends %@", idFriend);
    
    TSContainerChatViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TSContainerChatViewController"];
    [controller callActionButtonNavigation];
}


- (IBAction)actionSkypeButton:(UIButton *)sender
{
    NSLog(@"Skype %ld", (long)sender.tag);

    BOOL installed = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"skype:"]];
    if(installed) {
        NSString * userNameString = @"valia.ts.2016";
        NSString* urlString = [NSString stringWithFormat:@"skype:%@?call", userNameString];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://appsto.re/ru/Uobls.i"]];
    }
}


- (IBAction)actionAddUser:(UIButton *)sender
{
    FIRUser *user = [FIRAuth auth].currentUser;
    
    NSString *name = user.displayName;
//    NSString *email = user.email;
//    NSURL *photoUrl = user.photoURL;
    NSString *uid = user.uid;
    NSString *userID = user.displayName;
    
    
    NSLog(@"name = %@", name);
    
    
    NSString *key = [[_ref child:@"posts"] childByAutoId].key;
    NSDictionary *post = @{@"uid": uid,
                        @"author": name};
    NSDictionary *childUpdates = @{[@"/posts/" stringByAppendingString:key]: post,
                                   [NSString stringWithFormat:@"/user-posts/%@/%@/", userID, key]: post};
    [self.ref updateChildValues:childUpdates];
    
    NSLog(@"key = %@", key);
}


- (IBAction)actionMessage:(UIButton *)sender  //FIRDataEventTypeValue
{
    TSMessagerViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TSMessagerViewController"];
    [self presentViewController:controller animated:YES completion:nil];
    
    
    [self.ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        FIRDataSnapshot *muterData = [snapshot childSnapshotForPath:@"user-posts/v7rDRmPZrgQKh2NOLNp9s2X0cov1"];
        FIRDataSnapshot *muterDataPost = [snapshot childSnapshotForPath:@"user-posts/v7rDRmPZrgQKh2NOLNp9s2X0cov1/-KNgPaRndUDfP4yuiRRY"];
        NSLog(@"Shapshot childSnapshotForPath count = %@", muterDataPost);
        NSLog(@"Shapshot children = %@", [muterData children]);

//        NSString *key = [[[self.ref child:@"posts"] childByAutoId] key];

        NSLog(@"%@", muterDataPost.value[@"title"]);
        NSLog(@"%@", muterDataPost.value[@"body"]);

        NSString *post = [NSString stringWithFormat:@"%@", muterDataPost];
        NSScanner *scanPost = [NSScanner scannerWithString:post];
        NSString *updatePost;
        while (![scanPost isAtEnd]) {
            [scanPost scanString:@"(body)" intoString:nil];
            [scanPost scanUpToString:@"(body)" intoString:&updatePost];
        }
        NSLog(@"updatePost %@", updatePost);
    }];
}



#pragma mark - UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.friends.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *currentSection = [self.friends objectAtIndex:section];
    if ([[currentSection objectForKey:@"isOpen"] boolValue]) {
        NSArray *items = [currentSection objectForKey:@"items"];
        return items.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"detail";
    
    TSMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[TSMenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
//    FBSDKProfilePictureView *avatar = [[TSServerManager sharedManager]
//                                       requestUserImageFromTheServerFacebook:cell.avatarUser ID:@"me"];

//    UIImage *image = nil;
//    
//    for (NSObject *obj in [avatar subviews]) {
//        if ([obj isMemberOfClass:[UIImageView class]]) {
//            UIImageView *objImg = (UIImageView *)obj;
//            image = objImg.image;
//            break;
//        }
//    }
//
//    cell.avatarUser.image = image;
    
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    NSDictionary *currentSection = [self.friends objectAtIndex:section];
    NSArray *dataNameFriend = [currentSection objectForKey:@"items"];
    NSString *nameFriend = [dataNameFriend objectAtIndex:0];
    
    NSArray *dataIDFriend = [currentSection objectForKey:@"id"];
    NSString *idFriend = [dataIDFriend objectAtIndex:0];
    
    self.isOpen = [[currentSection objectForKey:@"isOpen"] boolValue];
    
    self.cell = [TSCellView cellView];
    self.cell.nameLabel.text = nameFriend;
    self.cell.titleLabel.text = nameFriend;
    self.cell.companyLabel.text = idFriend;
    
    FBSDKProfilePictureView *avatar = [[TSServerManager sharedManager]
                                       requestUserImageFromTheServerFacebook:self.cell.avatarImageView ID:idFriend];
    avatar.layer.cornerRadius = avatar.frame.size.width / 2;
    avatar.clipsToBounds = YES;
    [self.cell addSubview:avatar];
    
    
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(275.0f, 39.0f, 22.0f, 22.0f);
    button.tag = section;
    
    [button addTarget:self action:@selector(didSelectSection:) forControlEvents:UIControlEventTouchUpInside];
    [self.cell addSubview:button];
    
    return self.cell;
    
}


- (void)didSelectSection:(UIButton *)sender
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:[sender tag]];
    
    NSDictionary *indexSection = [self.friends objectAtIndex:indexPath.section];
    NSArray *dataIDFriend = [indexSection objectForKey:@"id"];
    NSString *idFriend = [dataIDFriend objectAtIndex:0];
    NSLog(@"ID friends %@", idFriend);
    
    TSMenuTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    FBSDKProfilePictureView *avatar = [[TSServerManager sharedManager]
                                       requestUserImageFromTheServerFacebook:self.cell.avatarImageView ID:idFriend];
    avatar.layer.cornerRadius = avatar.frame.size.width / 2;
    avatar.clipsToBounds = YES;
    [cell addSubview:avatar];
    
    NSMutableDictionary *currentSection = [self.friends objectAtIndex:sender.tag];
    NSArray *items = [currentSection objectForKey:@"items"];
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (int i = 0; i < items.count; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:sender.tag]];
    }
    
    BOOL isOpen = [[currentSection objectForKey:@"isOpen"] boolValue];
    
    [currentSection setObject:[NSNumber numberWithBool:!isOpen] forKey:@"isOpen"];
    
    if (isOpen) {
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
    } else {
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
    }
}


#pragma mark - UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 100;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 67;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - UISearchBarDelegate


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
{
    if ([searchText isEqualToString:@""]) {
        
        self.friends = [NSMutableArray arrayWithArray:self.arrayFriends];
    } else {
        self.friends = [TSSearch calculationSearchArray:self.friends text:searchText];
    }
    [self.tableView reloadData];
}


// метод отсутствия интернета


//- (BOOL)connected
//{
//    Reachability *reachability = [Reachability reachabilityForInternetConnection];
//    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
//    return networkStatus != NotReachable;
//}



@end
