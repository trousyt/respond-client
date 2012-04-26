//
//  RespondMasterViewController.h
//  Respond
//
//  Created by Troy Parkinson on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RespondHistoryDetailViewController.h"
#import "RequestEntityCollection.h"

typedef enum {
    kActivityImage,
    kWarningImage
} RespondHistoryDetailViewTableImage;

@class RespondHistoryDetailViewController;

@interface RespondHistoryViewController : UIViewController <NSURLConnectionDataDelegate, UITableViewDataSource, UITableViewDelegate, PbConnectionDelegate>
{
    RequestEntityCollection *requestCollection;
    RespondHistoryDetailViewController *detailViewController;
    UIActivityIndicatorView *activityIndicator;
    
    UITableView *theTableView;
    UIScrollView *theScrollView;
    UIView *warningView;
    UIImageView *warningImage;
}

@property (strong, nonatomic) RespondHistoryDetailViewController *detailViewController;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UITableView *theTableView;
@property (strong, nonatomic) IBOutlet UIScrollView *theScrollView;
@property (strong, nonatomic) IBOutlet UIView *warningView;
@property (strong, nonatomic) IBOutlet UIImageView *warningImage;

- (void)startLoadingHistory;
- (IBAction)refreshButtonPressed:(id)sender;

@end
