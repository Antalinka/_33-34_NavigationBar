//
//  GRTableViewController.m
//  33-34_UITableViewNavigation
//
//  Created by Exo-terminal on 6/21/14.
//  Copyright (c) 2014 Evgenia. All rights reserved.
//

#import "GRTableViewController.h"
#import "GRFileCell.h"


typedef enum {
    GRTypeDirectoryFile,
    GRTypeDirectoryFolder
    
} GRTypeDirectory;

@interface GRTableViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate>

@property(strong,nonatomic)NSArray* contents;
@property(assign, nonatomic)NSInteger folderCount;
@property(strong,nonatomic)GRFileCell* myCell;
@property(strong,nonatomic)NSIndexPath* indexRow;
@property(assign, nonatomic)BOOL isHidden;
@property(assign, nonatomic)BOOL sortByType;
@end

@implementation GRTableViewController

- (id)initWithPath:(NSString*)path{
    
   self = [super initWithStyle:UITableViewStyleGrouped];

    if (self) {
        
        self.path = path;
        self.contents = [[NSFileManager defaultManager]contentsOfDirectoryAtPath:path error:nil];
        
    }
    return self;
}
-(void)loadView{
    
    [super loadView];
    [self createToolbarWithHiddenTitle:@"Hide"];
    
     self.tableView.editing = NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!self.path) {
        self.path = @"/Users/EXO-terminal/Desktop/ios_course";
        
    }
    
    UITapGestureRecognizer *doubleTapDoubleTouchGesture =
    [[UITapGestureRecognizer alloc]initWithTarget:self
                                           action:@selector(doubleHandleTapDoubleTouch:)];
    
    doubleTapDoubleTouchGesture.numberOfTapsRequired = 2;
    
    [self.view addGestureRecognizer:doubleTapDoubleTouchGesture];
     self.isHidden = NO;
     self.sortByType = NO;
    
  
}
#pragma mark - Toolbar

-(void)createToolbarWithHiddenTitle:(NSString*)title{
    
    [self.navigationController setToolbarHidden:NO];
    
    UIBarButtonItem *editButton = [[ UIBarButtonItem alloc ] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                                  target:self
                                                                                  action:@selector(editTable:)];
    
    UIBarButtonItem *hideButton = [[UIBarButtonItem alloc]initWithTitle:title
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(hideSystemFiles:)];
    UIBarButtonItem *sortType = [[UIBarButtonItem alloc]initWithTitle:@"SortByType"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(sortByType:)];
    
    self.toolbarItems = [ NSArray arrayWithObjects: editButton, hideButton, sortType, nil];
}

-(void)sortByType:(UIBarButtonItem*)barButton{
    
    self.sortByType = !self.sortByType;
    
    NSMutableArray* tempArray = [NSMutableArray array];
    
    for (NSString* string in self.contents) {
        
        NSInteger firstIndex = 0;
        NSInteger lastIndex = [tempArray count];
        
        NSString* pathName = [self.path stringByAppendingPathComponent:string];
        
        BOOL isDirectory = NO;
        [[NSFileManager defaultManager]fileExistsAtPath:pathName isDirectory:&isDirectory];
        
        
        if (self.sortByType) {
            isDirectory = !isDirectory;
        }
        if ([tempArray count] == 0) {
            [tempArray addObject:string];
        }else if (isDirectory) {
            [tempArray insertObject:string atIndex:firstIndex];
        }else{
            [tempArray insertObject:string atIndex:lastIndex];
        }
     }
    
    self.contents = tempArray;
    [self.tableView reloadData];
}

-(void)hideSystemFiles:(UIBarButtonItem*)barButton{
    
    self.isHidden = !self.isHidden;
    
    if (self.isHidden) {
        
        NSArray* array = [self.contents filteredArrayUsingPredicate: [NSPredicate predicateWithFormat: @"SELF beginswith %@", @"."]];
        
        for (NSString* string in array) {
            
            if ([array count] > 0) {
                NSMutableArray* tempArray = [NSMutableArray arrayWithArray:self.contents];
                [tempArray removeObject:string];
                
                self.contents = tempArray;
                [self createToolbarWithHiddenTitle:@"Unhide"];
            }

        }
    }else{
        
//         self.contents =
        //[[NSFileManager defaultManager]contentsOfDirectoryAtPath:self.path error:nil];
        
        NSArray* newArray = [[NSFileManager defaultManager]contentsOfDirectoryAtPath:self.path error:nil];
        NSMutableArray* tempArray = [NSMutableArray arrayWithArray:newArray];
        for (NSString* string in self.contents) {
            
            if ([self.contents filteredArrayUsingPredicate: [NSPredicate predicateWithFormat: @"SELF beginswith %@", string]]) {
                [tempArray removeObject:string];
            }
        }
        
        if (tempArray) {
            
            [tempArray addObjectsFromArray:self.contents];
        }
        
        self.contents = tempArray;
        
        
         [self createToolbarWithHiddenTitle:@"Hide"];
            
        }
    
        [self.tableView reloadData];
    
    
}

