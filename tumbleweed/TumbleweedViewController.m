//
//  ViewController.m
//  tumbleweed
//
//  Created by David Cascino on 1/22/12.
//  Copyright (c) 2012 AI Capital. All rights reserved.
//

#import "TumbleweedViewController.h"
#import "SceneController.h"
#import "FoursquareAuthViewController.h"



@implementation TumbleweedViewController

@synthesize scrollView, map0CA, map1CA, map2CA, mapCAView, sky, map1, map2, map4, avatar, sprites, walkingForward, weed, locationManager;

//-- scene buttons
@synthesize foursquareConnectButton, gasStationButton, dealButton, barButton, riverBed1Button, riverBed2Button, desertChaseButton, desertLynchButton, campFireButton;


- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        weed = [Tumbleweed weed];
        map0CA = [[CALayer alloc] init];
        map1CA = [[CALayer alloc] init];
        map2CA = [[CALayer alloc] init];
   

    }
    return self;
}

- (void) initSprites
{
    if(sprites == nil){
        sprites = [[NSMutableArray alloc] initWithObjects:
                   //[UIImage imageNamed:@"JANE_walkcycle0.png"],
                   [UIImage imageNamed:@"JANE_walkcycle1.png"],
                   [UIImage imageNamed:@"JANE_walkcycle2.png"],
                   [UIImage imageNamed:@"JANE_walkcycle3.png"],
                   [UIImage imageNamed:@"JANE_walkcycle4.png"],
                   [UIImage imageNamed:@"JANE_walkcycle5.png"],
                   [UIImage imageNamed:@"JANE_walkcycle6.png"],
                   nil];
    }
    
}

-(UIImage *) selectAvatarImage:(float) position
{
    int frameSize = 20;
    int imageCount = 6;
    int currentPosition = (int) position;
    int imageIndex = (currentPosition + (frameSize * imageCount)) % (frameSize * imageCount) / frameSize;
    return [sprites objectAtIndex:imageIndex];
}

- (void) saveAvatarPosition
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setFloat:scrollView.contentOffset.x forKey:@"scroll_view_position"];
    [defaults setBool:walkingForward forKey:@"walkingForward"];
    NSLog(@"saving Jane's position");
}

#pragma mark scrollView handlers

- (void)scrollViewDidScroll:(UIScrollView *)sView
{
    if (lastContentOffset > scrollView.contentOffset.x)
    {
        walkingForward = NO;
    }
    else if (lastContentOffset < scrollView.contentOffset.x) 
    {
        walkingForward = YES;    
    }
    lastContentOffset = scrollView.contentOffset.x;
    [self renderScreen:walkingForward];
}

- (void) renderScreen: (BOOL) direction
{
    double avatar_offset = 200;

    UIImage *img = [self selectAvatarImage:[scrollView contentOffset].x];
    //CGRect imageFrame = CGRectMake(0, 0, 150, 200);
    /*
    if(!avatar){
        avatar = [[UIImageView alloc] initWithFrame:imageFrame];
        [scrollView addSubview:avatar];
    }
    */
    CGPoint center = CGPointMake([scrollView contentOffset].x + avatar_offset, avatar_offset);
    [avatar setCenter:center];
    
    if (direction) {
        [avatar setImage:img];

    } else {
        UIImage *flippedImage = [UIImage imageWithCGImage:img.CGImage scale:1.0 orientation: UIImageOrientationUpMirrored];
        [avatar setImage:flippedImage];
    }
    
    /*
    //-sky position
    CGPoint mapCenter = [map1 center];
    float skyCoefficient = .99;
    float janeOffset = mapCenter.x - [scrollView contentOffset].x;
    CGPoint skyCenter = CGPointMake(mapCenter.x - (janeOffset * skyCoefficient), [sky center].y);
    //CGPoint map4Center = CGPointMake([map4 center].x -(janeOffset *.01), [map4 center].y);
    //NSLog(@"janeoffset center %f, sky center %f", janeOffset, skyCenter.x);
    [sky setCenter:skyCenter];
    //[map4 setCenter:map4Center];
    
    */
    CGPoint mapCenter = CGPointMake([map1CA bounds].size.width/2.0, [map1CA bounds].size.height/2.0);
    float skyCoefficient = .99;
    float janeOffset = mapCenter.x - [scrollView contentOffset].x;
    CGPoint skyCenter = CGPointMake(mapCenter.x - (janeOffset * skyCoefficient), [map0CA bounds].size.height/2.0);
    [map0CA setPosition:skyCenter];
    //NSLog(@"map1 center %f, map1 center %f map bounds center %f", mapCenter.x, [map1 center].x, [map1CA bounds].size.width/2.0);

    NSLog(@"janeoffset center %f, sky center %f skyPosition %f", janeOffset, skyCenter.x, map0CA.position.x);
    
    
}

