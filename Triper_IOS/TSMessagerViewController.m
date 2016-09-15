//
//  TSMessagerViewController.m
//  Triper_IOS
//
//  Created by Mac on 27.07.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSMessagerViewController.h"
#import "TSSearchBar.h"
#import "TSView.h"
#import "TSServerManager.h"
#import "TSParsingManager.h"
#import "TSParsingUserName.h"
#import "TSFireUser.h"
#import "TSRetriveFriendsFBDatabase.h"
#import "TSPrefixHeader.pch"

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
    
    
    [self configureTheCurrentChat];
    
    
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
    
    
    self.view.frame = CGRectMake(0, 30, self.view.frame.size.width, self.view.frame.size.height);
    
    TSView *grayRect = [[TSView alloc] initWithView:self.view];
    [self.view addSubview:grayRect];
    
    UISearchBar *searchBar = [[TSSearchBar alloc] initWithView:self.view];
    [self.view addSubview:searchBar];
    
}


- (void)configureTheCurrentChat
{
    
    [self.ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        self.friends = [TSRetriveFriendsFBDatabase retriveFriendsDatabase:snapshot];
        self.fireUser = [TSFireUser initWithSnapshot:snapshot];
        
        NSURL *url = [NSURL URLWithString:self.fireUser.photoURL];
        NSData *dataImage = [NSData dataWithContentsOfURL:url];
        self.userImage = [UIImage imageWithData:dataImage];
        
        
        if (!self.interlocutor) {
            
            if (self.friends.count > 0) {
                
                NSDictionary *temporaryDict = [self.friends objectAtIndex:0];
                NSString * temporaryID = [temporaryDict objectForKey:@"fireUserID"];
                self.interlocutor = temporaryID;
            } else {
                self.interlocutor = @"";
            }
            
        }
        
        [self getImageInterlocutor:self.friends];
        
        if (![self.interlocutor isEqualToString:@""]) {
            
            self.messageRefUser = [[[self.ref child:self.user.uid] child:@"chat"] child:self.interlocutor];
            self.messageRefInterlocutor = [[[self.ref child:self.interlocutor] child:@"chat"] child:self.user.uid];
        }
        
    }];
    
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


-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
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
        
        if (self.userImage) {
            userImage = self.userImage;
        } else {
            userImage = [UIImage imageNamed:@"placeholder_message"];
        }
        
        return [JSQMessagesAvatarImageFactory avatarImageWithImage:userImage
                                                          diameter:60];
    } else {
        
        UIImage *interlocutorImage = nil;
        
        if (self.interlocutorImage) {
            interlocutorImage = self.interlocutorImage;
        } else {
            interlocutorImage = [UIImage imageNamed:@"placeholder_message"];
        }
       
        return [JSQMessagesAvatarImageFactory avatarImageWithImage:interlocutorImage
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
    
    self.collectionView.contentInset = UIEdgeInsetsMake(40, 0, 40, 0);
    
    JSQMessagesComposerTextView *textView = self.inputToolbar.contentView.textView;
    textView.text = @"";
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


- (void)textViewDidChange:(UITextView *)textView
{
    [super textViewDidChange:textView];
    
    if (self.isTyping) {
        NSLog(@"ПЕЧТАЕТ!!!");
    }
}


#pragma mark - Notification


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


/*
- (void)observeTyping
{
    
    FIRDatabaseReference *typingIndicatorRef = [self.ref child:@"typingIndicator"];
    self.userIsTypingRef = [typingIndicatorRef child:self.user.uid];
    [self.userIsTypingRef onDisconnectRemoveValue];
    
    //self.usersTypingQuery = [typingIndicatorRef.queryOrderedByValue queryEqualToValue:];
}
*/

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
