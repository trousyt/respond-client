//
//  RespondNewPickRequiredForms.h
//  Respond
//
//  Created by Troy Parkinson on 3/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PbReceivesDelimitedString.h"
#import "RequiredFormCollection.h"
#import "RequiredFormEntity.h"

@interface RespondNewPickRequiredFormsViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, PbConnectionDelegate>
{
    // Not necessary to define a backing variable any longer since update XX
    //id<PbReceivesDelimitedString> parentView;
    
    UITableView *tableView;
    RequiredFormCollection *requiredForms;
    NSMutableArray *selectedForms;
    NSString *delimitedString;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) id<PbReceivesDelimitedString> parentView;
@property (strong, nonatomic) NSMutableArray *selectedForms;
@property (strong, nonatomic) NSString *delimitedString;

@end
