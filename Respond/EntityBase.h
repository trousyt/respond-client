//
//  EntityBase.h
//  Respond
//
//  Created by Troy Parkinson on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YAJLiOS/YAJL.h>

@interface EntityBase : NSObject <NSURLConnectionDataDelegate, YAJLCoding>
{
    NSURLConnection *getConnection;
    NSURLConnection *postConnection;
    NSMutableData *entityData;
    NSDate *createdAt;
    NSDate *updatedAt;
}

@property (assign, nonatomic) id<PbConnectionDelegate> delegate;
@property (strong, nonatomic) NSDate *createdAt;
@property (strong, nonatomic) NSDate *updatedAt;

+ (void)connectToUrl:(NSString*)url withDelegate:(id)delegate;
+ (NSData*)connectToUrl:(NSString*)url;
- (EntityBase*)initializeWithDictionary:(NSDictionary*)dict;
- (void)entityDidUpdate;

// TODO:
- (BOOL)save;
- (id)JSON;

@end
