//
//  TSSettingsViewController.m
//  Triper_IOS
//
//  Created by Mac on 01.07.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSSettingsViewController.h"

@interface TSSettingsViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *iamSegmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *lokingSegmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *categorySegmentedControl;
@property (weak, nonatomic) IBOutlet UITextField *interestTextField;

@end

@implementation TSSettingsViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
        
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIColor blackColor]forKey:NSForegroundColorAttributeName];
    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:[UIColor orangeColor] forKey:NSForegroundColorAttributeName];
    
    [self.iamSegmentedControl setTitleTextAttributes:highlightedAttributes forState:UIControlStateSelected];
    [self.iamSegmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    [self.lokingSegmentedControl setTitleTextAttributes:highlightedAttributes forState:UIControlStateSelected];
    [self.lokingSegmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    [self.categorySegmentedControl setTitleTextAttributes:highlightedAttributes forState:UIControlStateSelected];
    [self.categorySegmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
        
    self.interestTextField.layer.borderColor = UIColor.lightGrayColor.CGColor;
    self.interestTextField.layer.borderWidth = 1;
    self.interestTextField.layer.masksToBounds = YES;
}

@end
