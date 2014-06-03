//
//  YDMessageTableViewController.m
//  YourDay
//
//  Created by Andy Mai on 5/11/14.
//  Copyright (c) 2014 ChillBear. All rights reserved.
//

#import "YDMessageTableViewController.h"

#import "XHDisplayTextViewController.h"
#import "XHDisplayMediaViewController.h"
#import "XHDisplayLocationViewController.h"
#import "XHProfileTableViewController.h"

#import "NSStrinAdditions.h"

#import <Firebase/Firebase.h>

@interface YDMessageTableViewController ()
@property (nonatomic, strong) NSArray *emotionManagers;
@property (nonatomic, strong) Firebase *firebase;

@end

@implementation YDMessageTableViewController

NSUInteger count = 0;

- (XHMessage *)getTextMessageWithBubbleMessageType:(XHBubbleMessageType)bubbleMessageType {
    XHMessage *textMessage = [[XHMessage alloc] initWithText:@"Hello World" sender:@"Tom" timestamp:[NSDate distantPast]];
    //textMessage.avator = [UIImage imageNamed:@"avator"];
    //textMessage.avatorUrl = @"http://www.stanleytang.com/wp-content/uploads/2012/11/photo-new-300x346.jpg";
    textMessage.bubbleMessageType = bubbleMessageType;
    
    return textMessage;
}

- (XHMessage *)getPhotoMessageWithBubbleMessageType:(XHBubbleMessageType)bubbleMessageType {
    XHMessage *photoMessage = [[XHMessage alloc] initWithPhoto:[UIImage imageNamed:@"placeholderImage"] thumbnailUrl:@"http://jenniferfigge.com/wp-content/uploads/2010/12/cabo-san-lucas.jpg" originPhotoUrl:nil sender:@"Jack" timestamp:[NSDate date]];
    photoMessage.avator = [UIImage imageNamed:@"avator"];
    photoMessage.avatorUrl = @"http://www.stanleytang.com/wp-content/uploads/2012/11/photo-new-300x346.jpg";
    photoMessage.bubbleMessageType = bubbleMessageType;
    
    return photoMessage;
}

- (XHMessage *)getVideoMessageWithBubbleMessageType:(XHBubbleMessageType)bubbleMessageType {
    NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"IMG_1555.MOV" ofType:@""];
    XHMessage *videoMessage = [[XHMessage alloc] initWithVideoConverPhoto:[XHMessageVideoConverPhotoFactory videoConverPhotoWithVideoPath:videoPath] videoPath:videoPath videoUrl:nil sender:@"Jayson" timestamp:[NSDate date]];
    videoMessage.avator = [UIImage imageNamed:@"avator"];
    videoMessage.avatorUrl = @"http://www.stanleytang.com/wp-content/uploads/2012/11/photo-new-300x346.jpg";
    videoMessage.bubbleMessageType = bubbleMessageType;
    
    return videoMessage;
}

- (XHMessage *)getVoiceMessageWithBubbleMessageType:(XHBubbleMessageType)bubbleMessageType {
    XHMessage *voiceMessage = [[XHMessage alloc] initWithVoicePath:nil voiceUrl:nil sender:@"Jayson" timestamp:[NSDate date]];
    voiceMessage.avator = [UIImage imageNamed:@"avator"];
    voiceMessage.avatorUrl = @"http://www.stanleytang.com/wp-content/uploads/2012/11/photo-new-300x346.jpg";
    voiceMessage.bubbleMessageType = bubbleMessageType;
    
    return voiceMessage;
}

- (XHMessage *)getEmotionMessageWithBubbleMessageType:(XHBubbleMessageType)bubbleMessageType {
    XHMessage *emotionMessage = [[XHMessage alloc] initWithEmotionPath:[[NSBundle mainBundle] pathForResource:@"Demo0.gif" ofType:nil] sender:@"Jayson" timestamp:[NSDate date]];
    emotionMessage.avator = [UIImage imageNamed:@"avator"];
    emotionMessage.avatorUrl = @"http://www.stanleytang.com/wp-content/uploads/2012/11/photo-new-300x346.jpg";
    emotionMessage.bubbleMessageType = bubbleMessageType;
    
    return emotionMessage;
}

