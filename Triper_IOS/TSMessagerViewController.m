//
//  TSMessagerViewController.m
//  Triper_IOS
//
//  Created by Mac on 27.07.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue: b/255.0 alpha:1.0]
#define ORANGE_COLOR RGB(255, 110, 50)

#import "TSMessagerViewController.h"
#import "TSSearchBar.h"
#import "TSView.h"
#import "TSServerManager.h"
#import "TSParsingManager.h"
#import "TSParsingUserName.h"

@import Firebase;
@import FirebaseDatabase;

@interface TSMessagerViewController () <JSQMessagesCollectionViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) FIRUser *user;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) FIRDatabaseReference *userIsTypingRef;
@property (strong, nonatomic) FIRDatabaseQuery *usersTypingQuery;

@property (strong, nonatomic) NSMutableArray <JSQMessage *> *messages;
@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageView;
@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageView;

@property (assign, nonatomic) BOOL localTyping;
@property (assign, nonatomic) BOOL isTyping;

@property (strong, nonatomic) NSString *outID;
@property (strong, nonatomic) NSArray *friends;

@end

@implementation TSMessagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self requestToServerFacebookListFriends];
    
    self.ref = [[FIRDatabase database] reference];
    self.messages = [NSMutableArray array];
    self.user = [FIRAuth auth].currentUser;
    
    self.usersTypingQuery = [self.ref queryOrderedByKey];
    
    self.senderId = self.user.uid;
    
    self.senderDisplayName = self.user.displayName;
    
    [self setupBubbles];
    
    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
    self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
    
    [self observeMessages];
    [self observeTyping];
    
    self.localTyping = NO;

    self.collectionView.contentInset = UIEdgeInsetsMake(36, 0, 44, 0);
    
    TSView *grayRect = [[TSView alloc] initWithView:self.view];
    [self.view addSubview:grayRect];
    
    UISearchBar *searchBar = [[TSSearchBar alloc] initWithView:self.view];
    [self.view addSubview:searchBar];
    
}


- (void)requestToServerFacebookListFriends
{
    [[TSServerManager sharedManager] requestUserFriendsTheServerFacebook:^(NSArray *friends)
     {
         self.friends = [TSParsingManager parsingFriendsFacebook:friends];
     }];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    //[cell.avatarImageView setImage:[UIImage imageNamed:@"placeholder_message"]];
    return cell;
}


- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [JSQMessagesAvatarImageFactory avatarImageWithUserInitials:@"av4"
                                                      backgroundColor:[UIColor blueColor]
                                                            textColor:[UIColor whiteColor]
                                                                 font:[UIFont systemFontOfSize:12.0]
                                                             diameter:30.0];
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
    JSQMessage * message = [JSQMessage messageWithSenderId:self.user.uid displayName:self.senderDisplayName text:text];
    [self.messages addObject:message];
    
    UIImage *placeHolderImage = [UIImage imageNamed:@"placeholder_message"];
    JSQMessagesAvatarImage *avatarMessage = [[JSQMessagesAvatarImage alloc] initWithAvatarImage:nil
                                                                               highlightedImage:nil
                                                                               placeholderImage:placeHolderImage];
    
    NSData *dataImage = [NSData dataWithContentsOfURL:self.user.photoURL];
    UIImage *imageFromData = [UIImage imageWithData:dataImage];
    UIImage *circularImage = [JSQMessagesAvatarImageFactory circularAvatarHighlightedImage:imageFromData
                                                                              withDiameter:kJSQMessagesCollectionViewAvatarSizeDefault];

    avatarMessage.avatarImage = circularImage;
    avatarMessage.avatarHighlightedImage = circularImage;
}


- (void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date
{
    FIRDatabaseReference *itemRef = [self.ref childByAutoId];
    NSDictionary *messageItem = @{@"text":text, @"senderId":senderId};
    NSLog(@"***SENDER ID*** - %@", senderId);
    
    [itemRef setValue:messageItem];
    [JSQSystemSoundPlayer jsq_playMessageSentSound];

    self.isTyping = NO;
}


- (void)observeMessages
{
    FIRDatabaseQuery *messagesQuery = [self.ref queryLimitedToLast:20];
    [messagesQuery observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        NSString *ID = snapshot.value[@"senderID"];
        NSString *text = snapshot.value[@"text"];

//        [self addMessage:ID text:text];
        [self finishReceivingMessageAnimated:YES];
    }];
}


- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    
    if ([message.senderId isEqualToString:self.senderId])
    {
        return nil;
    }
    
    if (indexPath.item - 1 > 0)
    {
        JSQMessage *previousMessage = [self.messages objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:message.senderId]) {
            return nil;
        }
    }
    
    NSLog(@"Sender Display Name:%@",[[NSAttributedString alloc] initWithString:self.senderDisplayName]);
    
    return [[NSAttributedString alloc] initWithString:self.senderDisplayName];
}


- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}


- (void)textViewDidChange:(UITextView *)textView
{
    [super textViewDidChange:textView];
    
    if (self.isTyping) {
        NSLog(@"ПЕЧТАЕТ!!!");
    }
}


- (void)observeTyping
{
    FIRDatabaseReference *typingIndicatorRef = [self.ref child:@"typingIndicator"];
    self.userIsTypingRef = [typingIndicatorRef child:self.user.uid];
    [self.userIsTypingRef onDisconnectRemoveValue];
    
    //self.usersTypingQuery = [typingIndicatorRef.queryOrderedByValue queryEqualToValue:];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