-(void)sortTable:(UIBarButtonItem*)barButton{
}

-(void)editTable:(UIBarButtonItem*)barButton{

    BOOL isEditing = self.tableView.editing;
    [self.tableView setEditing:!isEditing animated:YES];
    
    if (self.tableView.editing) {
        
    UIBarButtonItem *editButton = [[ UIBarButtonItem alloc ] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                      target:self
                                                                                      action:@selector(editTable:)];
    self.toolbarItems = [ NSArray arrayWithObject: editButton];
        
    }else{
         [self createToolbarWithHiddenTitle:@"Hide"];
    }
}

-(int)countOfdirectoryWithString:(NSString*)string{
    
    NSArray* array = [self.contents filteredArrayUsingPredicate: [NSPredicate predicateWithFormat: @"SELF beginswith %@", string]];
    
    int newIndex = 0;
    int indexNewFolder = 0;
    
    for (int i = 0; i < [array count]; i++) {
        
        NSString* myString = [[array objectAtIndex:i] substringFromIndex:[[array objectAtIndex:i]length]-2];
        newIndex = [myString intValue];
        
        if (newIndex > indexNewFolder) {
            indexNewFolder = newIndex;
        }
    }
    
    return indexNewFolder;
}

-(void)setPath:(NSString *)path{
    
    _path = path;
    NSError* error = nil;
    
    self.contents = [[NSFileManager defaultManager]contentsOfDirectoryAtPath:path error:&error];
    if (error) {
        NSLog(@"error %@",[error localizedDescription]);
    }
    [self.tableView reloadData];
    
    self.navigationItem.title = [self.path lastPathComponent];
    
}
- (unsigned long long int)folderSize:(NSString *)folderPath {

        unsigned long long int result = 0;
        
        NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath error:nil];
        
        for (NSString *fileSystemItem in array) {
            BOOL directory = NO;
            [[NSFileManager defaultManager] fileExistsAtPath:[folderPath stringByAppendingPathComponent:fileSystemItem] isDirectory:&directory];
            if (!directory) {
                result += [[[[NSFileManager defaultManager] attributesOfItemAtPath:[folderPath stringByAppendingPathComponent:fileSystemItem] error:nil] objectForKey:NSFileSize] unsignedIntegerValue];
            }
            else {
                result += [self folderSize:[folderPath stringByAppendingPathComponent:fileSystemItem]];
            }
        }
        
        return result;
}

-(void)doubleHandleTapDoubleTouch:(UITapGestureRecognizer*)gestureRecognizer{
    
        CGPoint p = [gestureRecognizer locationInView:self.tableView];
        
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
        
        if (indexPath) {
            
            GRFileCell *cell = (GRFileCell*) [self.tableView cellForRowAtIndexPath:indexPath];
        
            NSString* tempString = cell.name.text;
            
            cell.textField.userInteractionEnabled = YES;
            cell.textField.text = tempString;
            cell.textField.delegate = self;
            
            [cell.textField becomeFirstResponder];
            cell.name.text = nil;
            
            self.indexRow = indexPath;
        }
}

-(BOOL)isDirectoryAtIndexPath:(NSIndexPath*)indexPath{
    
    NSString* fileName = [self.contents objectAtIndex:indexPath.row];
    NSString* pathName = [self.path stringByAppendingPathComponent:fileName];
    
    BOOL isDirectory = NO;
    
    [[NSFileManager defaultManager]fileExistsAtPath:pathName isDirectory:&isDirectory];
    
    return isDirectory;
}

- (NSString*) fileSizeFromValue:(unsigned long long) size {
    
    static NSString* units[] = {@"B", @"KB", @"MB", @"GB", @"TB"};
    static int unitsCount = 5;
    
    int index = 0;
    
    double fileSize = (double)size;
    
    while (fileSize > 1024 && index < unitsCount) {
        fileSize /= 1024;
        index++;
    }
    
    return [NSString stringWithFormat:@"%.2f %@", fileSize, units[index]];
}
#pragma mark - Actions

- (IBAction)actionCreateNewDirectory:(UIBarButtonItem *)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Choose type of directory"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"Done"
                                          otherButtonTitles:@"Folder", nil];
    [alert addButtonWithTitle:@"file"];
    [alert show];
      
}

