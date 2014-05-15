//
//  YDUser.h
//  YourDay
//
//  Created by Stanley Tang on 5/11/14.
//  Copyright (c) 2014 ChillBear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDUser : NSObject

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;

- (NSString *)getUserFullNameFor:(YDUser *)user;

@end
