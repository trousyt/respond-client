//
//  PbCLClassController.m
//  Respond
//
//  Created by Troy Parkinson on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PbCLClassController.h"

@implementation PbCLClassController
@synthesize locationManager;
@synthesize delegate;

- (id) init 
{
    self = [super init];
    if (self != nil) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
    }
    
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"PbCLClassController:Location: %@", newLocation.description);
    [self.delegate locationUpdate:newLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"PbCLClassController:Failed with error %@", error.description);
    [self.delegate locationError:error];
}

@end
