 //
//  TSContainerChatViewController.m
//  Triper_IOS
//
//  Created by Mac on 29.07.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue: b/255.0 alpha:1.0]
#define WHITE_COLOR RGB(175, 175, 175)
#define GRAY_COLOR RGB(65, 70, 80)

#import "TSContainerChatViewController.h"
#import "TSServerManager.h"
#import "TSChatViewController.h"

@interface TSContainerChatViewController ()

@property (weak, nonatomic) IBOutlet UIView *messageView;
@property (weak, nonatomic) IBOutlet UIView *profileView;
@property (weak, nonatomic) IBOutlet UIView *contactsView;

@property (weak, nonatomic) IBOutlet UIButton *messageButton;
@property (weak, nonatomic) IBOutlet UIButton *profileButton;
@property (weak, nonatomic) IBOutlet UIButton *contactsButton;

@end

@implementation TSContainerChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.messageButton.layer.cornerRadius = 3;
    self.messageButton.layer.borderWidth = 1;
    self.messageButton.layer.borderColor = GRAY_COLOR.CGColor;
    
    self.profileButton.layer.cornerRadius = 3;
    self.profileButton.layer.borderWidth = 1;
    self.profileButton.layer.borderColor = GRAY_COLOR.CGColor;
    
    self.contactsButton.layer.cornerRadius = 3;
    self.contactsButton.layer.borderWidth = 1;
    self.contactsButton.layer.borderColor = WHITE_COLOR.CGColor;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Actions


- (IBAction)actionNavigationButton:(UIButton *)sender
{
    switch (sender.tag) {
        case 0:
            self.messageView.alpha = 1;
            self.profileView.alpha = 0;
            self.contactsView.alpha = 0;
            
            self.messageButton.layer.borderColor = WHITE_COLOR.CGColor;
            self.profileButton.layer.borderColor = GRAY_COLOR.CGColor;
            self.contactsButton.layer.borderColor = GRAY_COLOR.CGColor;
            
            break;
        case 1:
            self.messageView.alpha = 0;
            self.profileView.alpha = 1;
            self.contactsView.alpha = 0;
        
            self.profileButton.layer.borderColor = WHITE_COLOR.CGColor;
            self.messageButton.layer.borderColor = GRAY_COLOR.CGColor;
            self.contactsButton.layer.borderColor = GRAY_COLOR.CGColor;
            [self.view endEditing:YES];
            
            break;
        case 2:
            self.messageView.alpha = 0;
            self.profileView.alpha = 0;
            self.contactsView.alpha = 1;
      
            self.contactsButton.layer.borderColor = WHITE_COLOR.CGColor;
            self.messageButton.layer.borderColor = GRAY_COLOR.CGColor;
            self.profileButton.layer.borderColor = GRAY_COLOR.CGColor;
            [self.view endEditing:YES];
            
        default:
            break;
    }
}


- (void)callActionButtonNavigation
{
//    [self performSegueWithIdentifier:@"chatIdent" sender:nil];
}



@end
