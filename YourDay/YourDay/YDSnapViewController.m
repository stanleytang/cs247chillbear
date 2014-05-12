//
//  YDSnapViewController.m
//  YourDay
//
//  Created by Stanley Tang on 5/11/14.
//  Copyright (c) 2014 ChillBear. All rights reserved.
//

#import "YDSnapViewController.h"

#import "YDSelectFriendsTableViewController.h"

#import "PBJVision.h"
#import "PBJVisionUtilities.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <GLKit/GLKit.h>

@interface YDSnapViewController () <UIGestureRecognizerDelegate, PBJVisionDelegate> {
    AVCaptureVideoPreviewLayer *_previewLayer;
    
    UIView *_focusView;
    
    ALAssetsLibrary *_assetLibrary;
    __block NSDictionary *_currentVideo;
    __block NSDictionary *_currentPhoto;
}

@end

@implementation YDSnapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _assetLibrary = [[ALAssetsLibrary alloc] init];
    
    self.strobeView = [[PBJStrobeView alloc] initWithFrame:CGRectZero];
    CGRect strobeFrame = _strobeView.frame;
    strobeFrame.origin = CGPointMake(15.0f, 75.0f);
    self.strobeView.frame = strobeFrame;
    self.strobeView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.strobeView];
    
    // preview and AV layer
    _previewLayer = [[PBJVision sharedInstance] previewLayer];
    _previewLayer.frame = self.previewView.bounds;
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.previewView.layer addSublayer:_previewLayer];
    
    [self _resetCapture];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // iOS 6 support
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
    [self _resetCapture];
    [[PBJVision sharedInstance] startPreview];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[PBJVision sharedInstance] stopPreview];
    
    // iOS 6 support
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

#pragma mark - private start/stop helper methods

- (void)_startCapture
{
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    [[PBJVision sharedInstance] startVideoCapture];
    [_strobeView start];
    
    [self.captureButton setBackgroundImage:[UIImage imageNamed:@"record-button-recording"] forState:UIControlStateNormal];
    [self.captureButton setBackgroundImage:[UIImage imageNamed:@"record-button-recording"] forState:UIControlStateHighlighted];
    [self.captureButton setBackgroundImage:[UIImage imageNamed:@"record-button-recording"] forState:UIControlStateSelected];
}

- (void)_endCapture
{
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [[PBJVision sharedInstance] endVideoCapture];
    [_strobeView stop];
    
    [self.captureButton setBackgroundImage:[UIImage imageNamed:@"record-button"] forState:UIControlStateNormal];
    [self.captureButton setBackgroundImage:[UIImage imageNamed:@"record-button"] forState:UIControlStateHighlighted];
    [self.captureButton setBackgroundImage:[UIImage imageNamed:@"record-button"] forState:UIControlStateSelected];
}

- (void)_resetCapture
{
    [_strobeView stop];
    
    [self.captureButton setBackgroundImage:[UIImage imageNamed:@"record-button"] forState:UIControlStateNormal];
    [self.captureButton setBackgroundImage:[UIImage imageNamed:@"record-button"] forState:UIControlStateHighlighted];
    [self.captureButton setBackgroundImage:[UIImage imageNamed:@"record-button"] forState:UIControlStateSelected];
    
    PBJVision *vision = [PBJVision sharedInstance];
    vision.delegate = self;
    
    if ([vision isCameraDeviceAvailable:PBJCameraDeviceBack]) {
        [vision setCameraDevice:PBJCameraDeviceBack];
        _flipButton.hidden = NO;
    } else {
        [vision setCameraDevice:PBJCameraDeviceFront];
        _flipButton.hidden = YES;
    }
    
//    [vision setCaptureSessionPreset:AVCaptureSessionPreset640x480];
    [vision setCameraMode:PBJCameraModeVideo];
    [vision setCameraOrientation:PBJCameraOrientationPortrait];
    [vision setFocusMode:PBJFocusModeContinuousAutoFocus];
    [vision setOutputFormat:PBJOutputFormatSquare];
    [vision setVideoRenderingEnabled:YES];
}

#pragma mark - UIButton

- (IBAction)didPressFlipButton:(id)sender {
    PBJVision *vision = [PBJVision sharedInstance];
    if (vision.cameraDevice == PBJCameraDeviceBack) {
        [vision setCameraDevice:PBJCameraDeviceFront];
    } else {
        [vision setCameraDevice:PBJCameraDeviceBack];
    }
}

#pragma mark - UIGestureRecognizer

