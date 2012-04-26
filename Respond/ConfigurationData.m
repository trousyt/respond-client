//
//  ConfigurationData.m
//  Respond
//
//  Created by Troy Parkinson on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ConfigurationData.h"

@implementation ConfigurationData

- (ConfigurationData*)init 
{
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"];
    config = [[NSDictionary alloc] initWithContentsOfFile:bundlePath];
    
    return [super init];
}

- (NSString*)httpBaseUrl
{
    return [config objectForKey:@"HTTPBaseURL"];
}

- (NSNumber*)defaultTimeoutInSeconds
{
    return [config objectForKey:@"DefaultTimeoutInSeconds"];
}

#pragma mark -
#pragma mark Singleton Object
+ (ConfigurationData*)mainConfiguration
{
    static ConfigurationData *mainConfiguration;
    
    if (mainConfiguration == nil) {
        mainConfiguration = [[ConfigurationData alloc] init];
    }
    
    return mainConfiguration;
}

@end
