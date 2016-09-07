//
//  TSMessagerViewController.m
//  Triper_IOS
//
//  Created by Mac on 27.07.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue: b/255.0 alpha:1.0]
#define ORANGE_COLOR RGB(255, 110, 50)

#define IS_IPHONE_4 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)480) < DBL_EPSILON)
#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)568) < DBL_EPSILON)
#define IS_IPHONE_6 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)667) < DBL_EPSILON)
#define IS_IPHONE_6_PLUS (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)736) < DBL_EPSILON)

#import "TSMessagerViewController.h"
#import "TSSearchBar.h"
#import "TSView.h"
#import "TSServerManager.h"
#import "TSParsingManager.h"
#import "TSParsingUserName.h"
#import "TSFireUser.h"
#import "TSRetriveFriendsFBDatabase.h"

@import Firebase;
@import FirebaseDatabase;

@interface TSMessagerViewController () <JSQMessagesCollectionViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) FIRUser *user;
@property (strong, nonatomic) TSFireUser *fireUser;
@property (strong, nonatomic) NSString *interlocutor;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) FIRDatabaseReference *messageRefUser;
@property (strong, nonatomic) FIRDatabaseReference *messageRefInterlocutor;
@property (strong, nonatomic) NSMutableArray *friends;
@property (strong, nonatomic) FIRDatabaseQuery *usersTypingQuery;

@property (strong, nonatomic) NSMutableArray <JSQMessage *> *messages;
@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageView;
@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageView;

@property (strong, nonatomic) UIImage *interlocutorImage;
@property (strong, nonatomic) UIImage *userImage;

@property (assign, nonatomic) BOOL localTyping;
@property (assign, nonatomic) BOOL isTyping;

@end

@implementation TSMessagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.ref = [[FIRDatabase database] reference];
    self.user = [FIRAuth auth].currentUser;
    self.messages = [NSMutableArray array];
    
    
    [self.ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {

        self.friends = [TSRetriveFriendsFBDatabase retriveFriendsDatabase:snapshot];
        self.fireUser = [TSFireUser initWithSnapshot:snapshot];
        
        NSURL *url = [NSURL URLWithString:self.fireUser.photoURL];
        NSData *dataImage = [NSData dataWithContentsOfURL:url];
        self.userImage = [UIImage imageWithData:dataImage];
        
        if (!self.interlocutor) {
            NSDictionary *temporaryDict = [self.friends objectAtIndex:0];
            NSString * temporaryID = [temporaryDict objectForKey:@"fireUserID"];
            self.interlocutor = temporaryID;
        }
        
        [self getImageInterlocutor:self.friends];
        
        self.messageRefUser = [[[self.ref child:self.user.uid] child:@"chat"] child:self.interlocutor];
        self.messageRefInterlocutor = [[[self.ref child:self.interlocutor] child:@"chat"] child:self.user.uid];
    }];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transferToInterlocutor:) name:@"noticeOnTheMethodCall" object:nil];
    
    
    NSLog(@"interlocutor %@", self.interlocutor);
    
    
    self.senderId = self.user.uid;
    self.senderDisplayName = self.user.displayName;
    self.usersTypingQuery = [self.ref queryOrderedByKey];

    CGSize rect = CGSizeMake(35, 35);
    
    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = rect;
    self.collectionView.collectionViewLayout.incomingAvatarViewSize = rect;

    
    [self setupBubbles];
    
    
    self.localTyping = NO;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if (IS_IPHONE_4) {
            self.view.frame = CGRectMake(0, 0, 320, 568);
        } else if (IS_IPHONE_5) {
            self.view.frame = CGRectMake(0, 0, 320, 568);
        } else if (IS_IPHONE_6) {
            self.view.frame = CGRectMake(0, 0, 375, 667);
        } else if (IS_IPHONE_6_PLUS) {
            self.view.frame = CGRectMake(0, 0, 414, 736);
        }
    }
    
    
    TSView *grayRect = [[TSView alloc] initWithView:self.view];
    [self.view addSubview:grayRect];
    
    UISearchBar *searchBar = [[TSSearchBar alloc] initWithView:self.view];
    [self.view addSubview:searchBar];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.collectionView.contentInset = UIEdgeInsetsMake(40, 0, 40, 0);
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self observeMessages];
    
}


