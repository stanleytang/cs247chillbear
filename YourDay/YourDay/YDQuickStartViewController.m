//
//  YDQuickStartViewController.m
//  YourDay
//
//  Created by Andy Mai on 5/22/14.
//  Copyright (c) 2014 ChillBear. All rights reserved.
//

#import "YDQuickStartViewController.h"

@interface YDQuickStartViewController ()
@property (weak, nonatomic) IBOutlet UIButton *dismissButton;

@end

@implementation YDQuickStartViewController

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
    // Do any additional setup after loading the view.
    
    self.dismissButton.backgroundColor = [UIColor colorWithRed:39/255.0 green:174/255.0 blue:96/255.0 alpha:1.0];
    self.dismissButton.titleLabel.textColor = [UIColor whiteColor];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)dismissControllerButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
