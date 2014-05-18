//
//  YDFreqSettingViewController.m
//  YourDay
//
//  Created by Andy Mai on 5/13/14.
//  Copyright (c) 2014 ChillBear. All rights reserved.
//

#import "YDFreqSettingViewController.h"
#import "YDSettingsTableViewController.h"

@interface YDFreqSettingViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *currFreqLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *freqPicker;
@property (strong, nonatomic) NSArray *freqSelections;
@property (strong, nonatomic) NSString *updatedFrequency;
@property (weak, nonatomic) IBOutlet UILabel *savedLabel;

@end

@implementation YDFreqSettingViewController

- (NSString *)name
{
    if (!_name) {
        _name = [[NSString alloc] init];
    }
    
    return _name;
}

- (NSString *)currFrequency
{
    if (!_currFrequency) {
        _currFrequency = [[NSString alloc] init];
    }
    
    return _currFrequency;
}

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
    
    self.nameLabel.text = self.name;
    self.currFreqLabel.text = self.currFrequency;
    self.savedLabel.text = nil;
    self.freqPicker.delegate = self;
    self.freqPicker.showsSelectionIndicator = YES;
    
    self.freqSelections = @[@"every day",@"every week",@"every month"];
    NSUInteger defaultRow = [self.freqSelections indexOfObject:self.currFrequency];
    [self.freqPicker selectRow:defaultRow inComponent:0 animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    // Handle the selection
    
    NSUInteger numberOfViewControllers = self.navigationController.viewControllers.count;
    YDSettingsTableViewController *settingsTVC = [self.navigationController.viewControllers objectAtIndex:numberOfViewControllers-2];
    
    settingsTVC.frequencies[self.name] = self.freqSelections[row];
    self.savedLabel.text = @"Saved!";
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [self.freqSelections count];
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.freqSelections[row];
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 300;
    
    return sectionWidth;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"Save Frequency"]) {
        if ([segue.destinationViewController isKindOfClass:[YDSettingsTableViewController class]]) {
            YDSettingsTableViewController *settingsTVC = (YDSettingsTableViewController *)segue.destinationViewController;
            NSArray *times = @[@"every day", @"every week", @"every day", @"every month"];
            NSArray *contacts = @[@"Andy Mai", @"Stanley Tang", @"Daniel Noe", @"Trent Murphy"];
            
            NSMutableDictionary *frequencies = [[NSMutableDictionary alloc] init];
            for (NSUInteger i = 0; i < [contacts count]; i++) {
                frequencies[[contacts objectAtIndex:i]] = [times objectAtIndex:i];
            }
            
            settingsTVC.frequencies = frequencies;
        }
    }

    
}

@end
