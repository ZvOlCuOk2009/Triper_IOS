  //
//  TSMenuViewController.m
//  Triper_IOS
//
//  Created by Mac on 30.06.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSMenuViewController.h"
#import "TSMenuTableViewCell.h"
#import "TSHomeViewController.h"
#import "SWRevealViewController.h"
#import "TSCardViewController.h"
#import "TSHomeViewController.h"
#import "TSServerManager.h"
#import "TSButton.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface TSMenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *sections;
@property (strong, nonatomic) TSUser *currentUser;

@end

@implementation TSMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray *home = @[];
    NSArray *explore = @[@"Settings", @"Map", @"Find friends"];
    NSArray *myTriper = @[@"Profile", @"Card", @"Account"];
    NSArray *tools = @[@"Contact", @"Board", @"Calendar"];
    
    NSMutableDictionary *homeSection = [NSMutableDictionary dictionary];
    [homeSection setObject:home forKey:@"items"];
    [homeSection setObject:@"Home" forKey:@"title"];
    [homeSection setObject:@"home" forKey:@"image"];
    
    NSMutableDictionary *exploreSection = [NSMutableDictionary dictionary];
    [exploreSection setObject:explore forKey:@"items"];
    [exploreSection setObject:@"Explore" forKey:@"title"];
    [exploreSection setObject:@"explore" forKey:@"image"];
    
    NSMutableDictionary *myTriperSection = [NSMutableDictionary dictionary];
    [myTriperSection setObject:myTriper forKey:@"items"];
    [myTriperSection setObject:@"My Triper" forKey:@"title"];
    [myTriperSection setObject:@"mytriper" forKey:@"image"];
    
    NSMutableDictionary *toolsSection = [NSMutableDictionary dictionary];
    [toolsSection setObject:tools forKey:@"items"];
    [toolsSection setObject:@"Tools" forKey:@"title"];
    [toolsSection setObject:@"tools" forKey:@"image"];
    
    self.sections = @[homeSection, exploreSection, myTriperSection, toolsSection];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    FBSDKProfilePictureView *avatar = [[TSServerManager sharedManager]
                                       requestUserImageFromTheServerFacebook:self.avatarImageView];
    avatar.layer.cornerRadius = avatar.frame.size.width / 2;
    avatar.clipsToBounds = YES;
    [self.view addSubview:avatar];
    
    [[TSServerManager sharedManager] requestUserDataFromTheServerFacebook:^(TSUser *user) {
        if (user) {
            self.nameLabel.text = [NSString stringWithFormat:@"Hi, %@", user.name];
        } else {
            
        }
    }];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
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
    static NSString *cellIdentifier = @"detail";
    
    TSMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[TSMenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *currentSection = [self.sections objectAtIndex:indexPath.section];

    NSArray *items = [currentSection objectForKey:@"items"];
    NSString *currentItem = [items objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = currentItem;
    cell.iconImageView.image = [UIImage imageNamed:@"arrow_go"];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDictionary *currentSection = [self.sections objectAtIndex:section];
    NSString *sectionTitle = [currentSection objectForKey:@"title"];
    NSString *image = [currentSection objectForKey:@"image"];
    
    CGRect frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 50.0f);
    TSButton *button = [[TSButton alloc] initWithFrame:frame title:sectionTitle icon:image];
    button.tag = section;
    [button addTarget:self action:@selector(didSelectSection:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)didSelectSection:(TSButton *)sender {
    
    if (sender.tag == 0) {
        [self performSegueWithIdentifier:@"homeIdent" sender:sender];
    }
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        
        [self performSegueWithIdentifier:@"settingsIdent" sender:self];
        
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        
        [self performSegueWithIdentifier:@"settingsIdent" sender:self];
        
    } else if (indexPath.section == 1 && indexPath.row == 2) {
        
        [self performSegueWithIdentifier:@"findFriendsIdent" sender:self];
        
    } else if (indexPath.section == 2 && indexPath.row == 0) {
        
        [self performSegueWithIdentifier:@"profileIdent" sender:self];
        
    } else if (indexPath.section == 2 && indexPath.row == 1) {
        
        [self performSegueWithIdentifier:@"cardIdent" sender:self]; 
        
    } else if (indexPath.section == 2 && indexPath.row == 2) {
        
        [self performSegueWithIdentifier:@"accountIdent" sender:self];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

#pragma mark - Actions

- (IBAction)actionLogOut:(id)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Вы хотите выйти"
                                                                             message:@"из приложения?"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actionYes = [UIAlertAction actionWithTitle:@"Да"
                                                        style:UIAlertActionStyleDestructive
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          [[TSServerManager sharedManager] logOutFacebook];
                                                          [self performSegueWithIdentifier:@"logOutFacebookIdent" sender:self];
                                                      }];
    
    UIAlertAction *actionNo = [UIAlertAction actionWithTitle:@"Нет"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) { }];
    
    [alertController addAction:actionYes];
    [alertController addAction:actionNo];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

/*
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue isKindOfClass:[SWRevealViewControllerSegue class]]) {

        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc,UIViewController* dvc){

            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers:@[dvc] animated:NO];
            [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
        };
    }
}
 */

@end