-(void)createNewFolderWithTypeDirectory:(GRTypeDirectory)directory{
    
    NSString* nameFile = nil;
    
    if (directory == GRTypeDirectoryFile) {
        nameFile = @"read me";
    }else{
        nameFile = @"new folder";
    }
    
    int indexNewFolder = [self countOfdirectoryWithString:nameFile];
    
    NSString* newFolder = [NSString stringWithFormat:@"%@ %d",nameFile, indexNewFolder + 1];
    NSString* newPath = [self.path stringByAppendingPathComponent:newFolder];
    
    NSMutableArray* tempArray = nil;
    NSError* error = nil;
    
    if (directory == GRTypeDirectoryFolder)  {
        
        if (![[NSFileManager defaultManager]fileExistsAtPath:newPath]) {
            [[NSFileManager defaultManager]createDirectoryAtPath:newPath
                                     withIntermediateDirectories:NO
                                                      attributes:nil
                                                           error:&error];
        }
        

    }else{
        
        if (![[NSFileManager defaultManager]fileExistsAtPath:newPath]) {
            [[NSFileManager defaultManager]createFileAtPath:newPath
                                                   contents:nil
                                                 attributes:nil];
        }
    }
    
        if ([self.contents count] > 0) {
        tempArray = [NSMutableArray arrayWithArray:self.contents];
    }else{
        tempArray = [NSMutableArray array];
    }
    
    [tempArray insertObject:newFolder atIndex:0];
    self.contents = tempArray;
    
    [self.tableView beginUpdates];
    
    NSIndexPath* indexPath =[NSIndexPath indexPathForItem:0 inSection:0];
    
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    
    [self.tableView endUpdates];
    
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        
        [self createNewFolderWithTypeDirectory:GRTypeDirectoryFolder];
        
    }else if(buttonIndex == 2){
        
        [self createNewFolderWithTypeDirectory:GRTypeDirectoryFile];
    }
    
}


#pragma mark - UITableViewDataSource

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        NSMutableArray* temp = [NSMutableArray arrayWithArray:self.contents];
        
        NSString* fileName = [temp objectAtIndex:indexPath.row];
        NSString* newPath = [self.path stringByAppendingPathComponent:fileName];
        [temp removeObject:fileName];
        self.contents = temp;
        
        [[NSFileManager defaultManager]removeItemAtPath:newPath error:nil];
        
        [self.tableView beginUpdates];
        
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        
        [self.tableView endUpdates];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;
    
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    
    NSString* fileName = [self.contents objectAtIndex:sourceIndexPath.row];
    NSMutableArray* tempArray = [NSMutableArray arrayWithArray:self.contents];
    
    [tempArray removeObject:fileName];
    [tempArray insertObject:fileName atIndex:destinationIndexPath.row];
    
    self.contents = tempArray;
  }


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 
    return [self.contents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//   static NSString* identifierFolder = @"folderCell";
    static NSString* identifierFile = @"fileCell";
    
    NSString* fileName= [self.contents objectAtIndex:indexPath.row];
    
    if ([self isDirectoryAtIndexPath:indexPath]) {
          NSString* path = [self.path stringByAppendingPathComponent:fileName];
        
        GRFileCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierFile forIndexPath:indexPath];
        cell.name.text = fileName;
        
        UIImage* image = [UIImage imageNamed:@"folder1.png"];
        cell.image.image = image;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.dataLabel.text = nil;
       
        NSString* string = [self fileSizeFromValue:[self folderSize:path]];
        
        cell.detailText.text = string;
        return cell;

    }else{
        
        NSString* path = [self.path stringByAppendingPathComponent:fileName];
        
        GRFileCell* cell = [tableView dequeueReusableCellWithIdentifier:identifierFile forIndexPath:indexPath];
        cell.name.text = fileName;
        UIImage* image = [UIImage imageNamed:@"file1.png"];
        cell.image.image = image;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        NSDictionary* attributes = [[NSFileManager defaultManager]attributesOfItemAtPath:path error:nil];
//        NSDictionary* mein = [[NSFileManager defaultManager]attributesOfFileSystemForPath:fileName error:nil];
        
        static NSDateFormatter* dateFormatter = nil;
        
        if (!dateFormatter) {
            dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm a"];
        }
        
        NSDate* date = [attributes fileModificationDate];
        
        cell.dataLabel.text = [dateFormatter stringFromDate:date];
        cell.detailText.text = [self fileSizeFromValue:[attributes fileSize]];
        
        
        return cell;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self isDirectoryAtIndexPath:indexPath]) {
        
        NSString* fileName = [self.contents objectAtIndex:indexPath.row];
        NSString* pathName = [self.path stringByAppendingPathComponent:fileName];
        
        GRTableViewController* viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"basicTable"];
        viewController.path = pathName;
        
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
#pragma mark - UITextFieldDelegate -

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
  //create change string
    
    NSMutableArray* tempArray = [NSMutableArray arrayWithArray:self.contents];
    
    NSString* editName = [tempArray objectAtIndex:self.indexRow.row];
    
    NSString* oldPath = [self.path stringByAppendingPathComponent:editName];
    NSString* newPath = [self.path stringByAppendingPathComponent:textField.text];
    [[NSFileManager defaultManager]moveItemAtPath:oldPath toPath:newPath error:nil];
    
    [tempArray replaceObjectAtIndex:self.indexRow.row withObject:textField.text];
    self.contents = [NSArray arrayWithArray:tempArray];
    textField.text = nil;

    [self.tableView beginUpdates];
    
    [self.tableView reloadRowsAtIndexPaths:@[self.indexRow] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    
    textField.userInteractionEnabled = NO;
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

@end









