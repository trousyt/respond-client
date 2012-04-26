//
//  PbReceivesDelimitedString.h
//  Respond
//
//  Created by Troy Parkinson on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EntityBase.h"
#import "EntityCollection.h"

#pragma mark -
#pragma mark PBClControllerDelegate Protocol
@protocol PbReceivesDelimitedString

@optional
- (void)receiveString:(NSString*)string;

@end