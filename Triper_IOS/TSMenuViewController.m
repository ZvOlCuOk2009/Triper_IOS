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
#import "TSHomeNavigationController.h"
#import "SWRevealViewController.h"
#import "TSCardNavigationController.h"
#import "TSCardViewController.h"
#import "TSButton.h"

@interface TSMenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) NSArray *insertIndexPaths;
@property (assign, nonatomic) BOOL isPressed;
@property (strong, nonatomic) TSUser *currentUser;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *sections;

@end

@implementation TSMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"SELF CURRENTUSER = %@", self.currentUser);
    
    self.isPressed = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.nameLabel.text = [NSString stringWithFormat:@"Hi, %@ %@", self.currentUser.firstName, self.currentUser.lastName];
    NSData *imageData = [NSData dataWithContentsOfURL:self.currentUser.avatar];
    self.avatarImageView.image = [UIImage imageWithData:imageData];
    
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

- (void)receiveUserData:(TSUser *)user
{
    self.currentUser = user;
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
    //return self.testStudents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSString *ident = [self.homeCell objectAtIndex:indexPath.row];
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident forIndexPath:indexPath];
//    
//    return  cell;
    
    //static NSString *sectionIdentifier = @"Cell";
    static NSString *cellIdentifier = @"detail";
    
    
    TSMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[TSMenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *currentSection = [self.sections objectAtIndex:indexPath.section];
    //NSDictionary *currentCell = [self.sections objectAtIndex:indexPath.row];

    NSArray *items = [currentSection objectForKey:@"items"];
    NSString *currentItem = [items objectAtIndex:indexPath.row];
    
    
    cell.titleLabel.text = currentItem;
    cell.iconImageView.image = [UIImage imageNamed:@"arrow_go"];
    
    //cell.textLabel.text = currentItem;
    
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


//-(void)buttonizeButtonTap:(id)sender{
//
//}

- (void)didSelectSection:(UIButton*)sender {
    
    if (sender.tag == 0) {
        [self performSegueWithIdentifier:@"homeIdent" sender:sender];
    }
    //Получение текущей секции
    NSMutableDictionary *currentSection = [self.sections objectAtIndex:sender.tag];
    NSLog(@"SENDER = %ld", sender.tag);
    //Получение элементов секции
    NSArray *items = [currentSection objectForKey:@"items"];
    
    //Создание массива индексов
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (int i = 0; i < items.count; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:sender.tag]];
    }
    
    //Получение состояния секции
    BOOL isOpen = [[currentSection objectForKey:@"isOpen"] boolValue];
    
    //Установка нового состояния
    [currentSection setObject:[NSNumber numberWithBool:!isOpen] forKey:@"isOpen"];
    
    //Анимированное добавление или удаление ячеек секции
    if (isOpen) {
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
    } else {
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 2 && indexPath.row == 0) {
        
        [self performSegueWithIdentifier:@"profileIdent" sender:self];
        
    } else if (indexPath.section == 2 && indexPath.row == 1) {
        
        [self performSegueWithIdentifier:@"cardIdent" sender:self]; 
        
    } else if (indexPath.section == 2 && indexPath.row == 2) {
        
        [self performSegueWithIdentifier:@"accountIdent" sender:self];
    }
    
    
    
    NSLog(@"INDEX PATH SECTION = %ld ROW = %ld", indexPath.section, indexPath.row);
}

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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

@end
