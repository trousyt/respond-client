//
//  EntityBase.m
//  Respond
//
//  Created by Troy Parkinson on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EntityBase.h"

@implementation EntityBase
@synthesize delegate;
@synthesize createdAt;
@synthesize updatedAt;

static NSURLConnection *getConnection;
static NSURLConnection *postConnection;

#pragma mark -
#pragma mark Class Methods
+ (void)connectToUrl:(NSString*)url withDelegate:(id)delegate
{  
    double timeout = [[[ConfigurationData mainConfiguration] defaultTimeoutInSeconds] doubleValue];
    
    // Create the request.
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeout];
    
    // Set the default state on load.
    getConnection = [[NSURLConnection alloc] initWithRequest:request delegate:delegate startImmediately:YES];
}

+ (NSData*)connectToUrl:(NSString*)url
{
    double timeout = [[[ConfigurationData mainConfiguration] defaultTimeoutInSeconds] doubleValue];
    
    // Create the request.
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeout];
    NSURLResponse *response;
    NSError *error;
    
    NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    return result;
}

#pragma mark -
#pragma mark Implementation "Virtual Methods"
- (EntityBase*)initializeWithDictionary:(NSDictionary*)dict
{
    // Leave the implementation to the subclass
    NSLog(@"Calling initializeWithDictionary on EntityBase");
    return self;
}

- (BOOL)save
{
    // Get the entity's JSON string.
    NSString *json = [self yajl_JSONString];
    NSLog(@"New json: %@", json);
    
    // Get default values for the connection.
    NSString *httpBaseUrl = [[ConfigurationData mainConfiguration] httpBaseUrl];    
    httpBaseUrl = [NSString stringWithFormat:@"%@/%@", httpBaseUrl, @"requests"];
    double timeout = [[[ConfigurationData mainConfiguration] defaultTimeoutInSeconds] doubleValue];
    
    // Construct a HTTP request for the POST.
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:httpBaseUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeout];
    NSData *requestBody = [json dataUsingEncoding:NSUTF8StringEncoding];    
    
    [request setHTTPMethod:@"POST"];
    [request addValue:[NSString stringWithFormat:@"%d", [requestBody length]] forHTTPHeaderField:@"Content-Length"];
    [request addValue:@"text/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:requestBody];
    
    
    //NSLog(@"Sending this request to the server: %@", [request 
    
    // Start the connection asynchronously.
    postConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
    return YES;
}

- (void)entityDidUpdate
{
    NSLog(@"Calling -entityDidUpdate on EntityBase");
}

#pragma mark -
#pragma mark NSURLConnectionDataDelegate Delegate Methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // Don't initialize the data object until we've received a response.
    entityData = [[NSMutableData alloc] init];
}

/* TODO
   - Support the scenario of getting/posting at the same time (if both happening at the same time, entityData with combine two data streams);
 */

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [entityData appendData:data];
    
    // Change response based on connection used.
    if (connection == getConnection) {
        [self.delegate entity:self didReceiveData:[data length]];
    } 
    else if (connection == postConnection) {
        // do nothing
        NSLog(@"The POST connection has received data");
    }
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Change response based on connection used.
    if (connection == getConnection) {
        [self initializeWithDictionary:[entityData yajl_JSON]];
        [self.delegate entityGetDidComplete:self];
    } else if (connection == postConnection) {
        // Assign the given id of the entity.
        // Check the HTTP return code for errors
        NSLog(@"The POST connection did finish loading");
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"The connection did fail with error: %@", [error description]);
    [self.delegate entityGetDidFail:self withError:error];
}

#pragma mark -
#pragma mark YAJLParserDelegate Methods
- (id)JSON
{
    // Leave the implementation to the subclass
    NSLog(@"Calling -JSON on EntityBase");
    return [[NSDictionary alloc] init];
}


@end
