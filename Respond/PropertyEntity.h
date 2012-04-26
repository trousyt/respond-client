//
//  PropertyEntity.h
//  Respond
//
//  Created by Troy Parkinson on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EntityBase.h"
//#import "RequestEntity.h"

@interface PropertyEntity : EntityBase

@property (strong, nonatomic) NSNumber *propertyId;
@property (strong, nonatomic) NSString *street;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *postalCode;
@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;

+ (void)getPropertyWithId:(NSInteger)propertyId andDelegate:(id<PbConnectionDelegate>)delegate;

- (NSString*)fullAddressFormatted;

@end
