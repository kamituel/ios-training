//
//  CustomersViewController.m
//  CoreDataDemo
//
//  Created by Kamil on 27/02/14.
//  Copyright (c) 2014 Kamil. All rights reserved.
//

#import "CustomersViewController.h"
#import "AppDelegate.h"
#import "User.h"
#import "User+Helper.h"
#import <AHAlertView/AHAlertView.h>
#import <SLCoreDataStack.h>

@interface CustomersViewController () <NSFetchedResultsControllerDelegate, UISearchBarDelegate>
@property NSFetchedResultsController *controller;
@end

@implementation CustomersViewController

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
    
    [self loadNavigationButtons];
    [self loadData];
    
    
    UISearchBar *bar = [[UISearchBar alloc] init];
    [bar sizeToFit];
    
    bar.delegate = self;
    
    self.tableView.tableHeaderView = bar;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Buttons

- (void)loadNavigationButtons
{
    UIBarButtonItem *bbAdd = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                              target:self
                                                                              action:@selector(actionAdd)];
    
    UIBarButtonItem *bbImport = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward
                                                                           target:self
                                                                           action:@selector(actionImport)];
    
    [self.navigationItem setRightBarButtonItems:@[bbAdd, bbImport] animated:NO];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void) actionAdd
{
    AHAlertView *alert = [[AHAlertView alloc] initWithTitle:@""
                                                    message:@"Podaj \"Nazwisko imie\""];
    __weak AHAlertView *weakAlert = alert;
    
    alert.alertViewStyle = AHAlertViewStylePlainTextInput;
    [alert addButtonWithTitle:@"Dodaj" block:^{
        NSString *name = [weakAlert textFieldAtIndex:0].text;
        NSArray *name_parts = [name componentsSeparatedByString:@" "];
        
        NSManagedObjectContext *moc = [APP managedObjectContext];
        
        User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:moc];
        user.firstname = [name_parts firstObject];
        user.lastname = [name_parts lastObject];
        
        [APP saveContextWithBlock:^(NSError *error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"blad"
                                                            message: [error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }];
        
    }];
    [alert show];
}

- (void)actionImport
{
    DLog();
    
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"sample" ofType:@"json"];
    NSData *json = [NSData dataWithContentsOfFile:jsonPath];
    
    if (json == nil) {
        DLog(@"No file found: %@", jsonPath);
        return;
    }
    
    NSError *error;
    NSArray *users = [NSJSONSerialization JSONObjectWithData:json
                                                     options:0
                                                       error:&error];
    
    if (error != nil) {
        DLog(@"JSON import error: %@", error);
        return;
    }
    
    
    
    NSManagedObjectContext *localMoc = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [localMoc setParentContext:[APP managedObjectContext]];
    
    //NSManagedObjectContext *localMoc = [[DataBaseManager sharedInstance] newManagedObjectContextWithConcurrencyType:NSPrivateQueueConcurrencyType];
    
    [localMoc performBlock:^{
        for (NSDictionary *item in users) {
            User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:localMoc];
            
            user.firstname = item[@"firstname"];
            user.lastname = item[@"lastname"];
            
            DLog(@"IMportuję user: %@", user);
            
            NSError *error;
            [localMoc save:&error];
        }
        
        [APP saveContextWithBlock:^(NSError *error) {
            
            if (!error)
                return;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"blad"
                                                                message: [error localizedDescription]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                
                [alert show];
            });
        }];
    }];
    

}

#pragma mark - Table view data source

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.controller.sectionIndexTitles;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = [self.controller.sections objectAtIndex:section];
    return [sectionInfo name];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.controller.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> sectionInfo = [self.controller.sections objectAtIndex:section];
    
    NSUInteger count = [sectionInfo numberOfObjects] ;// [[self.controller fetchedObjects] count];
    DLog(@"user count %d", count);
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    //cell.textLabel.text = [NSString stringWithFormat:@"sec %d row %d", [indexPath section], [indexPath row]];
    User *user = [_controller objectAtIndexPath:indexPath];
    cell.textLabel.text = [user fullName];
    
    return cell;
}

#pragma mark - Database
/*- (void)loadData
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"User"];
    NSError *error = nil;
    
    self.users = [[APP managedObjectContext] executeFetchRequest:request error:&error];
    if (error != nil) {
        DLog(@"%@", error);
    }
}*/

- (void)loadData
{
    [self loadDataWithQuery:nil];
}

- (void)loadDataWithQuery:(NSString *)query
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"User"];
    
    NSSortDescriptor *sortFirstLetter = [[NSSortDescriptor alloc] initWithKey:@"firstLetter" ascending:YES];
    NSSortDescriptor *sortFirstName = [[NSSortDescriptor alloc] initWithKey:@"firstname" ascending:YES];
    [request setSortDescriptors:@[sortFirstLetter, sortFirstName]];
    
    if (query.length > 0) {
        NSPredicate *search = [NSPredicate predicateWithFormat:@"(firstname contains[cd] %@) or (lastname contains[cd] %@)", query, query];
        [request setPredicate:search];
    }
    
    /* Has to be instance member, to avoid releasing by ARC. */
    self.controller = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                     managedObjectContext:[APP managedObjectContext]
                                                       sectionNameKeyPath:@"firstLetter"
                                                                cacheName:nil];
    [self.controller setDelegate:self];
    
    NSError *error = nil;
    [self.controller performFetch:&error];
    
    if (error != nil) {
        DLog(@"%@", error);
    }
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
        
        User *user = [_controller objectAtIndexPath:indexPath]; //[self.users objectAtIndex:[indexPath row]];
        
        [[APP managedObjectContext] deleteObject:user];
        
        [APP saveContextWithBlock:^(NSError *error) {
            DLog(@"%@", error);
        }];
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


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    User *user = [_controller objectAtIndexPath:indexPath]; //[self.users objectAtIndex:[indexPath row]];
    
    user.lastname = user.lastname;
    
    [APP saveContextWithBlock:nil];
    
    // Navigation logic may go here, for example:
    // Create the next view controller.
    //<#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];

    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    //[self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark - Search bar

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self loadDataWithQuery:searchText];
    [self.tableView reloadData];
}

@end
