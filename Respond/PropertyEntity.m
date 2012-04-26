//
//  PropertyEntity.m
//  Respond
//
//  Created by Troy Parkinson on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PropertyEntity.h"
#import <YAJLiOS/YAJL.h>

@implementation PropertyEntity
@synthesize propertyId;
@synthesize street;
@synthesize city;
@synthesize state;
@synthesize postalCode;
@synthesize latitude;
@synthesize longitude;

+ (void)getPropertyWithId:(NSInteger)propertyId andDelegate:(id<PbConnectionDelegate>)delegate
{
    // Construct the URL.
    NSString *httpBaseUrl = [[ConfigurationData mainConfiguration] httpBaseUrl];    
    httpBaseUrl = [NSString stringWithFormat:@"%@/%@/%d", httpBaseUrl, @"properties", propertyId];
    
    // Create an instance and attempt connection.
    PropertyEntity *entity = [[PropertyEntity alloc] init];
    entity.delegate = delegate;
    [EntityBase connectToUrl:httpBaseUrl withDelegate:entity];
}

- (EntityBase*)initializeWithDictionary:(NSDictionary*)dict
{
    self.propertyId = [dict objectForKey:@"property_id"];
    self.street = [dict objectForKey:@"street"];
    self.city = [dict objectForKey:@"city"];
    self.state = [dict objectForKey:@"state"];
    self.postalCode = [dict objectForKey:@"postal_code"];
    self.latitude = [dict objectForKey:@"latitude"];
    self.longitude = [dict objectForKey:@"longitude"];
    self.createdAt = [dict objectForKey:@"created_at"];
    
    return self;
}

- (NSString*)fullAddressFormatted
{
    return [NSString stringWithFormat:@"%@, %@, %@ %@", self.street, self.city, self.state, self.postalCode];
}

#pragma mark -
#pragma mark YAJLParserDelegate Methods
- (id)JSON
{    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:self.street, @"street", self.city, @"city", self.state, @"state", self.postalCode, @"postal_code", self.latitude, @"latitude", self.longitude, @"longitude", nil];
    
    return dict;
}

@end
