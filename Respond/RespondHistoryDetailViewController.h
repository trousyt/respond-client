//
//  RespondDetailViewController.h
//  Respond
//
//  Created by Troy Parkinson on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MKMapView.h>
#import "RequestEntity.h"

@interface RespondHistoryDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    PBUIViewContext viewContext;
    
    UIScrollView *scrollView;
    UILabel *addressText;
    UITextView *notesTextView;
    UILabel *titleLabel;
}

@property (strong, nonatomic) RequestEntity *detailItem;
@property (nonatomic) PBUIViewContext viewContext;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UILabel *addressText;
@property (strong, nonatomic) IBOutlet UITextView *notesTextView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

- (IBAction)mapMarkerButtonPressed:(id)sender;

@end
