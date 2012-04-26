//
//  ItemEntity.m
//  Respond
//
//  Created by Troy Parkinson on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ItemEntity.h"
#import "Base64.h"

@implementation ItemEntity
@synthesize itemId;
@synthesize description;
@synthesize image1x;
@synthesize image2x;
@synthesize requestId;

+ (void)getItemWithRequestId:(NSInteger)requestId andDelegate:(id<PbConnectionDelegate>)delegate;
{   
    // Construct the URL.
    NSString *httpBaseUrl = [[ConfigurationData mainConfiguration] httpBaseUrl];    
    httpBaseUrl = [NSString stringWithFormat:@"%@/%@/%d", httpBaseUrl, @"items/for_request", requestId];
    
    // Create an instance and attempt connection.
    ItemEntity *entity = [[ItemEntity alloc] init];
    entity.delegate = delegate;
    [EntityBase connectToUrl:httpBaseUrl withDelegate:entity];
}

- (EntityBase*)initializeWithDictionary:(NSDictionary *)dict
{
    self.itemId = [dict objectForKey:@"item_id"];
    self.description = [dict objectForKey:@"description"];
    self.requestId = [dict objectForKey:@"request_id"];
    self.createdAt = [dict objectForKey:@"created_at"];
    
    image1xUrl = [dict objectForKey:@"image1x_url"];
    image2xUrl = [dict objectForKey:@"image2x_url"];
    
        
    return self;
}

#pragma mark -
#pragma mark Getter Overrides
- (UIImage*)image1x
{
    UIImage *image;
    
    // If image1xUrl, then fetch the image (synchronously) and return.
    if (image1xUrl != nil && image1xUrl != (NSString*)[NSNull null]) {
        NSData *data = [[NSData alloc] initWithContentsOfURL:[[NSURL alloc] initWithString:image1xUrl]];
        image = [[UIImage alloc] initWithData:data];
    }
    else {
        image = rawImage;
    }
    
    // Return the image.
    return image;
}

- (void)setImage1x:(UIImage *)image
{
    rawImage = image;
}

- (UIImage*)image2x
{
    UIImage *image;
    
    if (image2xUrl != nil && image2xUrl != (NSString*)[NSNull null]) {
        NSData *data = [[NSData alloc] initWithContentsOfURL:[[NSURL alloc] initWithString:image2xUrl]];
        image = [[UIImage alloc] initWithData:data];
    }
    else {
        image = rawImage;
    }
    
    // Return the image.
    return image;
}

- (void)setImage2x:(UIImage *)image
{
    rawImage = image;
}

#pragma mark -
#pragma mark YAJLParserDelegate Methods
- (id)JSON
{    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.description, @"description", nil];
    
    if (rawImage != nil) {
        [dict setValue: [Base64 encode:UIImageJPEGRepresentation(rawImage, 1.0)] forKey:@"image_base64"];
        //NSLog(@"Base64 Image Representation: %@", [dict objectForKey:@"image_base64"]);
    }
    
    return [NSDictionary dictionaryWithObject:dict forKey:@"item"];
}

@end
