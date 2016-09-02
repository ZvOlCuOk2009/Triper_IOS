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

#define IS_IPHONE_4 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)480) < DBL_EPSILON)
#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)568) < DBL_EPSILON)
#define IS_IPHONE_6 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)667) < DBL_EPSILON)
#define IS_IPHONE_6_PLUS (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)736) < DBL_EPSILON)

#import "TSChatViewController.h"
#import "TSMenuTableViewCell.h"
#import "TSCellView.h"
#import "TSServerManager.h"
#import "TSMessagerViewController.h"
#import "TSUserViewController.h"
#import "TSParsingManager.h"
#import "TSParsingUserName.h"
#import "TSSearch.h"
#import "TSView.h"
#import "TSRetriveFriendsFBDatabase.h"
#import "TSContainerChatViewController.h"
#import "TSUserViewController.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>

@import Firebase;
@import FirebaseDatabase;

@interface TSChatViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *friends;
@property (strong, nonatomic) NSMutableArray *arrayFriends;
@property (strong, nonatomic) NSMutableArray *imageFriends;
@property (strong, nonatomic) NSString *currentID;
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
    
    self.imageFriends = [NSMutableArray array];
    
    TSView *grayRect = [[TSView alloc] initWithView:self.view];
    [self.view addSubview:grayRect];
    
    UISearchBar *searchBar = [[TSSearchBar alloc] initWithView:self.view];
    [self.view addSubview:searchBar];
    searchBar.delegate = self;
    
    self.tableView.contentInset = UIEdgeInsetsMake(36, 0, 46, 0);
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
//        
//        self.friends = [TSRetriveFriendsFBDatabase retriveFriendsDatabase:snapshot];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self.tableView reloadData];
//        });
//        self.arrayFriends = [NSMutableArray arrayWithArray:self.friends];
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
    
    NSIndexPath *indexPath = [self determineTheAffiliationSectionOfTheCell:sender];
    
    NSInteger curruntUserIndex = indexPath.section;
    
    NSArray *nameContacts = [TSParsingUserName parsingOfTheUserName:self.friends];
    NSString *currentUser = [nameContacts objectAtIndex:curruntUserIndex];
    
    TSUserViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TSUserViewController"];
    NSString *contact = [controller retriveNumberPhoneContacts:currentUser];
    
    NSCharacterSet *nonDigitCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSString *number = [[contact componentsSeparatedByCharactersInSet:nonDigitCharacterSet] componentsJoinedByString:@""];
    
    if (number) {
        
        NSString *numberPrefix = [NSString stringWithFormat:@"tel:%@", number];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:numberPrefix]];
        
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"The selected user does not have a phone number in the phone book"
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                         
                                                             [self secondAlert];
                                                         }];
        
        [alertController addAction:action];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}


- (void)secondAlert
{
    UIAlertController *secondAlertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"To call the contact numbers of applications, it is necessary that the names of friends and contacts in the address book were the same!"]
                                                                                message:@"Please edit the contact names in the phone book to make calls from Triper ..."
                                                                         preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                      }];
    
    [secondAlertController addAction:secondAction];
    
    [self presentViewController:secondAlertController animated:YES completion:nil];
}


- (IBAction)actionChatButton:(UIButton *)sender
{

    TSContainerChatViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TSContainerChatViewController"];
    [controller callActionButtonNavigation];
    
    NSIndexPath *indexPath = [self determineTheAffiliationSectionOfTheCell:sender];
    
    NSLog(@"section ID %ld", indexPath.section);
}


- (IBAction)actionSkypeButton:(UIButton *)sender
{

    BOOL installed = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"skype:"]];
    if(installed) {
//        NSString * userNameString = @"valia.ts.2016";
//        NSString* urlString = [NSString stringWithFormat:@"skype:%@?call", userNameString];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://appsto.re/ru/Uobls.i"]];
    }
    
}


- (NSIndexPath *)determineTheAffiliationSectionOfTheCell:(UIButton *)button
{
    CGPoint buttonPosition = [button convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    return indexPath;
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
    
    NSString *index = [self.imageFriends objectAtIndex:indexPath.section];
    
    FBSDKProfilePictureView *avatar = [[TSServerManager sharedManager]
                                       requestUserImageFromTheServerFacebook:cell.avatarUser ID:index];
    avatar.layer.cornerRadius = avatar.frame.size.width / 2;
    avatar.clipsToBounds = YES;
    [cell.orangeRectangle addSubview:avatar];
    
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
    
    [self.imageFriends addObject:idFriend];
    
    UIButton *button = [[UIButton alloc] init];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if (IS_IPHONE_4) {
            
        } else if (IS_IPHONE_5) {
            button.frame = CGRectMake(275.0f, 39.0f, 22.0f, 22.0f);
        } else if (IS_IPHONE_6) {
            button.frame = CGRectMake(323.0f, 46.0f, 26.0f, 26.0f);
        } else if (IS_IPHONE_6_PLUS) {
            
        }
    }
    
    button.tag = section;
    
    [button addTarget:self action:@selector(didSelectSection:) forControlEvents:UIControlEventTouchUpInside];
    [self.cell addSubview:button];
    
    return self.cell;
    
}


- (void)didSelectSection:(UIButton *)sender
{
    
    NSMutableDictionary *currentSection = [self.friends objectAtIndex:sender.tag];
    
    NSArray *items = [currentSection objectForKey:@"items"];
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (int i = 0; i < items.count; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:sender.tag]];
    }
    

    NSDictionary *currentDict = [self.friends objectAtIndex:sender.tag];
    
    self.currentID = [currentDict objectForKey:@"id"];
    
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
    CGFloat height;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if (IS_IPHONE_4) {
            
        } else if (IS_IPHONE_5) {
            height = 100;
        } else if (IS_IPHONE_6) {
            height = 118;
        } else if (IS_IPHONE_6_PLUS) {
            
        }
    }
    return height;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if (IS_IPHONE_4) {
            
        } else if (IS_IPHONE_5) {
            height = 67;
        } else if (IS_IPHONE_6) {
            height = 79;
        } else if (IS_IPHONE_6_PLUS) {
            
        }
    }
    return height;
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
