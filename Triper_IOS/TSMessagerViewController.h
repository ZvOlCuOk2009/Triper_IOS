//
//  TSMessagerViewController.h
//  Triper_IOS
//
//  Created by Mac on 27.07.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JSQMessagesViewController/JSQMessages.h>
#import "TSChatViewController.h"

@interface TSMessagerViewController : JSQMessagesViewController

@property (strong, nonatomic) NSString *twoUserID;

@end
