//
//  TSAccountViewController.m
//  Triper_IOS
//
//  Created by Mac on 24.06.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSAccountViewController.h"

@interface TSAccountViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *showSegmentedControll;

@end

@implementation TSAccountViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Account";
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIColor blackColor]forKey:NSForegroundColorAttributeName];
    [self.showSegmentedControll setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:[UIColor orangeColor] forKey:NSForegroundColorAttributeName];
    [self.showSegmentedControll setTitleTextAttributes:highlightedAttributes forState:UIControlStateSelected];
}

@end
