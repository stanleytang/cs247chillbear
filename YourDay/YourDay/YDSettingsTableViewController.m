//
//  YDSettingsTableViewController.m
//  YourDay
//
//  Created by Andy Mai on 5/13/14.
//  Copyright (c) 2014 ChillBear. All rights reserved.
//

#import "YDSettingsTableViewController.h"
#import "YDFreqSettingViewController.h"

@interface YDSettingsTableViewController ()
@end

@implementation YDSettingsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //self.contacts = @[@"Andy Mai", @"Stanley Tang", @"Daniel Noe", @"Trent Murphy"];
    //[self.tableView reloadData];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData]; // to reload selected cell
}
//- (NSMutableDictionary *)frequencies
//{
//    if (!_frequencies) {
//        _frequencies = [[NSMutableDictionary alloc] init];
//        NSArray *times = @[@"every day", @"every week", @"every day", @"every month"];
//        
//        for (NSUInteger i = 0; i < [self.contacts count]; i++) {
//            _frequencies[[self.contacts objectAtIndex:i]] = [times objectAtIndex:i];
//        }
//
//    }
//    
//    return _frequencies;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.contacts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Contact Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.textLabel.text = self.contacts[indexPath.row];
    cell.detailTextLabel.text = self.frequencies[self.contacts[indexPath.row]];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"Edit Frequency"]) {
                if ([segue.destinationViewController isKindOfClass:[YDFreqSettingViewController class]]) {
                    YDFreqSettingViewController *dstVC = segue.destinationViewController;
                    NSString *user = self.contacts[indexPath.row];
                    dstVC.name = user;
                    dstVC.currFrequency = self.frequencies[user];
                }
            }
        }
    }

}


@end
