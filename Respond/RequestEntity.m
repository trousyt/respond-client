//
//  RequestEntity.m
//  Respond
//
//  Created by Troy Parkinson on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RequestEntity.h"

@implementation RequestEntity
@synthesize requestId;
@synthesize userId;
@synthesize propertyId;
@synthesize requiredForms;
@synthesize otherNotes;

+ (void)getAllRequestsWithDelegate:(id<PbConnectionDelegate>)delegate;
{   
    // Construct the URL.
    NSString *httpBaseUrl = [[ConfigurationData mainConfiguration] httpBaseUrl];    
    httpBaseUrl = [NSString stringWithFormat:@"%@/%@", httpBaseUrl, @"requests"];
    
    // Create an instance and attempt connection.
    RequestEntityCollection *entityCollection = [[RequestEntityCollection alloc] init];
    entityCollection.delegate = delegate;    
    [EntityBase connectToUrl:httpBaseUrl withDelegate:entityCollection];
}

+ (void)getRequestWithId:(NSInteger)requestId andDelegate:(id<PbConnectionDelegate>)delegate;
{
    // Construct the URL.
    NSString *httpBaseUrl = [[ConfigurationData mainConfiguration] httpBaseUrl];    
    httpBaseUrl = [NSString stringWithFormat:@"%@/%@/%d", httpBaseUrl, @"requests", requestId];
    
    // Create and instance and attempt connection.
    RequestEntity *entity = [[RequestEntity alloc] init];
    entity.delegate = delegate;
    [EntityBase connectToUrl:httpBaseUrl withDelegate:entity];
}

+ (void)getRequestsWithPropertyId:(NSInteger)propertyId andDelegate:(id<PbConnectionDelegate>)delegate
{
    // Construct the URL.
    NSString *httpBaseUrl = [[ConfigurationData mainConfiguration] httpBaseUrl];    
    httpBaseUrl = [NSString stringWithFormat:@"%@/%@/%d", httpBaseUrl, @"requests/for_property", propertyId];
    
    // Create and instance and attempt connection.
    RequestEntity *entity = [[RequestEntity alloc] init];
    entity.delegate = delegate;
    [EntityBase connectToUrl:httpBaseUrl withDelegate:entity];
}

- (id)init
{
    self.requiredForms = [[NSString alloc] init];
    return [super init];
}

- (EntityBase*)initializeWithDictionary:(NSDictionary *)dict
{
    // Initialize the request object with all of it's data.
    self.requestId = [dict objectForKey:@"request_id"];
    self.otherNotes = [dict objectForKey:@"other_notes"];
    self.requiredForms = [dict objectForKey:@"required_forms"];
    self.propertyId = [dict objectForKey:@"property_id"];
    self.userId = [dict objectForKey:@"user_id"];
    self.createdAt = [dict objectForKey:@"created_at"];
    
    // Check for a "property" key and if found, alloc/init that entity.
    if (!([dict objectForKey:@"property"] == nil)) 
    {
        property = (PropertyEntity*)[[PropertyEntity alloc] initializeWithDictionary:[dict objectForKey:@"property"]];
    }
    
    // Check for an "items" key and if found, alloc/init that collection.
    if (!([dict objectForKey:@"items"] == nil))
    {
        items = (ItemEntityCollection*)[[ItemEntityCollection alloc] initializeWithArray:[dict objectForKey:@"items"]];
    }
    
    if (self.requiredForms == (id)[NSNull null]) {
        self.requiredForms = [[NSString alloc] init];
    }
    
    if (self.otherNotes == (id)[NSNull null]) {
        self.otherNotes = [[NSString alloc] init];
    }
    
    return self;
}

- (PropertyEntity*)propertyEntity
{
    // TODO: Check for instance of propertyEntity and if nil, retrieve.
    return property;
}

- (void)setPropertyEntity:(PropertyEntity*)value
{
    property = value;
}

- (ItemEntityCollection*)itemEntities
{
    return items;
}

- (void)setItemEntities:(ItemEntityCollection*)value
{
    items = value;
}

- (NSMutableArray*)requiredFormsArray
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    // Remove the last pipe from the character sequence.
    NSCharacterSet *cs = [NSCharacterSet characterSetWithCharactersInString:@"|"];
    self.requiredForms = [self.requiredForms stringByTrimmingCharactersInSet:cs];
    
    // Convert the string to an array.
    if (![self.requiredForms isEqualToString:@""]) {
        array = [NSMutableArray arrayWithArray:[self.requiredForms componentsSeparatedByString:@"|"]];
    }
    
    return array;
}

- (void)entityDidUpdate
{
    // The entity's values need to be updated!
}

#pragma mark -
#pragma mark YAJLParserDelegate Methods
- (id)JSON
{   
    NSLog(@"Property Entity JSON returns '%@'", [self.propertyEntity JSON]);
    NSLog(@"Item Entities JSON returns '%@'", [self.itemEntities JSON]);
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.otherNotes, @"other_notes", self.requiredForms, @"required_forms", self.propertyEntity.propertyId, @"property_id", self.userId, @"user_id" , nil];
    
    // Add any items if they exist.
    if (self.itemEntities != nil && [self.itemEntities count] > 0) {
        [dict setValue:[self.itemEntities JSON] forKey:@"items"];
    }
    
    // Add the property if it exists.
    if (self.propertyEntity != nil) {
        [dict setValue:[self.propertyEntity JSON] forKey:@"property"];
    }
    
    // Wrap and return.
    return [NSDictionary dictionaryWithObject:dict forKey:@"request"];
}

@end
