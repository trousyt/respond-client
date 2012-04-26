//
//  RespondNewPickRequiredForms.m
//  Respond
//
//  Created by Troy Parkinson on 3/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RespondNewPickRequiredFormsViewController.h"

@implementation RespondNewPickRequiredFormsViewController
@synthesize tableView;
@synthesize parentView;
@synthesize selectedForms;
@synthesize delimitedString;

- (NSString*)delimitedString
{
    // Return a list of strings delimited by a pipe.
    NSMutableString *string = [[NSMutableString alloc] init];
    
    if (selectedForms)
    {
        for (NSString *item in selectedForms)
        {
            [string appendFormat:@"%@|", item];
        }
    }
    
    return string;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
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

- (void)viewDidLoad
{    
    delimitedString = [[NSString alloc] init];
    if (selectedForms == nil) {
        selectedForms = [[NSMutableArray alloc] init];
    }
    
    
    NSLog(@"Required Forms: %@", selectedForms);
    // If we don't have the list of forms in memory, get them from the server.
    if (requiredForms == nil) {
        [RequiredFormEntity getAllRequiredFormsWithDelegate:self];
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

- (void)viewWillDisappear:(BOOL)animated
{
    // Send the delimited string back to the parent;
    [self.parentView receiveString:self.delimitedString];
}

#pragma mark -
#pragma mark UITableViewDelegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [requiredForms count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{  
    // Set up
    NSString *identifier = @"CellIdentifier";
    
    // Attempt to get a previously constructed cell...
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    // Set cell details;
    cell.textLabel.text = [[requiredForms objectAtIndex:indexPath.row] name];
    
    if ([selectedForms containsObject:[[requiredForms objectAtIndex:indexPath.row] name]]) 
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        [selectedForms addObject:[[requiredForms objectAtIndex:indexPath.row] name]];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else
    {
        [selectedForms removeObject:[[requiredForms objectAtIndex:indexPath.row] name]];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    [cell resignFirstResponder];
}
         
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Selected");
}

#pragma mark -
#pragma mark PbConnectionDelegate Methods

- (void)entity:(id)sender didReceiveData:(NSUInteger)bytes
{
    // Empty.
}

- (void)entityGetDidComplete:(id)sender
{
    requiredForms = (RequiredFormCollection*)sender;
    [self.tableView reloadData];
}

- (void)entityGetDidFail:(id)sender withError:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"Could not retrieve the list of forms at this time." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alertView show];
}

@end
