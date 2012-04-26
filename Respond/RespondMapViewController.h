//
//  RespondMapViewController.h
//  Respond
//
//  Created by Troy Parkinson on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "PbAddressAnnotation.h"

@interface RespondMapViewController : UIViewController <MKMapViewDelegate>
{
    PbAddressAnnotation *annotation;
}

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) CLLocationCoordinate2D coord;

@end
