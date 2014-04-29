//
//  TagsViewController.m
//  HelloWorld
//
//  Created by Kamil on 25/02/14.
//  Copyright (c) 2014 Kamil. All rights reserved.
//

#import "TagsViewController.h"
#import "TagViewCell.h"
#import "iOSConstants.h"

@interface TagsViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UIAlertViewDelegate>
@property NSMutableArray *tags;
@end

@implementation TagsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIBarButtonItem *bbAddTag = [[UIBarButtonItem alloc] initWithTitle:@"Dodaj"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(showAddTag)];
    self.navigationItem.rightBarButtonItem = bbAddTag;
    
    self.tags = [[NSMutableArray alloc] initWithObjects:@"lorem", @"ipsum", @"dolor", @"sit", @"amet", nil];
}

- (void)showAddTag
{
    UIAlertView *addTag = [[UIAlertView alloc] initWithTitle:@"Nowy tag"
                                                        message:@"Podaj nazwę taga:"
                                                       delegate:self
                                              cancelButtonTitle:@"Anuluj"
                                              otherButtonTitles:@"Zapisz", nil];
    addTag.alertViewStyle = UIAlertViewStylePlainTextInput;
    [addTag show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }
    
    NSString *tag = [[alertView textFieldAtIndex:0] text];
    
    [self.tags addObject:tag];
    [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:[self.tags count] - 1 inSection:0]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.tags count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TagViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor whiteColor]];
    [cell.label setText:[NSString stringWithFormat:@"%@", [self.tags objectAtIndex:[indexPath row]]]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"clicked");
    TagViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    DLog(@"removing %@", cell.label.text);
    [self.tags removeObject:cell.label.text];
    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender NS_AVAILABLE_IOS(5_0)
{
    DLog(@"Segue");
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:32]};
    NSString *text = self.tags[indexPath.row];
    return [text sizeWithAttributes:attributes];
}

@end

