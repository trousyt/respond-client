//
//  PbConnectionDelegate.h
//  Respond
//
//  Created by Troy Parkinson on 3/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PbConnectionDelegate

@optional
- (void)entity:(id)sender didReceiveData:(NSUInteger)bytes;
- (void)entityGetDidComplete:(id)sender;
- (void)entityGetDidFail:(id)sender withError:(NSError *)error;

@end