//
//  TSChatViewController.m
//  Triper_IOS
//
//  Created by Mac on 08.07.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSChatViewController.h"
#import "TSUserViewController.h"
#import "TSMenuTableViewCell.h"
#import "TSButton.h"
#import "TSCellView.h"
#import "TSServerManager.h"

@import Firebase;
@import FirebaseDatabase;

@interface TSChatViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *sections;
@property (strong, nonatomic) TSCellView *cell;
@property (strong, nonatomic) FIRDatabaseReference *ref;

@end

@implementation TSChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.sections = [NSMutableArray array];
    
    NSArray *user1 = [NSArray arrayWithObjects:@"Amanda", nil];
    NSArray *user2 = [NSArray arrayWithObjects:@"Tom", nil];
    NSArray *user3 = [NSArray arrayWithObjects:@"John", nil];
    NSArray *user4 = [NSArray arrayWithObjects:@"Tony", nil];
    
    
    NSMutableDictionary *user1Section = [NSMutableDictionary dictionary];
    [user1Section setObject:user1 forKey:@"items"];
//    [user1Section setObject:@"user1" forKey:@"title"];
    
    NSMutableDictionary *user2Section = [NSMutableDictionary dictionary];
    [user2Section setObject:user2 forKey:@"items"];
//    [user2Section setObject:@"user2" forKey:@"title"];
    
    
    NSMutableDictionary *user3Section = [NSMutableDictionary dictionary];
    [user3Section setObject:user3 forKey:@"items"];
    //    [user3Section setObject:@"user3" forKey:@"title"];
    
    NSMutableDictionary *user4Section = [NSMutableDictionary dictionary];
    [user4Section setObject:user4 forKey:@"items"];
    //    [user4Section setObject:@"user4" forKey:@"title"];
    
    [self.sections addObject:user1Section];
    [self.sections addObject:user2Section];
    [self.sections addObject:user3Section];
    [self.sections addObject:user4Section];

    self.ref = [[FIRDatabase database] reference];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)actionProfileButton:(UIButton *)sender
{
    TSUserViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TSUserViewController"];
    [self presentViewController:controller animated:YES completion:nil];
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
    [_ref updateChildValues:childUpdates];
    
    NSLog(@"key = %@", key);
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *currentSection = [self.sections objectAtIndex:section];
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
    
//    NSDictionary *currentSection = [self.sections objectAtIndex:indexPath.section];
//    NSArray *items = [currentSection objectForKey:@"items"];
//    NSString *currentItem = [items objectAtIndex:indexPath.row];
    
    self.cell = [TSCellView cellView];
    
    UIImage *image = [self.cell avatarImage];

    cell.avatarUser.image = image;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    self.cell = [TSCellView cellView];
    
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(275.0f, 39.0f, 22.0f, 22.0f);
    button.tag = section;
    
    [button addTarget:self action:@selector(didSelectSection:) forControlEvents:UIControlEventTouchUpInside];
    [self.cell addSubview:button];
    
    return self.cell;
}

- (void)didSelectSection:(UIButton *)sender {
    
    NSLog(@"TAG %ld", (long)sender.tag);

    NSMutableDictionary *currentSection = [self.sections objectAtIndex:sender.tag];

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
