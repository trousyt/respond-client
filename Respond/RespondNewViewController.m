//
//  RespondHistoryDetailNewViewController.m
//  Respond
//
//  Created by Troy Parkinson on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RespondNewViewController.h"
#import "RespondItemsViewController.h"
#import "RespondNewPickRequiredFormsViewController.h"

#define kTableSectionItems 0
#define kTableSectionForms 1

@implementation RespondNewViewController
@synthesize itemsArray;
@synthesize locationController;
@synthesize locationActivityIndicator;
@synthesize locationLabel;
@synthesize locationActivityView;
@synthesize locationView;
@synthesize itemsTableView;
@synthesize scrollView;

@synthesize addressStreet;
@synthesize addressCity;
@synthesize addressState;
@synthesize addressZip;
@synthesize notes;

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    request = [[RequestEntity alloc] init];
    
    // Initialize the scroll view.
    [scrollView setScrollEnabled:YES];
    [scrollView setContentSize:CGSizeMake(320, 450)];
    
    // Start the indicator animating.
    [locationActivityIndicator startAnimating];
    
    // Now instantiate the CoreLocation class and register ourselves.
    locationController = [[PbCLClassController alloc] init];
    locationController.delegate = self;
    locationController.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [locationController.locationManager startUpdatingLocation];
}

- (void)viewDidAppear:(BOOL)animated
{
    // Store the number of items from the items array if different.
    if (lastItemsCount != [itemsArray count]) {
        lastItemsCount = [itemsArray count];
        [itemsTableView reloadData];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}

- (IBAction)backgroundTapped:(id)sender
{
    // Unregister all editing controls as FirstResponder
    [self.addressStreet resignFirstResponder];
    [self.addressCity resignFirstResponder];
    [self.addressState resignFirstResponder];
    [self.addressZip resignFirstResponder];
    [self.notes resignFirstResponder];
}

- (void)updateAddressInformation:(CLPlacemark*)placemark
{
    // Stop the activity indicator.
    [self.locationActivityIndicator stopAnimating];
    [self.locationActivityView setHidden:YES];
    [self.locationView setHidden:NO];
    
    
    // If a location actually retrieved, use those values as defaults.
    if (placemark != nil)
    {
        // Update the text fields with address information.
        self.addressStreet.text = [NSString stringWithFormat:@"%@ %@", placemark.subThoroughfare, placemark.thoroughfare];
        self.addressCity.text = placemark.locality;
        self.addressZip.text = placemark.postalCode;
        addressLatitude = placemark.location.coordinate.latitude;
        addressLongitude = placemark.location.coordinate.longitude;
        
        
        // Get the 2-character state abbreviation instead of the full name.
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *path = [bundle pathForResource:@"USStateAbbreviations" ofType:@"plist"];
        NSDictionary *stateDict = [[NSDictionary alloc] initWithContentsOfFile:path];
        
        self.addressState.text = [stateDict objectForKey:[placemark.administrativeArea uppercaseString]];
        
        
    }
}

#pragma mark -
#pragma mark Segue Handler Methods
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    RespondItemsViewController *view = [segue destinationViewController];
    view.viewContext = PBUIViewContextNew;
    view.detailItems = request.itemEntities;
    [view setParentView:self];
}

#pragma mark -
#pragma mark PbReceivesEntity Protocol Methods
- (void)receiveEntities:(EntityCollection *)entities
{
    request.itemEntities = (ItemEntityCollection*)entities;
    [itemsTableView reloadData];
}

#pragma mark -
#pragma mark PbReceivesDelimitedString Protocol Methods
- (void)receiveString:(NSString *)string
{
    request.requiredForms = string;
    [itemsTableView reloadData]; 
    /*
     NSLog(@"Got back: %@", string);
    NSLog(@"Entity val set to: %@", request.requiredForms);
    NSLog(@"Required Forms Count: %d", [request.requiredFormsArray count]);
     */
}

#pragma mark -
#pragma mark Instance Handler Methods

