//
//  PbCLClassController.h
//  Respond
//
//  Created by Troy Parkinson on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark -
#pragma mark PBClControllerDelegate Protocol
@protocol PbCLControllerDelegate
@required
- (void)locationUpdate:(CLLocation *)location;
- (void)locationError:(NSError *)error;

@end

#pragma mark -
#pragma mark PBCLClassController Class

@interface PbCLClassController : NSObject <CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    id delegate;
}

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) id delegate;

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation;

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error;

@end