- (IBAction)handleLongPressGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            [self _startCapture];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        {
            [self _endCapture];
            break;
        }
        default:
            break;
    }

}

- (IBAction)handleTapGesterRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    [[PBJVision sharedInstance] capturePhoto];
}

#pragma mark - PBJVisionDelegate

// session

- (void)visionSessionWillStart:(PBJVision *)vision
{
}

- (void)visionSessionDidStart:(PBJVision *)vision
{
}

- (void)visionSessionDidStop:(PBJVision *)vision
{
}

// preview

- (void)visionSessionDidStartPreview:(PBJVision *)vision
{
    NSLog(@"Camera preview did start");
    
}

- (void)visionSessionDidStopPreview:(PBJVision *)vision
{
    NSLog(@"Camera preview did stop");
}

// device

- (void)visionCameraDeviceWillChange:(PBJVision *)vision
{
    NSLog(@"Camera device will change");
}

- (void)visionCameraDeviceDidChange:(PBJVision *)vision
{
    NSLog(@"Camera device did change");
}

// mode

- (void)visionCameraModeWillChange:(PBJVision *)vision
{
    NSLog(@"Camera mode will change");
}

- (void)visionCameraModeDidChange:(PBJVision *)vision
{
    NSLog(@"Camera mode did change");
}

// format

- (void)visionOutputFormatWillChange:(PBJVision *)vision
{
    NSLog(@"Output format will change");
}

- (void)visionOutputFormatDidChange:(PBJVision *)vision
{
    NSLog(@"Output format did change");
}

- (void)vision:(PBJVision *)vision didChangeCleanAperture:(CGRect)cleanAperture
{
}

// focus / exposure

- (void)visionWillStartFocus:(PBJVision *)vision
{
}

- (void)visionDidStopFocus:(PBJVision *)vision
{
}

- (void)visionWillChangeExposure:(PBJVision *)vision
{
}

- (void)visionDidChangeExposure:(PBJVision *)vision
{
}

// flash

- (void)visionDidChangeFlashMode:(PBJVision *)vision
{
    NSLog(@"Flash mode did change");
}

// photo

- (void)visionWillCapturePhoto:(PBJVision *)vision
{
}

- (void)visionDidCapturePhoto:(PBJVision *)vision
{
}

- (void)vision:(PBJVision *)vision capturedPhoto:(NSDictionary *)photoDict error:(NSError *)error
{
    if (error && [error.domain isEqual:PBJVisionErrorDomain] && error.code == PBJVisionErrorCancelled) {
        NSLog(@"photo session cancelled");
        return;
    } else if (error) {
        NSLog(@"encounted an error in photo capture (%@)", error);
        return;
    }
    
    _currentPhoto = photoDict;
}

// video capture

- (void)visionDidStartVideoCapture:(PBJVision *)vision
{
}

- (void)visionDidPauseVideoCapture:(PBJVision *)vision
{
}

- (void)visionDidResumeVideoCapture:(PBJVision *)vision
{
}

- (void)vision:(PBJVision *)vision capturedVideo:(NSDictionary *)videoDict error:(NSError *)error
{
    if (error && [error.domain isEqual:PBJVisionErrorDomain] && error.code == PBJVisionErrorCancelled) {
        NSLog(@"recording session cancelled");
        return;
    } else if (error) {
        NSLog(@"encounted an error in video capture (%@)", error);
        return;
    }
    
    [_strobeView stop];
    
    _currentVideo = videoDict;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Video Captured!" message: @"The video has been captured. Press Next to send it to your friends"
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
    [alert show];
}

// progress

- (void)visionDidCaptureAudioSample:(PBJVision *)vision
{
    //    NSLog(@"captured audio (%f) seconds", vision.capturedAudioSeconds);
}

- (void)visionDidCaptureVideoSample:(PBJVision *)vision
{
    //    NSLog(@"captured video (%f) seconds", vision.capturedVideoSeconds);
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"SelectFriendsSegue"])
    {
        YDSelectFriendsTableViewController *selectFriendsTVC = segue.destinationViewController;
        NSString *videoPath = [_currentVideo  objectForKey:PBJVisionVideoPathKey];
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:videoPath];
        selectFriendsTVC.videoData = data;
    }
}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if([identifier isEqualToString:@"SelectFriendsSegue"])
    {
        if (!_currentVideo) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"No Video!" message: @"Please capture a video before pressing next"
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
            [alert show];
            return NO;
        }
    }
    return YES;
}


@end
