//
//  TSHomeViewController.h
//  Triper_IOS
//
//  Created by Mac on 02.07.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSUser.h"

@interface TSHomeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton;

- (void)receiveUserData:(TSUser *)user;

@end