- (void)textControlDidBeginEditing:(UIView*)textControl
{
    CGRect textFieldRect = [self.view.window convertRect:textControl.bounds fromView:textControl];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    // Get a fraction we'll use below...
    if (heightFraction < 0.0) {
        heightFraction = 0.0;
    } else if (heightFraction > 1.0) {
        heightFraction = 1.0;
    }
    
    // Account for screen orientation...
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    } else {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    // Start the animation...
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}

- (void)textControlDidEndEditing:(UIView*)textField
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self textControlDidBeginEditing:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self textControlDidEndEditing:textField];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self textControlDidBeginEditing:textView];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self textControlDidEndEditing:textView];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)cancelButtonPressed:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)saveButtonPressed:(id)sender
{
    // Construct the request object.
    PropertyEntity *property = [[PropertyEntity alloc] init];
    property.street = addressStreet.text;
    property.city = addressCity.text;
    property.state = addressState.text;
    property.postalCode = addressZip.text;
    property.latitude = [NSNumber numberWithDouble:addressLatitude];
    property.longitude = [NSNumber numberWithDouble:addressLongitude];
    
    request.propertyEntity = property;
    request.otherNotes = notes.text;
    
    // Prepare the data for POST back to the server.
    [request save];
    
    // Dismiss this view form the screen.
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Table View Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Looking for cell for section %d, index %d", indexPath.section, indexPath.row);
    
    NSString *cellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // If no cell returned, create one.
    if (cell == nil) {
        UITableViewCellStyle style = UITableViewCellStyleDefault;
        cell = [[UITableViewCell alloc] initWithStyle:style reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.section == kTableSectionItems) {
        // Items section
        if (indexPath.row == 0) {
            cell.textLabel.text = [NSString stringWithFormat:@"%d Items", [request.itemEntities count]];
 
            NSString *path = [[NSBundle mainBundle] pathForResource:@"todo" ofType:@"png"];
            cell.imageView.image = [UIImage imageWithContentsOfFile:path];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }     
    }
    else if (indexPath.section == kTableSectionForms) {
        // Required Forms section
        NSLog(@"CellForIndex: %@", request.requiredFormsArray);
        cell.textLabel.text = [NSString stringWithFormat:@"%d Required Forms", [request.requiredFormsArray count]];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"tag" ofType:@"png"];
        cell.imageView.image = [UIImage imageWithContentsOfFile:path];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Load the storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    
    // Resign first responders.
    [self.notes resignFirstResponder];
    
    if (indexPath.section == kTableSectionItems) {
        // Items section
        RespondItemsViewController *itemsView = [storyboard instantiateViewControllerWithIdentifier:@"RespondItemsView"];
        
        // Push the controller, passing the items array first.
        itemsView.viewContext = PBUIViewContextEditable;
        itemsView.parentView = self;
        itemsView.detailItems = request.itemEntities;
        [self.navigationController pushViewController:itemsView animated:YES];
        
    }
    else if (indexPath.section == kTableSectionForms) {
        // Required Forms section
        RespondNewPickRequiredFormsViewController *formsView = [storyboard instantiateViewControllerWithIdentifier:@"RespondPickRequiredFormsView"];
        
        // Push the controller.
        formsView.parentView = self;
        formsView.selectedForms = request.requiredFormsArray;
        [self.navigationController pushViewController:formsView animated:YES];
    }
}

#pragma mark -
#pragma mark PbCLControllerDelegate Delegate Methods
- (void)locationUpdate:(CLLocation *)location
{
    // Stop our CLLocation class from updating the phone's location.
    [locationController.locationManager stopUpdatingLocation];
    
    // We got the coordinates, so hide the activity indicator and reverse geocode to show the address.
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil) {
            if (placemarks.count > 0) {
                // Update the GUI.
                [self updateAddressInformation:[placemarks objectAtIndex:0]];
            }
        } else {
            [self locationError:error];
        }
    }];
    
}
     
- (void)locationError:(NSError *)error
{
    [self updateAddressInformation:nil];
    
    // Display a message to the user indicating failure.
    NSString *message = @"There was an error getting the location. Please try again...";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

@end