#pragma mark button handlers


- (IBAction) foursquareConnect:(UIButton *)sender
{
    NSLog(@"pressed");
    FoursquareAuthViewController *fsq = [[FoursquareAuthViewController alloc] init];
    [self presentViewController:fsq animated:YES completion:NULL];  

}


- (IBAction)gasStationPressed:(UIButton *)sender
{    
    NSLog(@"gasstation checkin response %@", weed.gasStation.checkInResponse);
    NSLog(@"is the scene unlocked? %@", weed.gasStation.unlocked ? @"YES": @"NO");
    SceneController *gasStationScene = [[SceneController alloc] initWithScene:weed.gasStation];
    [self presentModalViewController:gasStationScene animated:YES];
}

- (IBAction)dealPressed:(UIButton *)sender
{
    //NSLog(@"pressed");
    SceneController *dealScene = [[SceneController alloc] initWithScene:weed.deal];
    [self presentModalViewController:dealScene animated:YES];
}

- (IBAction) barPressed:(UIButton *)sender
{
    //NSLog(@"pressed");
    SceneController *barScene = [[SceneController alloc] initWithScene:weed.bar];
    [self presentModalViewController:barScene animated:YES];
    NSLog(@"start at %@, scheduled notif2 %@", weed.riverBed1.date, [[UIApplication sharedApplication] scheduledLocalNotifications]);

}

- (IBAction)riverbed1Pressed:(UIButton *)sender
{
    if (weed.riverBed1.accessible)
    {
        SceneController *riverbedScene = [[SceneController alloc] initWithScene:weed.riverBed1];
        [self presentModalViewController:riverbedScene animated:YES];
    }
    else
    {
        //pop up hint
    }
}

- (IBAction) riverbed2Pressed:(UIButton *)sender
{
    if (weed.riverBed2.accessible)
    {
        SceneController *riverbedScene = [[SceneController alloc] initWithScene:weed.riverBed2];
        [self presentModalViewController:riverbedScene animated:YES];
    }
    else
    {
        //pop up hint
    }
}
- (IBAction) desertChasePressed:(UIButton *)sender
{
    if (weed.desertChase.accessible)
    {
        SceneController *riverbedScene = [[SceneController alloc] initWithScene:weed.desertChase];
        [self presentModalViewController:riverbedScene animated:YES];
    }
    else
    {
        //pop up hint
    }
}
- (IBAction) desertLynchPressed:(UIButton *)sender
{
    if (weed.desertLynch.accessible)
    {
        SceneController *riverbedScene = [[SceneController alloc] initWithScene:weed.desertLynch];
        [self presentModalViewController:riverbedScene animated:YES];
    }
    else
    {
        //pop up hint
    }
}
- (IBAction) campFirePressed:(UIButton *)sender
{
    if (weed.campFire.accessible)
    {
        SceneController *riverbedScene = [[SceneController alloc] initWithScene:weed.campFire];
        [self presentModalViewController:riverbedScene animated:YES];
    }
    else
    {
        //pop up hint
    }
}

- (void) gameState
{
    /*
     visible <=> accessible
     what about tips and push notifications? the relationship between them.
     "force tip" for the campfire scene
     button states
     server notifications
     enum game state?
     //allOtherScenes.visible = false;
     //allOtherScenes.hint = @"You should probably check somewhere else...1, 2, or 3";
     
     */
     
     
    //start state - 
    gasStationButton.enabled = weed.gasStation.accessible; 
    //dealButton.enabled = true; 
    //barButton.enabled = true;
    //riverBed1Button.enabled = false; 

     
    //state 2 -
    if ( weed.gasStation.unlocked && weed.deal.unlocked && weed.bar.unlocked ) { 
        weed.riverBed1.accessible = true; 
    }
     
    //state 3 - 
    if (weed.riverBed1.unlocked) {
        weed.riverBed2.accessible = true;
        // turn on region monitoring - ([weed.riverBed1.date timeIntervalSinceNow] < -3600))
        if (!weed.riverBed2.unlocked && ![[UIApplication sharedApplication] scheduledLocalNotifications])
        {
            [self scheduleNotificationWithDate:weed.riverBed1.date intervalTime:10];
        }
        if ([[NSUserDefaults standardUserDefaults] stringForKey:@"notification"] && ([weed.riverBed1.date timeIntervalSinceNow] < -10))
        {
            weed.riverBed2.unlocked = true;
        }
    }
    if (weed.riverBed2.unlocked)  {
        weed.desertChase.accessible = true;
        //turn on region monitoring - ( [newLocation distanceFromLocation:riverbed2.location] > 2000) - then set weed.desertChase.unlocked = true;
        if  (weed.desertChase.unlocked){ 
            weed.desertLynch.accessible = true;
        }
        else { //state 4 - 
            [self startSignificantChangeUpdates];
            //when finishes must unlock desertChase then launch a notification
        }
    }

    //state 5 -
    if (weed.desertLynch.unlocked){
        weed.campFire.accessible = true;
        weed.campFire.unlocked = true;
    }
    /* 
    //state 6 -
    if ( weed.campFire.watched ) {
        //end--reset game option, dviz printout or end credits?
    }
    */ 
     
     
     
}

