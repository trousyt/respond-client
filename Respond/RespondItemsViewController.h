//
//  RespondHistoryItemsViewController.h
//  Respond
//
//  Created by Troy Parkinson on 2/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#include "ItemEntityCollection.h"
#include "ItemEntity.h"
#include "PbReceivesEntity.h"

@interface RespondItemsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>
{
    id<PbReceivesEntity> parentView;
    PBUIViewContext viewContext;
    UIView *addItemView;
    UIImage *chosenImage;
    UITableView *tableView;
    UITextField *addTextField;
}

@property (strong, nonatomic) id<PbReceivesEntity> parentView;
@property (strong, nonatomic) ItemEntityCollection* detailItems;
@property (nonatomic) PBUIViewContext viewContext;
@property (strong, nonatomic) IBOutlet UIView* addItemView;
@property (strong, nonatomic) IBOutlet UITableView* tableView;
@property (strong, nonatomic) IBOutlet UITextField* addTextField;
@property (strong, nonatomic) UIImage *chosenImage;

- (IBAction)imageTouched:(id)sender;

@end
