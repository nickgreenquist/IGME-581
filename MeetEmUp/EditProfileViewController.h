//
//  EditProfileViewController.h
//  MeetEmUp
//
//  Created by Student on 4/19/15.
//  Copyright (c) 2015 Nathaniel Kierpiec Nick Greenquist Dylan Coats Max Peabody. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarController.h"
#import "InterestTableCell.h"

@interface EditProfileViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property NSInteger id;
@property NSString *interests;
@property NSArray *interestsArray;
@property NSMutableArray*interestsArrayM;
@property (strong, nonatomic) IBOutlet UIView *editProfView;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITableView *interestTable;
@property (weak, nonatomic) IBOutlet UITextField *townField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property NSMutableArray* peopleYouMatched;
@property NSMutableArray* mutualMatches;

@property NSInteger numCells;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)SaveChanges:(id)sender;
- (IBAction)AddInterest:(id)sender;
- (IBAction)takePhoto:(id)sender;
- (IBAction)selectPhoto:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *interestText;
@property (nonatomic, assign) BOOL alreadyExists;

@property TabBarController *tabBar;

@end
