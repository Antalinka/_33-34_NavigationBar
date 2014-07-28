//
//  GRFileCell.m
//  33-34_UITableViewNavigation
//
//  Created by Exo-terminal on 6/21/14.
//  Copyright (c) 2014 Evgenia. All rights reserved.
//

#import "GRFileCell.h"

@implementation GRFileCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)actionEditText:(id)sender {
    
}
@end
