//
//  RespondHistoryDetailNewViewController.h
//  Respond
//
//  Created by Troy Parkinson on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PbCLClassController.h"
#import "PbReceivesEntity.h"
#import "PbReceivesDelimitedString.h"
#import "RequestEntity.h"

@interface RespondNewViewController : UIViewController <PbCLControllerDelegate, PbReceivesEntity, PbReceivesDelimitedString, UITextFieldDelegate, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource>
{
    //NSArray *
    RequestEntity *request;
    int lastItemsCount;
    
    CGFloat animatedDistance;

    PbCLClassController *locationController;
    UIView *LocationActivityView;
    UIView *locationView;
    UIActivityIndicatorView *locationActivityIndicator;
    UILabel *locationLabel;
    UITableView *itemsTableView;
    
    UITextField *addressStreet;
    UITextField *addressCity;
    UITextField *addressState;
    UITextField *addressZip;
    CLLocationDegrees addressLatitude;
    CLLocationDegrees addressLongitude;
    UITextView *notes;
}

@property (strong, nonatomic) NSMutableArray *itemsArray;
@property (strong, nonatomic) PbCLClassController *locationController;
@property (strong, nonatomic) IBOutlet UIView *locationActivityView;
@property (strong, nonatomic) IBOutlet UIView *locationView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *locationActivityIndicator;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UITableView *itemsTableView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UITextField *addressStreet;
@property (strong, nonatomic) IBOutlet UITextField *addressCity;
@property (strong, nonatomic) IBOutlet UITextField *addressState;
@property (strong, nonatomic) IBOutlet UITextField *addressZip;
@property (strong, nonatomic) IBOutlet UITextView *notes;


- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;

- (void)locationUpdate:(CLLocation *)location;
- (void)locationError:(NSError *)error;
- (void)updateAddressInformation:(CLPlacemark*)placemark;
- (IBAction)textFieldDoneEditing:(id)sender;
- (IBAction)backgroundTapped:(id)sender;

@end
