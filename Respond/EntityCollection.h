//
//  EntityCollectionBase.h
//  Respond
//
//  Created by Troy Parkinson on 3/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YAJLiOS/YAJL.h>

@interface EntityCollection : NSObject <NSURLConnectionDataDelegate, YAJLCoding>
{
    NSMutableArray *entities;
    NSMutableData *entityData;
}

@property (assign, nonatomic) id<PbConnectionDelegate> delegate;

- (EntityCollection*)initializeWithArray:(NSArray *)array;

- (void)addObject:(id)object;
- (id)objectAtIndex:(NSUInteger)index;
- (NSUInteger)count;

// TODO:
// Save all method
- (id)JSON;

@end
