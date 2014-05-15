//
//  YDUser.m
//  YourDay
//
//  Created by Stanley Tang on 5/11/14.
//  Copyright (c) 2014 ChillBear. All rights reserved.
//

#import "YDUser.h"

@implementation YDUser

- (NSString *)getUserFullNameFor:(YDUser *)user
{
    return [[user.firstName stringByAppendingString:@" "] stringByAppendingString:user.lastName];
}

@end
