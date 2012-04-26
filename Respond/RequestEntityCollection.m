 //
//  RequestEntityCollection.m
//  Respond
//
//  Created by Troy Parkinson on 3/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RequestEntityCollection.h"

@implementation RequestEntityCollection


- (RequestEntityCollection*)initializeWithArray:(NSArray *)array
{
    // Allocate space for the array.
    entities = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dict in array)
    {
        // Create the entity and add it to the collection.
        RequestEntity *entity = (RequestEntity*)[[RequestEntity alloc] initializeWithDictionary:[dict objectForKey:@"request"]];
        
        [entities addObject:entity];
    }
    
    return self;
}

@end
