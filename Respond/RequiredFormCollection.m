//
//  RequiredFormCollection.m
//  Respond
//
//  Created by Troy Parkinson on 3/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RequiredFormCollection.h"
#import "RequiredFormEntity.h"

@implementation RequiredFormCollection


- (RequiredFormCollection*)initializeWithArray:(NSArray *)array
{
    // Allocate space for the array.
    entities = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dict in array)
    {
        // Create the entity and add it to the collection.
        RequiredFormEntity *entity = (RequiredFormEntity*)[[RequiredFormEntity alloc] initializeWithDictionary:[dict objectForKey:@"required_form"]];
        
        [entities addObject:entity];
    }
    
    return self;
}

#pragma mark -
#pragma mark YAJLParserDelegate Methods
- (id)JSON
{
    NSArray *array = [NSArray arrayWithObject:[entities objectAtIndex:0]];
    
    return array;
}

@end
