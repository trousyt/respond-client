//
//  PbAddressAnnotation.m
//  Respond
//
//  Created by Troy Parkinson on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PbAddressAnnotation.h"

@implementation PbAddressAnnotation
@synthesize coordinate;

- (NSString *)subtitle {
    return @"Subtitle";
}

- (NSString *)title {
    return @"Title";
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord {
    coordinate = coord;
    NSLog(@"%f,%f", coord.latitude, coord.longitude);
    return self;
}

@end