- (void)getImageInterlocutor:(NSMutableArray *)friends
{
    for (NSDictionary *data in friends) {
        NSString *ID = [data objectForKey:@"fireUserID"];
        if ([ID isEqualToString:self.interlocutor]) {
            NSString *urlString = [data objectForKey:@"photoURL"];
            NSURL *url = [NSURL URLWithString:urlString];
            NSData *dataImage = [NSData dataWithContentsOfURL:url];
            self.interlocutorImage = [UIImage imageWithData:dataImage];
        }
    }
}


- (void)getImageUser
{
    
    [self.ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        self.fireUser = [TSFireUser initWithSnapshot:snapshot];
        NSURL *url = [NSURL URLWithString:self.fireUser.photoURL];
        NSData *dataImage = [NSData dataWithContentsOfURL:url];
        self.userImage = [UIImage imageWithData:dataImage];
    }];
    
}


#pragma mark - JSQMessagesCollectionViewDataSource


- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.messages[indexPath.item];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.messages.count;
}


- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    if ([message.senderId isEqualToString:self.senderId]) {
        return self.outgoingBubbleImageView;
    } else {
        return self.incomingBubbleImageView;
    }
    
}


- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    JSQMessage *message = self.messages[indexPath.item];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        cell.textView.textColor = [UIColor whiteColor];
    } else {
        cell.textView.textColor = [UIColor blackColor];
    }

    return cell;
    
}


- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{

    JSQMessage *message = self.messages[indexPath.item];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        
        UIImage *userImage = nil;
        
        if (!self.userImage) {
            userImage = [UIImage imageNamed:@"av4"];
        } else {
            userImage = self.userImage;
        }
        
        return [JSQMessagesAvatarImageFactory avatarImageWithImage:userImage
                                                          diameter:60];
    } else {
       
        return [JSQMessagesAvatarImageFactory avatarImageWithImage:self.interlocutorImage
                                                          diameter:60];
    }
    
}


- (void)setupBubbles
{
    
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    self.outgoingBubbleImageView = [bubbleFactory outgoingMessagesBubbleImageWithColor:
                                    ORANGE_COLOR];
    self.incomingBubbleImageView = [bubbleFactory incomingMessagesBubbleImageWithColor:
                                    [UIColor jsq_messageBubbleLightGrayColor]];
    
}


- (void)addMessage:(NSString *)idString text:(NSString *)text
{
    
    JSQMessage * message = [JSQMessage messageWithSenderId:idString displayName:self.senderDisplayName text:text];
    [self.messages addObject:message];
    
}


- (void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date
{
    
    FIRDatabaseReference *itemRefUser = [self.messageRefUser childByAutoId];
    FIRDatabaseReference *itemRefInterlocutor = [self.messageRefInterlocutor childByAutoId];
    
    NSDictionary *messageItem = @{@"text":text, @"senderId":senderId};
    
    [itemRefUser setValue:messageItem];
    [itemRefInterlocutor setValue:messageItem];
    
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    
}


- (void)observeMessages
{
    
    FIRDatabaseQuery *messagesQuery = [self.messageRefUser queryLimitedToLast:20];
    [messagesQuery observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        NSString *ID = snapshot.value[@"senderId"];
        NSString *text = snapshot.value[@"text"];
        
        [self addMessage:ID text:text];
        [self finishReceivingMessageAnimated:YES];
    }];
    
}


- (void)transferToInterlocutor:(NSNotification *)notification
{
    
    [self.messages removeAllObjects];
    self.interlocutor = [notification object];
    
    self.messageRefUser = [[[self.ref child:self.user.uid] child:@"chat"] child:self.interlocutor];
    self.messageRefInterlocutor = [[[self.ref child:self.interlocutor] child:@"chat"] child:self.user.uid];
    
    [self getImageInterlocutor:self.friends];
    [self observeMessages];
    
    NSLog(@"Message %@", self.interlocutor);
    
}


- (void)textViewDidChange:(UITextView *)textView
{
    [super textViewDidChange:textView];
    
    if (self.isTyping) {
        NSLog(@"ПЕЧТАЕТ!!!");
    }
}


//- (void)observeTyping
//{
//    
//    FIRDatabaseReference *typingIndicatorRef = [self.ref child:@"typingIndicator"];
//    self.userIsTypingRef = [typingIndicatorRef child:self.user.uid];
//    [self.userIsTypingRef onDisconnectRemoveValue];
//    
//    //self.usersTypingQuery = [typingIndicatorRef.queryOrderedByValue queryEqualToValue:];
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
