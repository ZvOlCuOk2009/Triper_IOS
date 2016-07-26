//
//  TSNewPostViewController.h
//  Triper_IOS
//
//  Created by Mac on 26.07.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import <UIKit/UIKit.h>

@import FirebaseDatabase;

@interface TSNewPostViewController : UIViewController

@property(strong, nonatomic) FIRDatabaseReference *ref;

@end