- (XHMessage *)getGeolocationsMessageWithBubbleMessageType:(XHBubbleMessageType)bubbleMessageType {
    XHMessage *localPositionMessage = [[XHMessage alloc] initWithLocalPositionPhoto:[UIImage imageNamed:@"Fav_Cell_Loc"] geolocations:@"中国广东省广州市天河区东圃二马路121号" location:[[CLLocation alloc] initWithLatitude:23.110387 longitude:113.399444] sender:@"Jack" timestamp:[NSDate date]];
    localPositionMessage.avator = [UIImage imageNamed:@"avator"];
    localPositionMessage.avatorUrl = @"http://www.pailixiu.com/jack/meIcon@2x.png";
    localPositionMessage.bubbleMessageType = bubbleMessageType;
    
    return localPositionMessage;
}

- (Firebase *)firebase
{
    if (!_firebase) {
        self.userName = [self.userName stringByReplacingOccurrencesOfString:@" " withString: @"_"];
        NSString *firebaseURL = @"https://dazzling-fire-7228.firebaseio.com/";
        NSString *url = [firebaseURL stringByAppendingString:self.userName];
        _firebase = [[Firebase alloc] initWithUrl:url];
    }
    
    return _firebase;
}

- (void)loadDemoDataSource {
    self.messageSender = @"Jack";
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableArray *messages = [[NSMutableArray alloc] init];
        
        [messages addObject:[self getPhotoMessageWithBubbleMessageType:XHBubbleMessageTypeReceiving]];
    
        [messages addObject:[self getTextMessageWithBubbleMessageType:XHBubbleMessageTypeReceiving]];
        [messages addObject:[self getTextMessageWithBubbleMessageType:XHBubbleMessageTypeSending]];
    
        //[messages addObject:[self getVideoMessageWithBubbleMessageType:(i % 2) ? XHBubbleMessageTypeSending : XHBubbleMessageTypeReceiving]];
        
        //[messages addObject:[self getEmotionMessageWithBubbleMessageType:(i % 2) ? XHBubbleMessageTypeSending : XHBubbleMessageTypeReceiving]];
        
        [messages addObject:[self getTextMessageWithBubbleMessageType:XHBubbleMessageTypeSending]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.messages = messages;
            [weakSelf.messageTableView reloadData];
            
            [weakSelf scrollToBottomAnimated:NO];
        });
    });
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Custom UI
    //    [self setBackgroundColor:[UIColor clearColor]];
    //    [self setBackgroundImage:[UIImage imageNamed:@"TableViewBackgroundImage"]];
    
    self.title = self.userName;
    
