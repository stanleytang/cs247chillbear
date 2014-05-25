//
//  XHShareMenuItem.h
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-5-1.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kXHShareMenuItemIconSize 60
#define KXHShareMenuItemHeight 80

@interface XHShareMenuItem : NSObject

@property (nonatomic, strong) UIImage *normalIconImage;
@property (nonatomic, copy) NSString *title;

- (instancetype)initWithNormalIconImage:(UIImage *)normalIconImage
                                  title:(NSString *)title;

@end
