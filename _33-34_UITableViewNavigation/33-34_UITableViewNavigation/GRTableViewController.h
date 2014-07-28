//
//  GRTableViewController.h
//  33-34_UITableViewNavigation
//
//  Created by Exo-terminal on 6/21/14.
//  Copyright (c) 2014 Evgenia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GRTableViewController : UITableViewController

@property(strong,nonatomic)NSString* path;
@property(strong, nonatomic)NSString* renameFile;

- (IBAction)actionCreateNewDirectory:(UIBarButtonItem *)sender;
@end
