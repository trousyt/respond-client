//
//  RespondMasterViewController.m
//  Respond
//
//  Created by Troy Parkinson on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RespondHistoryViewController.h"
#import <YAJLiOS/YAJL.h>
#import "ItemEntity.h"


//#import "RespondDetailViewController.h"

@implementation RespondHistoryViewController

@synthesize detailViewController = _detailViewController;
@synthesize activityIndicator;
@synthesize theTableView;
@synthesize theScrollView;
@synthesize warningView;
@synthesize warningImage;

//@synthesize detailViewController = _detailViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"History", @"History");
    }
    return self;
}
							
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    // Set all default values on controls.
    [theScrollView setScrollEnabled:YES];
    [theScrollView setContentSize:CGSizeMake(320, 650)];
    activityIndicator.hidesWhenStopped = YES;
    
    // Get history data from the server.
    [self startLoadingHistory];
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
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

#pragma mark -
#pragma mark UITableViewDelegate Methods

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [requestCollection count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{        
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    // Set the display text of our cell.
    RequestEntity *request = [requestCollection objectAtIndex:[indexPath row]];
    cell.textLabel.text = request.propertyEntity.street;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@ %@", request.propertyEntity.city, request.propertyEntity.state, request.propertyEntity.postalCode];
    cell.detailTextLabel.minimumFontSize = 10.0f;
    
    return cell;
}

#pragma mark -
#pragma Segue Handler Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"Segue identifier: %@", segue.identifier);
    if ([[segue identifier] isEqualToString:@"AddModalSegue"]) {
        
        // This segue will load into a Navigation controller, so get that controller's 1st subview.
        RespondHistoryDetailViewController *details = [[[segue destinationViewController] viewControllers] objectAtIndex:0];
        details.title = @"New Request";
    }
    else {
        // This segue will load straight into the necessary view, so we'll just pass the data right in.
        NSIndexPath *path = [self.theTableView indexPathForSelectedRow];
        [segue.destinationViewController setDetailItem:[requestCollection objectAtIndex:[path row]]];
    }
}

#pragma mark -
#pragma mark Instance Helper Methods
- (void)startLoadingHistory
{
    [RequestEntity getAllRequestsWithDelegate:self];
    [activityIndicator startAnimating];
}

- (void)entity:(id)sender didReceiveData:(NSUInteger)bytes
{
    NSLog(@"In didReceiveData and received %d bytes", bytes);
}

- (void)entityGetDidComplete:(id)sender
{
    NSLog(@"Get did complete with object %@", sender);
    
    // Save the collection instance and tell the table to refresh.
    requestCollection = (RequestEntityCollection *)sender;
    [self.theTableView reloadData];
    [self.activityIndicator stopAnimating];
    [self.warningView setHidden:YES];
}

- (void)entityGetDidFail:(id)sender withError:(NSError *)error
{
    NSLog(@"An error did occur");
    [self.activityIndicator stopAnimating];
    [self.warningView setHidden:NO];
}

#pragma mark -
#pragma mark UIAction Methods
- (IBAction)refreshButtonPressed:(id)sender
{
    [self startLoadingHistory];
}

@end
