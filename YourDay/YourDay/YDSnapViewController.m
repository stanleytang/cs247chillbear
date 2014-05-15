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
    
    ALAssetsLibrary *_assetLibrary;
    __block NSDictionary *_currentVideo;
    __block NSDictionary *_currentPhoto;
}

@end

@implementation YDSnapViewController

+ (UIImage *)thumbnailImageForVideo:(NSURL *)videoURL
                             atTime:(NSTimeInterval)time
{
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetIG =
    [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetIG.appliesPreferredTrackTransform = YES;
    assetIG.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *igError = nil;
    thumbnailImageRef =
    [assetIG copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)
                    actualTime:NULL
                         error:&igError];
    
    if (!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@", igError );
    
    UIImage *thumbnailImage = thumbnailImageRef
    ? [[UIImage alloc] initWithCGImage:thumbnailImageRef]
    : nil;
    
    return thumbnailImage;
}

NSUInteger timerSeconds = 0;

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

- (void)timerTick {
    self.timerLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)++timerSeconds];
}

- (void)_startCapture
{
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    [[PBJVision sharedInstance] startVideoCapture];
    [_strobeView start];
    
    self.timerLabel.hidden = NO;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(timerTick)
                                                userInfo:nil
                                                 repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    [self.timer fire];
    
    [self.captureButton setBackgroundImage:[UIImage imageNamed:@"record-button-recording"] forState:UIControlStateNormal];
    [self.captureButton setBackgroundImage:[UIImage imageNamed:@"record-button-recording"] forState:UIControlStateHighlighted];
    [self.captureButton setBackgroundImage:[UIImage imageNamed:@"record-button-recording"] forState:UIControlStateSelected];
}

- (void)_endCapture
{
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [[PBJVision sharedInstance] endVideoCapture];
    [_strobeView stop];
    
    [self.timer invalidate];
    
    [self.captureButton setBackgroundImage:[UIImage imageNamed:@"record-button"] forState:UIControlStateNormal];
    [self.captureButton setBackgroundImage:[UIImage imageNamed:@"record-button"] forState:UIControlStateHighlighted];
    [self.captureButton setBackgroundImage:[UIImage imageNamed:@"record-button"] forState:UIControlStateSelected];
}

- (void)_resetCapture
{
    [_strobeView stop];
    
    self.timerLabel.hidden = YES;
    timerSeconds = 0;
    self.timerLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)timerSeconds];
    
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
    [vision setThumbnailEnabled:YES];
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
//    [[PBJVision sharedInstance] capturePhoto];
    [self _startCapture];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (0.08 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self _endCapture];
    });
}

- (IBAction)handleFocusTapGesterRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint tapPoint = [gestureRecognizer locationInView:self.previewView];
    
    // auto focus is occuring, display focus view
    CGPoint point = tapPoint;
    
    CGRect focusFrame = self.focusView.frame;
#if defined(__LP64__) && __LP64__
    focusFrame.origin.x = rint(point.x - (focusFrame.size.width * 0.5));
    focusFrame.origin.y = rint(point.y - (focusFrame.size.height * 0.5));
#else
    focusFrame.origin.x = rintf(point.x - (focusFrame.size.width * 0.5f));
    focusFrame.origin.y = rintf(point.y - (focusFrame.size.height * 0.5f));
#endif
    [self.focusView setFrame:focusFrame];
    [self.focusView startAnimation];
    
    CGPoint adjustPoint = [PBJVisionUtilities convertToPointOfInterestFromViewCoordinates:tapPoint inFrame:self.previewView.frame];
    [[PBJVision sharedInstance] focusExposeAndAdjustWhiteBalanceAtAdjustedPoint:adjustPoint];
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
    [self.focusView stopAnimation];
}

- (void)visionWillChangeExposure:(PBJVision *)vision
{
}

- (void)visionDidChangeExposure:(PBJVision *)vision
{
    [self.focusView stopAnimation];
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
    _currentVideo = nil;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Photo Captured!" message: @"The photo has been captured. Press Next to send it to your friends"
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
    [alert show];
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
    _currentPhoto = nil;
    
    UIAlertView *alert;
    if ([[_currentVideo objectForKey:PBJVisionVideoCapturedDurationKey] integerValue] < 1) {
        alert = [[UIAlertView alloc] initWithTitle: @"Photo Captured!"
                                           message: @"The photo has been captured. Press Next to send it to your friends"
                                          delegate:self
                                 cancelButtonTitle:nil
                                 otherButtonTitles:@"OK", nil];
    } else {
        alert = [[UIAlertView alloc] initWithTitle: @"Video Captured!"
                                           message: @"The video has been captured. Press Next to send it to your friends"
                                          delegate:self
                                 cancelButtonTitle:nil
                                 otherButtonTitles:@"OK", nil];
    }
    
    [alert show];
    
    self.timerLabel.hidden = YES;
    timerSeconds = 0;
    self.timerLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)timerSeconds];
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
        
        if (_currentVideo) {
            NSString *videoPath = [_currentVideo  objectForKey:PBJVisionVideoPathKey];
            
            if ([[_currentVideo objectForKey:PBJVisionVideoCapturedDurationKey] integerValue] < 1) {
                UIImage *image = [YDSnapViewController thumbnailImageForVideo:[NSURL fileURLWithPath:videoPath] atTime:0];
                selectFriendsTVC.photoData = UIImagePNGRepresentation(image);
            } else {
                NSData *data = [[NSFileManager defaultManager] contentsAtPath:videoPath];
                selectFriendsTVC.videoData = data;
            }
        }
    }
}




- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if([identifier isEqualToString:@"SelectFriendsSegue"])
    {
        if (!_currentVideo && !_currentPhoto) {
            UIAlertView *alert;
            if (!_currentVideo) {
                alert = [[UIAlertView alloc] initWithTitle: @"No Video!"
                                                   message: @"Please capture a video before pressing next"
                                                  delegate:self
                                         cancelButtonTitle:nil
                                         otherButtonTitles:@"OK", nil];
            } else {
                alert = [[UIAlertView alloc] initWithTitle: @"No Photo!"
                                                   message: @"Please capture a photo before pressing next"
                                                  delegate:self
                                         cancelButtonTitle:nil
                                         otherButtonTitles:@"OK", nil];
            }
            [alert show];
            return NO;
        }
    }
    return YES;
}


@end
