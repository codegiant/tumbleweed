//
//  CheckInController.h
//  tumbleweed
//
//  Created by Ian Parker on 2/3/12.
//  Copyright (c) 2012 AI Capital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Foursquare.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"
#import "NSDictionary_JSONExtensions.h"
#import "SceneController.h"


@interface CheckInController : UIViewController <ASIHTTPRequestDelegate, UITextViewDelegate>{
    IBOutlet UIButton *backButton;
    IBOutlet UIButton *photoButton;
    IBOutlet UILabel *characterCounter;
    IBOutlet UITextView *shoutTextView;
    IBOutlet UISwitch *publicCheckinSwitch;
    NSDictionary *venueDetails;
    IBOutlet UILabel *venueNameLabel;
    NSString *shoutText;
    SceneController *sceneControllerId;
    IBOutlet UIActivityIndicatorView *activityIndicator;
}

@property (nonatomic, retain) NSDictionary *venueDetails;
@property (nonatomic, retain) UILabel *venueNameLabel;
@property (nonatomic, retain) NSString *shoutText;
@property (nonatomic, retain) UILabel *characterCounter;
@property (nonatomic, retain) UITextView *shoutTextView;
@property (nonatomic, strong) SceneController *sceneControllerId;
@property (nonatomic, strong) UISwitch *publicCheckinSwitch;

- (IBAction)checkIn:(id)sender;
- (IBAction)dismissModal:(id)sender;
- (id) initWithSenderId: (SceneController *)sender;




@end
