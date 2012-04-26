//
//  RequiredFormEntity.m
//  Respond
//
//  Created by Troy Parkinson on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RequiredFormEntity.h"

@implementation RequiredFormEntity
@synthesize name;
@synthesize ownedBy;
@synthesize details;

+ (void)getAllRequiredFormsWithDelegate:(id<PbConnectionDelegate>)delegate
{   
    // Construct the URL.
    NSString *httpBaseUrl = [[ConfigurationData mainConfiguration] httpBaseUrl];    
    httpBaseUrl = [NSString stringWithFormat:@"%@/%@", httpBaseUrl, @"required_forms"];
    
    // Create an instance and attempt connection.
    RequiredFormCollection *entityCollection = [[RequiredFormCollection alloc] init];
    entityCollection.delegate = delegate;
    [EntityBase connectToUrl:httpBaseUrl withDelegate:entityCollection];
}

- (EntityBase*)initializeWithDictionary:(NSDictionary *)dict
{
    self.name = [dict objectForKey:@"name"];
    self.ownedBy = [dict objectForKey:@"owned_by"];
    self.details = [dict objectForKey:@"details"];
    
    return self;
}

#pragma mark -
#pragma mark YAJLParserDelegate Methods
- (id)JSON
{    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:self.name, @"name", self.ownedBy, @"owned_by", self.details, @"details", nil];
    
    return [NSDictionary dictionaryWithObject:dict forKey:@"required_form"];
}

@end
