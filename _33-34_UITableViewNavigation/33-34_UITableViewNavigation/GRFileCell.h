//
//  GRFileCell.h
//  33-34_UITableViewNavigation
//
//  Created by Exo-terminal on 6/21/14.
//  Copyright (c) 2014 Evgenia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GRFileCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *detailText;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *dataLabel;
@property (weak, nonatomic) IBOutlet UIImageView *image;


//- (IBAction)actionEditText:(id)sender;

@end
