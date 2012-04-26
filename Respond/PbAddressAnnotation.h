//
//  PbAddressAnnotation.h
//  Respond
//
//  Created by Troy Parkinson on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//



@interface PbAddressAnnotation : NSObject<MKAnnotation>
{
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subTitle;
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord;

@end
