//
//  YDFreqSettingViewController.h
//  YourDay
//
//  Created by Andy Mai on 5/13/14.
//  Copyright (c) 2014 ChillBear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDFreqSettingViewController : UIViewController <UIPickerViewDelegate>
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *currFrequency;
@end
