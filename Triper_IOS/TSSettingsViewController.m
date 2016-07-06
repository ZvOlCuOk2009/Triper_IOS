//
//  TSSettingsViewController.m
//  Triper_IOS
//
//  Created by Mac on 01.07.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue: b/255.0 alpha:1.0]
#define BORDER_COLOR RGB(115, 115, 115)

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
    
    self.title = @"Settings";
    
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
