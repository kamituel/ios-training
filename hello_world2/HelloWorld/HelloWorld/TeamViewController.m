//
//  TeamViewController.m
//  HelloWorld
//
//  Created by Kamil on 25/02/14.
//  Copyright (c) 2014 Kamil. All rights reserved.
//

#import "TeamViewController.h"
#import "TeamMemberViewController.h"
#import "PersonCell.h"
#import "iOSConstants.h"

@interface TeamViewController ()
@property (strong) NSMutableArray *teamMembersArray;
@end

@implementation TeamViewController

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
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    self.title = @"Witaj";
    UIBarButtonItem *bbAddMember = [[UIBarButtonItem alloc] initWithTitle:@"Dodaj"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(showAddMember)];
    self.navigationItem.rightBarButtonItem = bbAddMember;
    
    self.teamMembersArray = [[NSMutableArray alloc] initWithObjects:@"Jas", @"Malgosia", @"Krzysio", nil];
    [self.teamMembersArray sortUsingSelector:@selector(localizedCompare:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showAddMember
{
    UIAlertView *addMember = [[UIAlertView alloc] initWithTitle:@"Nowa osoba"
                                                       message:@"Podaj imię nowej osoby:"
                                                      delegate:self
                                             cancelButtonTitle:@"Anuluj"
                                             otherButtonTitles:@"Zapisz", nil];
    addMember.alertViewStyle = UIAlertViewStylePlainTextInput;
    [addMember show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }
    
    NSString *name = [[alertView textFieldAtIndex:0] text];
    DLog(@"Button %d, name %@", buttonIndex, name);
    
    [self.teamMembersArray addObject:name];
    
    [self.teamMembersArray sortUsingSelector:@selector(localizedCompare:)];
    
    /*[self.teamMembersArray sortUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return [obj1 localizedCompare:obj2];
    }];*/
    
    NSInteger indexOfObject = [self.teamMembersArray indexOfObject:name];
    NSIndexPath *indexPathOfObject = [NSIndexPath indexPathForRow:indexOfObject inSection:0];
    
    //[self.tableView reloadData];
    [self.tableView insertRowsAtIndexPaths:@[indexPathOfObject] withRowAnimation:(UITableViewRowAnimationAutomatic)];
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
    return [self.teamMembersArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    PersonCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSString *name = [self.teamMembersArray objectAtIndex:[indexPath row]];
    cell.textLabel.text = name;
    cell.name = name;
    // Configure the cell...
    
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


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.teamMembersArray removeObjectAtIndex:[indexPath row]];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


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

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    DLog(@"adasdasd --- %@ dest class %@", NSStringFromClass([sender class]), NSStringFromClass([[segue destinationViewController] class]));
    id destVC = [segue destinationViewController];
    if ([destVC isKindOfClass:[TeamMemberViewController class]]) {
        NSString *name = [(PersonCell *) sender name];
        DLog(@"name %@", name);
        [(TeamMemberViewController *) destVC setName:name];
    }
}

 

@end
