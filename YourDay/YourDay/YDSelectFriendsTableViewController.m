//
//  YDSelectFriendsTableViewController.m
//  YourDay
//
//  Created by Stanley Tang on 5/11/14.
//  Copyright (c) 2014 ChillBear. All rights reserved.
//

#import "YDSelectFriendsTableViewController.h"

#import <Firebase/Firebase.h>
#import "NSStrinAdditions.h"

@interface YDSelectFriendsTableViewController ()

@property (strong, nonatomic) NSArray *users;

@end

@implementation YDSelectFriendsTableViewController

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
    return [self.users count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectFriendsCell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.users[indexPath.row];
    
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
    
    if([segue.identifier isEqualToString:@"SendSnap"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        NSString *userName = self.users[indexPath.row];
        userName = [userName stringByReplacingOccurrencesOfString:@" " withString: @"_"];
        NSString *firebaseURL = @"https://dazzling-fire-7228.firebaseio.com/";
        NSString *url = [firebaseURL stringByAppendingString:userName];
        
        Firebase* nameRef = [[Firebase alloc] initWithUrl:url];
        Firebase *listRef = [nameRef childByAutoId];
        if (self.videoData) {
            NSString *videoString = [NSString base64StringFromData:self.videoData length:[self.videoData length]];
            [listRef setValue:[NSDictionary dictionaryWithObjectsAndKeys:@"Andy Mai", @"name", videoString, @"video", nil]];
        } else {
            NSString *imageString = [NSString base64StringFromData:self.photoData length:[self.photoData length]];
            [listRef setValue:[NSDictionary dictionaryWithObjectsAndKeys:@"Andy Mai", @"name", imageString, @"photo", nil]];
        }
    }
}
@end
