//
//  YDMessage.h
//  YourDay
//
//  Created by Stanley Tang on 5/11/14.
//  Copyright (c) 2014 ChillBear. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YDUser.h"

@interface YDMessage : NSObject

@property (nonatomic, strong) YDUser *sender;
@property (nonatomic, strong) NSString *textMessage;
@property (nonatomic, strong) NSData *video;
@property (nonatomic, strong) NSData *image;

@end
