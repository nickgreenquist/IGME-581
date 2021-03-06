//
//  SearchListTVC.m
//  MeetEmUp
//
//  Created by Student on 5/7/15.
//  Copyright (c) 2015 Nathaniel Kierpiec Nick Greenquist Dylan Coats Max Peabody. All rights reserved.
//

#import "SearchListTVC.h"
#import "User.h"
#import "LoginViewController.h"
#import "Database.h"
#import "SearchedUserCell.h"
#import "MatchDetailViewController.h"

@interface SearchListTVC ()

@end

@implementation SearchListTVC{
    NSMutableArray* users;
    NSMutableArray* potentialMatches;
    Database* db;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    db = [[Database alloc] init];
    users = [NSMutableArray array];
    potentialMatches = [NSMutableArray array];
    self.tabBar = (TabBarController *)self.tabBarController;
    
    [db GetData:@"fetchusers.php" completion:^(NSDictionary* userResults){
        NSArray* allUsers = userResults[@"results"];
        
        for(NSDictionary* dic in allUsers)
        {
            User* user = [[User alloc] initWithDictionary:dic];
            
            [users addObject:user];
        }
        
        for(int i = 0; i < users.count; i++)
        {
            //dont add people we have already matched
            if([self.tabBar.peopleYouMatched isKindOfClass:[NSNull class]] || [self.tabBar.peopleYouMatched count] == 0)
            {
                //dont add yourself
                if(![[[users objectAtIndex:i] username] isEqualToString:self.tabBar.username])
                {
                    [potentialMatches addObject:[users objectAtIndex:1]];
                }
            } else{
                for(NSString* s in self.tabBar.peopleYouMatched)
                {
                    if([s integerValue] != [[users objectAtIndex:i] id])
                    {
                        //dont add yourself
                        if(![[[users objectAtIndex:i] username] isEqualToString:self.tabBar.username])
                        {
                            [potentialMatches addObject:[users objectAtIndex:i]];
                        }
                    }
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            //Run UI Updates
            [self.tableView reloadData];
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 145.0;
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [potentialMatches count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchedUser" forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchedUser"];
    }
    
    User* temp = [potentialMatches objectAtIndex:indexPath.row];
    SearchedUserCell* customCell = (SearchedUserCell*)cell;
    customCell.matchName.text = temp.username;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.name = @"he";
}


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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ViewMatch"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        MatchDetailViewController *destViewController = segue.destinationViewController;
        User* temp = [potentialMatches objectAtIndex:indexPath.row];
        destViewController.id = temp.id;
        destViewController.tabBar = self.tabBar;
    }
}

@end
