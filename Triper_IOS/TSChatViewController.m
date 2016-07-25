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

@import Firebase;

@interface TSChatViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *sections;
@property (strong, nonatomic) TSCellView *cell;

@end

@implementation TSChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.sections = [NSMutableArray array];
    
    NSArray *girls = [NSArray arrayWithObjects:@"Amanda", nil];
    NSArray *boys = [NSArray arrayWithObjects:@"Tom", nil];
    NSArray *cats = [NSArray arrayWithObjects:@"Tima", nil];
    NSArray *dogs = [NSArray arrayWithObjects:@"Clyde", nil];
    
    
    NSMutableDictionary *girlsSection = [NSMutableDictionary dictionary];
    [girlsSection setObject:girls forKey:@"items"];
//    [girlsSection setObject:@"Girls" forKey:@"title"];
    
    NSMutableDictionary *boysSection = [NSMutableDictionary dictionary];
    [boysSection setObject:boys forKey:@"items"];
//    [boysSection setObject:@"Boys" forKey:@"title"];
    
    
    NSMutableDictionary *catsSection = [NSMutableDictionary dictionary];
    [catsSection setObject:cats forKey:@"items"];
    //    [girlsSection setObject:@"Girls" forKey:@"title"];
    
    NSMutableDictionary *dogsSection = [NSMutableDictionary dictionary];
    [dogsSection setObject:dogs forKey:@"items"];
    //    [boysSection setObject:@"Boys" forKey:@"title"];
    
    [self.sections addObject:girlsSection];
    [self.sections addObject:boysSection];
    [self.sections addObject:catsSection];
    [self.sections addObject:dogsSection];

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
    
    NSLog(@"TAG %ld", sender.tag);
    //Получение текущей секции
    NSMutableDictionary *currentSection = [self.sections objectAtIndex:sender.tag];
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