- (void)scheduleNotificationWithDate:(NSDate *)date intervalTime:(int) timeinterval{
   
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil)
        return;
    if (!date) {
        //date = [NSDate date];
    }
    localNotif.fireDate = [date dateByAddingTimeInterval:timeinterval];
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    
    //localNotif.alertBody = [NSString stringWithFormat:NSLocalizedString(@"%@ in %i minutes.", nil), item.eventName, minutesBefore];
    //localNotif.alertAction = NSLocalizedString(@"View Details", nil);
    localNotif.alertBody = @"You just unlocked the next scene...";
    
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    //localNotif.applicationIconBadgeNumber = 1;
    
    //NSDictionary *infoDict = [NSDictionary dictionaryWithObject:item.eventName forKey:ToDoItemKey];
    //localNotif.userInfo = infoDict;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:timeinterval forKey:@"notification"];
    [defaults synchronize];
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
}

#pragma mark - CLLocationManagerDelegate

- (void)startSignificantChangeUpdates
{
    // Create the location manager if this object does not
    // already have one.
    if (nil == locationManager)
        locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLLocationAccuracyThreeKilometers;
    [locationManager startMonitoringSignificantLocationChanges];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	NSLog(@"didFailWithError: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    // If it's a relatively recent event, turn off updates to save power
    NSDate* eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 300.0)
    {
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              newLocation.coordinate.latitude,
              newLocation.coordinate.longitude);
        [locationManager stopMonitoringSignificantLocationChanges];
        weed.desertChase.unlocked = true;
        // notify the unlocking -- animate the unlocking when back to app
        [self scheduleNotificationWithDate:weed.riverBed2.date intervalTime:5];
        
    }
    
   
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initSprites];
    //walkingForward = YES;
    
    CGSize screenSize = CGSizeMake(5782, 320.0);
    scrollView.contentSize = screenSize;
    
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = NO;
    [scrollView setDelegate:self];
    
    CGRect mapFrame = CGRectMake(0, 0, screenSize.width, screenSize.height);
    CGRect skyFrame = CGRectMake(0, 0, 1507, screenSize.height);
    
    [map0CA setBounds:skyFrame];
    [map0CA setPosition:CGPointMake(screenSize.width/2, screenSize.height/2)];
    CGImageRef map0Image = [[UIImage imageNamed:@"gdw_parallax_cropped_layer=sky.jpg"] CGImage];
    [map0CA setContents:(__bridge id)map0Image];
    [map0CA setZPosition:-5];
    [mapCAView.layer addSublayer:map0CA];
    
    [map1CA setBounds:mapFrame];
    [map1CA setPosition:CGPointMake(screenSize.width/2, screenSize.height/2)];
    CGImageRef map1Image = [[UIImage imageNamed:@"map1.png"] CGImage];
    [map1CA setContents:(__bridge id)map1Image];
    [map1CA setZPosition:0];
    [mapCAView.layer addSublayer:map1CA];
    
    [map2CA setBounds:mapFrame];
    [map2CA setPosition:CGPointMake(screenSize.width/2, screenSize.height/2)];
    //[map2CA setContentsGravity:kCAGravityResizeAspect];
    CGImageRef map2Image = [[UIImage imageNamed:@"map2.png"] CGImage];
    [map2CA setContents:(__bridge id)map2Image];
    [map2CA setZPosition:5];
    [mapCAView.layer addSublayer:map2CA];
    [self renderScreen:[[NSUserDefaults standardUserDefaults] boolForKey:@"walkingForward"]];


/**
    UIImage *maplayer1 = [UIImage imageNamed:@"map.jpg"];
    CGRect mapFrame = CGRectMake(0, 0, 5782, 320);
    
    map = [[UIImageView alloc] initWithFrame:mapFrame];
    [map setImage:maplayer1];
                         
    [scrollView addSubview:map];
    
    */
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CGPoint center = CGPointMake([[NSUserDefaults standardUserDefaults] floatForKey:@"scroll_view_position"], 0);
    scrollView.contentOffset = center;
    //[self renderScreen:[[NSUserDefaults standardUserDefaults] boolForKey:@"walkingForward"]];
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"access_token"]){
        //NSLog(@"access token exists");
        foursquareConnectButton.enabled = NO;
    }
    [self gameState];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [self saveAvatarPosition];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft 
            || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

@end