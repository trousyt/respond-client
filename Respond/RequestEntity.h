//
//  RequestEntity.h
//  Respond
//
//  Created by Troy Parkinson on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EntityBase.h"
#import "RequestEntityCollection.h"
#import "ItemEntityCollection.h"
#import "PropertyEntity.h"

@interface RequestEntity : EntityBase
{
    PropertyEntity *property;
    ItemEntityCollection *items;
}

@property (strong, nonatomic) NSNumber *requestId;
@property (strong, nonatomic) NSNumber *userId;
@property (strong, nonatomic) NSNumber *propertyId;
@property (strong, nonatomic) NSString *requiredForms;
@property (strong, nonatomic) NSString *otherNotes;

+ (void)getAllRequestsWithDelegate:(id<PbConnectionDelegate>)delegate;
+ (void)getRequestWithId:(NSInteger)requestId andDelegate:(id<PbConnectionDelegate>)delegate;
+ (void)getRequestsWithPropertyId:(NSInteger)propertyId andDelegate:(id<PbConnectionDelegate>)delegate;

- (PropertyEntity*)propertyEntity;
- (void)setPropertyEntity:(PropertyEntity*)value;
- (ItemEntityCollection*)itemEntities;
- (void)setItemEntities:(ItemEntityCollection*)value;

- (NSMutableArray*)requiredFormsArray;


@end
