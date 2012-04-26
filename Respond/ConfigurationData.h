//
//  ConfigurationData.h
//  Respond
//
//  Created by Troy Parkinson on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConfigurationData : NSObject
{
    NSDictionary* config;
}

+ (ConfigurationData*)mainConfiguration;
- (NSString*)httpBaseUrl;
- (NSNumber*)defaultTimeoutInSeconds;

@end
