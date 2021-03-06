//
//  CurrentMatchListTVC.m
//  MeetEmUp
//
//  Created by Student on 5/7/15.
//  Copyright (c) 2015 Nathaniel Kierpiec Nick Greenquist Dylan Coats Max Peabody. All rights reserved.
//

#import "CurrentMatchListTVC.h"
#import "CurrentMatchTableCell.h"
#import "AccountViewController.h"
#import "CurrentMatchTableCell.h"
#import "CurrentMatchDetailVC.h"
#import "Profile.h"

@interface CurrentMatchListTVC (){
    Database* db;
    NSMutableArray* profiles;
}

@end

@implementation CurrentMatchListTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    db = [[Database alloc] init];
    profiles = [NSMutableArray array];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tabBar = (TabBarController *)self.tabBarController;
    
    for(NSString* myMatchIds in self.tabBar.peopleYouMatched)
    {
        [db GetData:[NSString stringWithFormat:@"fetchprofile.php?ID=%i", [myMatchIds integerValue]] completion:^(NSDictionary* matchedProfileResults){
            //Run UI Updates
            for(NSDictionary* matchedDic in matchedProfileResults[@"results"])
            {
                Profile* matchedProf = [[Profile alloc] initWithDictionary:matchedDic];
                
                [profiles addObject:matchedProf];
                
                /*
                if(![matchedProf.currentMatches isKindOfClass:[NSNull class]])
                {
                    NSArray* theirMatches = [matchedProf.currentMatches componentsSeparatedByString:@","];
                    
                    for(NSString* theirMatchIds in theirMatches)
                    {
                        if([theirMatchIds integerValue] == self.tabBar.id)
                        {
                            //[profiles addObject:matchedProf];
                        }
                    }
                }
                 */
            }
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [self.tableView reloadData];
            });
        }];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [profiles count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Match" forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Match"];
    }
    
    Profile* temp = [profiles objectAtIndex:indexPath.row];
    CurrentMatchTableCell* customCell = (CurrentMatchTableCell*)cell;
    customCell.matchName.text = temp.name;
    
    return cell;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)logout:(id)sender {

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Look"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        CurrentMatchDetailVC *destViewController = segue.destinationViewController;
        Profile* temp = [profiles objectAtIndex:indexPath.row];
        destViewController.matchName = temp.name;
        destViewController.town = temp.location;
        destViewController.contact = temp.phone;
        destViewController.interests = self.tabBar.interests;
        destViewController.id = temp.id;
    }
}
@end
