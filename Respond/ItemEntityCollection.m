//
//  ItemEntityCollection.m
//  Respond
//
//  Created by Troy Parkinson on 3/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ItemEntityCollection.h"

@implementation ItemEntityCollection


- (ItemEntityCollection*)initializeWithArray:(NSArray *)array
{
    // Allocate space for the array.
    entities = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dict in array)
    {
        // Create the entity and add it to the collection.
        ItemEntity *entity = (ItemEntity*)[[ItemEntity alloc] initializeWithDictionary:[dict objectForKey:@"item"]];
        [entities addObject:entity];
    }
    
    return self;
}

#pragma mark -
#pragma mark YAJLParserDelegate Methods
- (id)JSON
{
    //NSArray *array = entities;
    return entities;
}

@end
