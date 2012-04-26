//
//  RespondHistoryItemsViewController.m
//  Respond
//
//  Created by Troy Parkinson on 2/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RespondItemsViewController.h"
#import "RespondConstants.h"

@implementation RespondItemsViewController
@synthesize parentView;
@synthesize detailItems;
@synthesize viewContext;
@synthesize addItemView;
@synthesize tableView;
@synthesize addTextField;
@synthesize chosenImage;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{    
    self.navigationItem.title = @"Items";
    self.navigationItem.backBarButtonItem.title = @"Request"; // N/W
    
    // If editing enabled, modify the placement of controls.
    if (self.viewContext == PBUIViewContextEditable || self.viewContext == PBUIViewContextNew) {
        
        // Hide the navigation bar at the top.
        //[self.navigationController setNavigationBarHidden:YES animated:YES];
        
        // Unhide the add view and...
        [self.addItemView setHidden:NO];
        
        // Create a shadow.
        self.addItemView.layer.shadowOffset = CGSizeMake(0,5);
        self.addItemView.layer.shadowRadius = 2;
        self.addItemView.layer.shadowOpacity= .5;
        
        // Change the bounds of the table to shift it down.
        struct CGRect bounds;
        bounds = tableView.frame;
        bounds.origin.y = addItemView.bounds.size.height;
        self.tableView.frame = bounds;
        
        // By default, make text box the first responder.
        [addTextField becomeFirstResponder];
    }
    else {
        // For "view" context
    }
    
    [super viewDidLoad];
}

- (IBAction)gestureDidSwipe:(UISwipeGestureRecognizer *)sender
{
    NSLog(@"Geture action called");
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    // Send the data back to the parent if one expects it.
    if (parentView) {
        [parentView receiveEntities:detailItems];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)addItem:(NSString*)text withImage:(UIImage*)image
{
    if (self.detailItems == nil) {
        self.detailItems = [[ItemEntityCollection alloc] init];
    }
    
    ItemEntity *item = [[ItemEntity alloc] init];
    item.description = text;
    item.image1x = image;
    [self.detailItems addObject:item];
    
    NSLog(@"Count: %d", [self.detailItems count]);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // Add the item data to the data array.
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"landscape_ph" ofType:@"png"];
    chosenImage = [[UIImage alloc] initWithContentsOfFile:path];
    [self addItem:textField.text withImage:chosenImage];
    
    // Resign the keyboard and call for table data to reload.
    chosenImage = nil;
    textField.text = @"";
    [self.addTextField resignFirstResponder];    
    [self.tableView reloadData];
    [self.addTextField becomeFirstResponder];

    return NO;
}

#pragma mark -
#pragma mark UITableViewController Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return detailItems.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"DefaultCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    ItemEntity *item = [detailItems objectAtIndex:[indexPath row]];
    cell.textLabel.text = item.description;    
    cell.imageView.image = item.image1x;
    
    /*NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"landscape_ph" ofType:@"png"];
    cell.imageView.image =  [UIImage imageWithContentsOfFile:path]; //item.image2x;*/
    
    return cell;
}

#pragma mark -
#pragma mark Custom Handler Methods

- (IBAction)imageTouched:(id)sender
{
//#ifndef DEBUG
    // Initialize the camera API.
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    //imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString*)kUTTypeImage, nil];
    imagePicker.allowsEditing = YES;
    
    // And show the view controller.
    [self presentModalViewController:imagePicker animated:YES];

//#endif
}

@end
