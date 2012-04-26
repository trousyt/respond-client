//
//  EntityCollectionBase.m
//  Respond
//
//  Created by Troy Parkinson on 3/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EntityCollection.h"
#import <YAJLiOS/YAJL.h>

@implementation EntityCollection
@synthesize delegate;

#pragma mark -
#pragma mark Implementation "Virtual Methods"
- (id)init
{
    entities = [[NSMutableArray alloc] init];
    return self;
}

- (EntityCollection*)initializeWithArray:(NSArray *)array
{    
    // Leave the implementation to the subclass
    NSLog(@"Calling initializeWithArray on EntityBase");
    return (EntityCollection*)[self init];
}

- (void)addObject:(id)object
{
    [entities addObject:object];
}

- (id)objectAtIndex:(NSUInteger)index
{
    return [entities objectAtIndex:index];
}

- (NSUInteger)count
{
    return [entities count];
}

#pragma mark -
#pragma mark NSURLConnectionDataDelegate Default Implementation Methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // Don't initialize the data objects until we've received a response.
    entityData = [[NSMutableData alloc] init];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self initializeWithArray:[entityData yajl_JSON]];
    if (self.delegate) {
        [self.delegate entityGetDidComplete:self];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [entityData appendData:data];
    if (self.delegate) {
        [self.delegate entity:self didReceiveData:[data length]];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (self.delegate) { 
        [self.delegate entityGetDidFail:self withError:error];
    }
}

#pragma mark -
#pragma mark YAJLParserDelegate Methods
- (id)JSON
{
    // Leave the implementation to the subclass
    NSLog(@"Called -JSON on EntityCollection");
    return [[NSArray alloc] init];
}

@end