//    NSMutableArray *shareMenuItems = [NSMutableArray array];
//    NSArray *plugIcons = @[@"sharemore_pic", @"sharemore_video", @"sharemore_location", @"sharemore_voiceinput"];
//    NSArray *plugTitle = @[@"Photo", @"Video", @"Location", @"Audio"];
//    for (NSInteger i = 0; i < [plugTitle count]; i ++) {
//        XHShareMenuItem *shareMenuItem = [[XHShareMenuItem alloc] initWithNormalIconImage:[UIImage imageNamed:[plugIcons objectAtIndex:i]] title:[plugTitle objectAtIndex:i]];
//        [shareMenuItems addObject:shareMenuItem];
//    }
//    
//    NSMutableArray *emotionManagers = [NSMutableArray array];
//    for (NSInteger i = 0; i < 10; i ++) {
//        XHEmotionManager *emotionManager = [[XHEmotionManager alloc] init];
//        
//        NSMutableArray *emotions = [NSMutableArray array];
//        for (NSInteger j = 0; j < 32; j ++) {
//            XHEmotion *emotion = [[XHEmotion alloc] init];
//            NSString *imageName = [NSString stringWithFormat:@"section%ld_emotion%ld", (long)i , (long)j % 16];
//            emotion.emotionPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"Demo%ld.gif", (long)j % 2] ofType:@""];
//            emotion.emotionConverPhoto = [UIImage imageNamed:imageName];
//            [emotions addObject:emotion];
//        }
//        emotionManager.emotions = emotions;
//        
//        [emotionManagers addObject:emotionManager];
//    }
//    
//    self.emotionManagers = emotionManagers;
//    [self.emotionManagerView reloadData];
//    
//    self.shareMenuItems = shareMenuItems;
//    [self.shareMenuView reloadData];
    NSMutableArray *tempMessages = [[NSMutableArray alloc] init];
    
    //Firebase* f = [[Firebase alloc] initWithUrl:@"https://dazzling-fire-7228.firebaseio.com/"];
    [self.firebase observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
       // NSMutableArray *tempMessages = [NSMutableArray arrayWithArray:self.messages];
        //NSMutableArray *reversedMessages = [[NSMutableArray alloc] init];
        
        @try {
            NSDictionary *value = (NSDictionary *)snapshot.value;
            if ([value objectForKey:@"video"]) {
                NSData *videoData = [NSData base64DataFromString:(NSString *)[value objectForKey:@"video"]];
                
                NSArray *dirPaths= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *docsDir= [dirPaths objectAtIndex:0];
                NSString *databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"video%d.mp4", count++]]];
                [videoData writeToFile:databasePath atomically:YES];
                
                [tempMessages addObject:[[XHMessage alloc] initWithVideoConverPhoto:[UIImage imageNamed:@"play"] videoPath:databasePath videoUrl:nil sender:@"Jack Smith" timestamp:[NSDate date]]];
                //[tempMessages insertObject:[[XHMessage alloc] initWithVideoConverPhoto:[UIImage imageNamed:@"play"] videoPath:databasePath videoUrl:nil sender:@"Jack Smith" timestamp:[NSDate date]] atIndex:0];
            } else if ([value objectForKey:@"message"]) {
                [tempMessages addObject:[[XHMessage alloc] initWithText:[value objectForKey:@"message"] sender:@"Andy" timestamp:[NSDate date]]];
                //[tempMessages insertObject:[[XHMessage alloc] initWithText:[value objectForKey:@"message"] sender:@"Andy" timestamp:[NSDate date]] atIndex:0];
            } else {
                NSData *photoData = [NSData base64DataFromString:(NSString *)[value objectForKey:@"photo"]];
                
                [tempMessages addObject:[[XHMessage alloc] initWithPhoto:[UIImage imageWithData:photoData] thumbnailUrl:nil originPhotoUrl:nil sender:@"Jack Smith" timestamp:[NSDate date]]];
                //[tempMessages insertObject:[[XHMessage alloc] initWithPhoto:[UIImage imageWithData:photoData] thumbnailUrl:nil originPhotoUrl:nil sender:@"Jack Smith" timestamp:[NSDate date]] atIndex:0];
            }
            
        }
        @catch (NSException * e) {
            NSLog(@"Exception: %@", e);
        }
        @finally {
            NSLog(@"finally");
            
                self.messages = tempMessages;
                [self.messageTableView reloadData];
                
                [self scrollToBottomAnimated:NO];
        }
    }];
    
    //[self loadDemoDataSource];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.emotionManagers = nil;
}

/*
 [self removeMessageAtIndexPath:indexPath];
 [self insertOldMessages:self.messages];
 */

#pragma mark - XHMessageTableViewCell delegate

