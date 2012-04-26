//
//  RequiredFormEntity.h
//  Respond
//
//  Created by Troy Parkinson on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EntityBase.h"
#import "RequiredFormCollection.h"

@interface RequiredFormEntity : EntityBase

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *ownedBy;
@property (strong, nonatomic) NSString *details;

+ (void)getAllRequiredFormsWithDelegate:(id<PbConnectionDelegate>)delegate;



@end
