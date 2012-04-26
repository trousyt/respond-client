//
//  ItemEntity.h
//  Respond
//
//  Created by Troy Parkinson on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EntityBase.h"

@interface ItemEntity : EntityBase
{
    NSString *image1xUrl;
    NSString *image2xUrl;
    UIImage *rawImage;
}

@property (strong, nonatomic) NSNumber *itemId;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) UIImage *image1x;
@property (strong, nonatomic) UIImage *image2x;
@property (strong, nonatomic) NSNumber *requestId;

+ (void)getItemWithRequestId:(NSInteger)requestId andDelegate:(id<PbConnectionDelegate>)delegate;



@end