- (void)multiMediaMessageDidSelectedOnMessage:(id<XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath onMessageTableViewCell:(XHMessageTableViewCell *)messageTableViewCell {
    UIViewController *disPlayViewController;
    switch (message.messageMediaType) {
        case XHBubbleMessageVideo:
        case XHBubbleMessagePhoto: {
            DLog(@"message : %@", message.photo);
            DLog(@"message : %@", message.videoConverPhoto);
            XHDisplayMediaViewController *messageDisplayTextView = [[XHDisplayMediaViewController alloc] init];
            messageDisplayTextView.message = message;
            disPlayViewController = messageDisplayTextView;
            break;
        }
            break;
        case XHBubbleMessageVoice:
            DLog(@"message : %@", message.voicePath);
            [messageTableViewCell.messageBubbleView.animationVoiceImageView startAnimating];
            [messageTableViewCell.messageBubbleView.animationVoiceImageView performSelector:@selector(stopAnimating) withObject:nil afterDelay:3];
            break;
        case XHBubbleMessageFace:
            DLog(@"facePath : %@", message.emotionPath);
            break;
        case XHBubbleMessageLocalPosition: {
            DLog(@"facePath : %@", message.localPositionPhoto);
            XHDisplayLocationViewController *displayLocationViewController = [[XHDisplayLocationViewController alloc] init];
            displayLocationViewController.message = message;
            disPlayViewController = displayLocationViewController;
            break;
        }
        default:
            break;
    }
    if (disPlayViewController) {
        [self.navigationController pushViewController:disPlayViewController animated:YES];
    }
}

- (void)didDoubleSelectedOnTextMessage:(id<XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath {
    DLog(@"text : %@", message.text);
    XHDisplayTextViewController *displayTextViewController = [[XHDisplayTextViewController alloc] init];
    displayTextViewController.message = message;
    [self.navigationController pushViewController:displayTextViewController animated:YES];
}

- (void)didSelectedAvatorAtIndexPath:(NSIndexPath *)indexPath {
    DLog(@"indexPath : %@", indexPath);
    XHProfileTableViewController *profileTableViewController = [[XHProfileTableViewController alloc] init];
    [self.navigationController pushViewController:profileTableViewController animated:YES];
}

- (void)menuDidSelectedAtBubbleMessageMenuSelecteType:(XHBubbleMessageMenuSelecteType)bubbleMessageMenuSelecteType {
    
}

#pragma mark - XHEmotionManagerView DataSource

- (NSInteger)numberOfEmotionManagers {
    return self.emotionManagers.count;
}

- (XHEmotionManager *)emotionManagerForColumn:(NSInteger)column {
    return [self.emotionManagers objectAtIndex:column];
}

- (NSArray *)emotionManagersAtManager {
    return self.emotionManagers;
}

#pragma mark - XHMessageTableViewController Delegate

/**
 */
- (void)didSendText:(NSString *)text fromSender:(NSString *)sender onDate:(NSDate *)date {
    //[self addMessage:[[XHMessage alloc] initWithText:text sender:sender timestamp:date]];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageText];
    Firebase* newPushRef = [self.firebase childByAutoId];
    
    // Set some data to the generated location
    [newPushRef setValue:[NSDictionary dictionaryWithObjectsAndKeys:@"Andy Mai", @"name", text, @"message", nil]];
    
    // Get the name generated by push
    //NSString* pushedName = newPushRef.name;
    //[self.firebase updateChildValues:[NSDictionary dictionaryWithObjectsAndKeys:@"Andy Mai", @"name", text, @"message", nil]];
}

/**
 */
- (void)didSendPhoto:(UIImage *)photo fromSender:(NSString *)sender onDate:(NSDate *)date {
    [self addMessage:[[XHMessage alloc] initWithPhoto:photo thumbnailUrl:nil originPhotoUrl:nil sender:sender timestamp:date]];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessagePhoto];
}

/**
 */
- (void)didSendVideoConverPhoto:(UIImage *)videoConverPhoto videoPath:(NSString *)videoPath fromSender:(NSString *)sender onDate:(NSDate *)date {
    [self addMessage:[[XHMessage alloc] initWithVideoConverPhoto:videoConverPhoto videoPath:videoPath videoUrl:nil sender:sender timestamp:date]];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageVideo];
}

/**
 */
- (void)didSendVoice:(NSString *)voicePath fromSender:(NSString *)sender onDate:(NSDate *)date {
    [self addMessage:[[XHMessage alloc] initWithVoicePath:voicePath voiceUrl:nil sender:sender timestamp:date]];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageVoice];
}

/**

 */
- (void)didSendEmotion:(NSString *)emotionPath fromSender:(NSString *)sender onDate:(NSDate *)date {
    [self addMessage:[[XHMessage alloc] initWithEmotionPath:emotionPath sender:sender timestamp:date]];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageFace];
}

/**
 */
- (void)didSendGeoLocationsPhoto:(UIImage *)geoLocationsPhoto geolocations:(NSString *)geolocations location:(CLLocation *)location fromSender:(NSString *)sender onDate:(NSDate *)date {
    [self addMessage:[[XHMessage alloc] initWithLocalPositionPhoto:geoLocationsPhoto geolocations:geolocations location:location sender:sender timestamp:date]];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageLocalPosition];
}

/**
 *
 */
- (BOOL)shouldDisplayTimestampForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 2)
        return YES;
    else
        return NO;
}

/**
 *
 *  @param cell
 *  @param indexPath
 */
- (void)configureCell:(XHMessageTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.messageBubbleView.messageDisplayTextView.textColor = [UIColor colorWithRed:0.106 green:0.586 blue:1.000 alpha:1.000];
}

/**
 *
 *  @return YES or NO
 */
- (BOOL)shouldPreventScrollToBottomWhileUserScrolling {
    return YES;
}

@end
