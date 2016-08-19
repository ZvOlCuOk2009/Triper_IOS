//
//  TSNewPostViewController.m
//  Triper_IOS
//
//  Created by Mac on 26.07.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//


#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue: b/255.0 alpha:1.0]
#define WHITE_COLOR RGB(175, 175, 175)
#define GRAY_COLOR RGB(65, 70, 80)

#define kOffsetForKeyboard 200

#import "TSNewPostViewController.h"
#import "TSView.h"
//#import "User.h"

@import Firebase;
@import FirebaseAuth;

@interface TSNewPostViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *bodyTextView;

@end

@implementation TSNewPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.ref = [[FIRDatabase database] reference];
    self.newref = [[FIRDatabase database] reference];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}


- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


#pragma mark - keyboard movements


- (void)keyboardWillShow:(NSNotification *)notification
{    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = - kOffsetForKeyboard;
        self.view.frame = f;
    }];
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = 0.0f;
        self.view.frame = f;
    }];
}


- (IBAction)actionBackPressed:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)didTapShare:(id)sender
{
    NSString *userID = [FIRAuth auth].currentUser.uid;
    
    [[[self.ref child:@"users"] child:userID] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        //User *user = [[User alloc] init];//
//        User *user = [[User alloc] initWithUsername:snapshot.value[@"username"]];
        NSString *username = @"Dima";
                
        NSLog(@"snapshot = %@", snapshot.value);
        
        [self writeNewPost:userID username:username title:self.titleTextField.text body:self.bodyTextView.text];
                
        if (![self.titleTextField.text isEqualToString:@""] && ![self.bodyTextView.text isEqualToString:@""]) {
            UIButton *button = nil;
            [self actionBackPressed:button];
        }
        
        NSLog(@"titleTextField = %@", self.titleTextField.text);
        NSLog(@"bodyTextView = %@", self.bodyTextView.text);
        
    } withCancelBlock:^(NSError * _Nonnull error) {
        
        NSLog(@"Error %@", error.localizedDescription);
    }];
    
}


- (void)writeNewPost:(NSString *)userID username:(NSString *)username title:(NSString *)title body:(NSString *)body
{
    NSString *key = [[[self.ref child:@"posts"] childByAutoId] key];
    NSDictionary *post = @{@"uid":userID,
                           @"author":username,
                           @"title":title,
                           @"body":body};
    
    NSDictionary *childUpdate = @{[@"/posts/" stringByAppendingString:key]:post, [NSString stringWithFormat:@"/user-posts/%@/%@/", userID, key]:post};
    
    [self.ref updateChildValues:childUpdate];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
