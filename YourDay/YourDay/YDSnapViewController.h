//
//  YDSnapViewController.h
//  YourDay
//
//  Created by Stanley Tang on 5/11/14.
//  Copyright (c) 2014 ChillBear. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PBJStrobeView.h"

#import "PBJFocusView.h"

@interface YDSnapViewController : UIViewController

@property (strong, nonatomic) IBOutlet PBJStrobeView *strobeView;
@property (strong, nonatomic) IBOutlet UIButton *flipButton;
@property (strong, nonatomic) IBOutlet UIButton *captureButton;
@property (strong, nonatomic) IBOutlet UIView *previewView;
@property (strong, nonatomic) IBOutlet UILabel *timerLabel;
@property (strong, nonatomic) IBOutlet PBJFocusView *focusView;

@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *longPressGestureRecognizer;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGestureRecognizer;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *focusTapGesterRecognizer;

@property (nonatomic, strong) NSTimer *timer;

- (IBAction)didPressFlipButton:(id)sender;

- (IBAction)handleLongPressGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer;
- (IBAction)handleTapGesterRecognizer:(UIGestureRecognizer *)gestureRecognizer;
- (IBAction)handleFocusTapGesterRecognizer:(UIGestureRecognizer *)gestureRecognizer;

@end
