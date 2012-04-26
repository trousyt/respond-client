//
//  RespondMapViewController.m
//  Respond
//
//  Created by Troy Parkinson on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RespondMapViewController.h"

@implementation RespondMapViewController
@synthesize mapView;
@synthesize coord;

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
    MKCoordinateSpan span;
    span.longitudeDelta = 0.2;
    span.latitudeDelta = 0.2;
    
    MKCoordinateRegion region;
    region.span = span;
    region.center = coord;
    [mapView setRegion:region];
    
    // Remove the annotation if it already exists (shouldn't happen).
    if (annotation != nil) {
        [mapView removeAnnotation:annotation];
    }
        
        annotation = [[PbAddressAnnotation alloc] initWithCoordinate:coord];
        
    
    [mapView addAnnotation:annotation];
    
    
    [super viewDidLoad];
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

- (MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *pinView = [[MKPinAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:@"pinAnnotationView"];
    
    pinView.pinColor = MKPinAnnotationColorRed;
    pinView.animatesDrop = TRUE;
    pinView.canShowCallout = NO;
    pinView.calloutOffset = CGPointMake(-5, 5);
    return pinView;
}

@end
