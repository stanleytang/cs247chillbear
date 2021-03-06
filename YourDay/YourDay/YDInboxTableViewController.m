//
//  YDInboxTableViewController.m
//  YourDay
//
//  Created by Andy Mai on 5/11/14.
//  Copyright (c) 2014 ChillBear. All rights reserved.
//

#import "YDInboxTableViewController.h"
#import "YDMessageTableViewController.h"
#import "YDContactsTableViewController.h"

@interface YDInboxTableViewController ()
@property (strong, nonatomic) NSArray *users;
@end

@implementation YDInboxTableViewController

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
    
    self.users = @[@"Andy Mai", @"Stanley Tang", @"Daniel Noe", @"Peyton Manning", @"Johnny Manziel"];
}

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
    return [self.users count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Inbox Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.textLabel.text = self.users[indexPath.row];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    
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
            if ([segue.identifier isEqualToString:@"Display Messages"]) {
                if ([segue.destinationViewController isKindOfClass:[YDMessageTableViewController class]]) {
                    YDMessageTableViewController *dstController = segue.destinationViewController;
                    NSString *userName = self.users[indexPath.row];
                    dstController.userName = userName;
                }
            }
        }
    }
    
    if ([segue.identifier isEqualToString:@"Settings"]) {
        if ([segue.destinationViewController isKindOfClass:[YDContactsTableViewController class]]) {
            YDContactsTableViewController *contactsTVC = (YDContactsTableViewController *)segue.destinationViewController;
            NSArray *times = @[@"every day", @"every week", @"every day", @"every month"];
            NSArray *contacts = @[@"Andy Mai", @"Stanley Tang", @"Daniel Noe", @"Trent Murphy"];
            
            NSMutableDictionary *frequencies = [[NSMutableDictionary alloc] init];
            for (NSUInteger i = 0; i < [contacts count]; i++) {
                frequencies[[contacts objectAtIndex:i]] = [times objectAtIndex:i];
            }
            
            contactsTVC.contacts = contacts;
            contactsTVC.frequencies = frequencies;
        }
    }

}


@end
