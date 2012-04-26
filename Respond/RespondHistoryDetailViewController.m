//
//  RespondDetailViewController.m
//  Respond
//
//  Created by Troy Parkinson on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RespondHistoryDetailViewController.h"
#import "RespondItemsViewController.h"
#import "RespondMapViewController.h"

#define kItemsTableView 1
#define kFormsTableView 2

@implementation RespondHistoryDetailViewController
@synthesize detailItem;
@synthesize viewContext;
@synthesize mapView;
@synthesize scrollView;
@synthesize addressText;
@synthesize notesTextView;
@synthesize titleLabel;

#pragma mark - Managing the detail item
- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.notesTextView.text = detailItem.otherNotes;
        self.navigationItem.title = detailItem.propertyEntity.street;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [scrollView setScrollEnabled:YES];
    [scrollView setContentSize:CGSizeMake(320, 450)];
    
    // Pre-populate the controls with data.
    [self.addressText setText:[NSString stringWithFormat:@"%@, %@, %@ %@", detailItem.propertyEntity.street, detailItem.propertyEntity.city, detailItem.propertyEntity.state, detailItem.propertyEntity.postalCode]];
        
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Detail", @"Detail");
    }
    return self;
}

#pragma mark -
#pragma mark Segue Handler Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"itemView"]) {
        RespondItemsViewController *detail = [segue destinationViewController];
        
        // Pass the data.
        detail.viewContext = self.viewContext;
        detail.detailItems = detailItem.itemEntities;
    } 
    else if ([segue.identifier isEqualToString:@"mapView"]) {
        RespondMapViewController *detail = [segue destinationViewController];
        
        // Pass the coordinates.
        CLLocationCoordinate2D coord;
        coord.latitude = [[detailItem.propertyEntity latitude] doubleValue];
        coord.longitude = [[detailItem.propertyEntity longitude] doubleValue];
        [detail setCoord:coord];
    }
}

#pragma mark -
#pragma mark Table View Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if ([tableView tag] == kItemsTableView) {
        return 0;
    }
    else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView tag] == kItemsTableView) {
        return 1;
    }
    else if ([tableView tag] == kFormsTableView) {
        return [detailItem.requiredFormsArray count];
    }
    
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"CellIdentifier";
    
    if ([tableView tag] == kItemsTableView) {
        if (indexPath.row == 1) {
            cellIdentifier = @"DetailCellIdentifier";
        }
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // If no cell returned, create one.
    if (cell == nil) {
        UITableViewCellStyle style = UITableViewCellStyleValue1;
        
        if ([tableView tag] == kItemsTableView) {
            if (indexPath.row == 1) {
                style = UITableViewCellStyleSubtitle;
            }
        }
        
        cell = [[UITableViewCell alloc] initWithStyle:style reuseIdentifier:cellIdentifier];
    }
    
    if ([tableView tag] == kItemsTableView) {
        // Items TableView
        if (indexPath.row == 0) {
            cell.textLabel.text = [NSString stringWithFormat:@"%d Items", [detailItem.itemEntities count]];
            
            NSString *path = [[NSBundle mainBundle] pathForResource:@"todo" ofType:@"png"];
            cell.imageView.image = [UIImage imageWithContentsOfFile:path];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else {
            cell.textLabel.text = @"Notes";
            cell.detailTextLabel.text = detailItem.otherNotes;
        }        
    }
    else {
        // Forms TableView
        cell.textLabel.text = [detailItem.requiredFormsArray objectAtIndex:[indexPath row]];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"tag" ofType:@"png"];
        cell.imageView.image = [UIImage imageWithContentsOfFile:path];
    }
    
    return cell;
}

#pragma mark -
#pragma mark Controller Action Methods
- (IBAction)mapMarkerButtonPressed:(id)sender
{
}

@end
