    //
//  LoginViewController.m
//  Stegbook
//
//  Created by Loz Archer on 10/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ConnectViewController.h"
#import "FBConnect.h"
#import "StegbookAppDelegate.h"
#import "LoggedInUser.h"
#import "Reachability.h"

@implementation ConnectViewController

@synthesize infoLabel, fbButton, permissions, binarySwitch, decimalSwitch, algorithmOptionView;

/**
 * Set initial view
 */
- (void) viewDidLoad {
	
	[self.infoLabel setText:@""];
	permissions =  [[NSArray arrayWithObjects: 
					 @"read_stream", @"publish_stream", @"user_photos", @"friends_photos", @"friends_photo_video_tags", @"user_photo_video_tags" ,nil] retain];

	fbButton.isLoggedIn   = NO;
	[fbButton updateImage];
	algorithmOptionView.hidden = YES;
	[UIAppDelegate enableEncodeAndDecode:NO];
	
	// check for internet connection
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
	
	internetReachable = [[Reachability reachabilityForInternetConnection] retain];
	[internetReachable startNotifier];
	
}

- (void) checkNetworkStatus:(NSNotification *)notice
{
	// called after network status changes
	
	NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
	if (internetStatus == NotReachable)
	{
		 UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error"
														message: @"We're not connected to the internet"
													   delegate: self
											  cancelButtonTitle: @"OK"
											  otherButtonTitles: nil];
		[alert show];
		[alert release];
		[UIAppDelegate enableEncodeAndDecode:NO];
	} else {
		[UIAppDelegate enableEncodeAndDecode:YES];
	}
}
/**
 * Example of facebook login and permission request
 */
- (void) login {
	NSLog(@"requesting permissions %@", permissions);
	[UIAppDelegate.facebook authorize:kAppId permissions:permissions delegate:self];
}

/**
 * Example of facebook logout
 */
- (void) logout {
	[UIAppDelegate enableEncodeAndDecode:NO];
	[UIAppDelegate.facebook logout:self]; 
}

/**
 * Login/out button click
 */
- (IBAction) fbButtonClick: (id) sender {
	if (fbButton.isLoggedIn) {
		[self logout];
	} else {
		[self login];
	}
}

-(IBAction) switchChanged: (UISwitch*) sender {
	
	// Toggle the other switch
	if ([sender tag] == 0) {
		if ([decimalSwitch isOn] == [binarySwitch isOn]) {
			[decimalSwitch setOn:(! [decimalSwitch isOn])];
		}
	} else {
		if ([decimalSwitch isOn] == [binarySwitch isOn]) {
			[binarySwitch setOn:(! [binarySwitch isOn])];
		}
	}
	
	// Set the data hiding method globally
	UIAppDelegate.binaryHiding = [binarySwitch isOn];
	UIAppDelegate.decimalHiding = [decimalSwitch isOn];
}
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


/**
 * Callback for facebook login
 */ 
-(void) fbDidLogin {
	progressIndicator = [[ProgressIndicator alloc] init];
	[progressIndicator showAlert:@"Connecting to Facebook" message:@"Please wait..."];
	fbButton.isLoggedIn         = YES;
	NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								   kAppId, @"api_key",
								   @"getName",  @"requestingMethod",
								   nil];
	
	[UIAppDelegate.facebook requestWithGraphPath:@"me"
						 andParams: params
					   andDelegate:self];
	[fbButton updateImage];
}

/**
 * Callback for facebook did not login
 */
- (void)fbDidNotLogin:(BOOL)cancelled {
	[progressIndicator hideAlert];
	[self.infoLabel setText:@"Please log in"];
	NSLog(@"did not login");
	algorithmOptionView.hidden = YES;
	
}

/**
 * Callback for facebook logout
 */ 
-(void) fbDidLogout {
	[self.infoLabel setText:@"Please log in"];
	fbButton.isLoggedIn         = NO;
	[fbButton updateImage];
	algorithmOptionView.hidden = YES;

}


///////////////////////////////////////////////////////////////////////////////////////////////////
// FBRequestDelegate

/**
 * Callback when a request receives Response
 */ 
- (void)request:(FBRequest*)request didReceiveResponse:(NSURLResponse*)response{
	NSLog(@"received response");
	NSLog(@"%@",[response description]);
};

/**
 * Called when an error prevents the request from completing successfully.
 */
- (void)request:(FBRequest*)request didFailWithError:(NSError*)error{
	[self.infoLabel setText:[error localizedDescription]];
};

/**
 * Called when a request returns and its response has been parsed into an object.
 * The resulting object may be a dictionary, an array, a string, or a number, depending
 * on the format of the API response.
 */
- (void)request:(FBRequest*)request didLoad:(id)result {
	
	// Dump the JSON result to log, for dev and debugging purposes
	NSLog(@"User data : %@", result);

	// Find out what the requestor was
	NSMutableDictionary *params = request.params;
	NSString *requestor = [params objectForKey:@"requestingMethod"];
	NSLog(@"Requesting method: %@",requestor);
	
	// Set the users login name in the label
	if ([requestor isEqual:@"getName"]) {
		//[progressAlert dismissWithClickedButtonIndex:0 animated:TRUE];
		[progressIndicator hideAlert];
		[UIAppDelegate enableEncodeAndDecode:YES];

		NSLog(@"Found getName response");
		NSLog(@"%@", request.params);
		LoggedInUser *sharedUser = [LoggedInUser sharedUser];
		sharedUser.userId = [result objectForKey:@"id"];
		sharedUser.username = [result objectForKey:@"name"];

		NSString *welcome = [[NSString alloc]
							 initWithFormat:@"Hello %@",sharedUser.username];
		[self.infoLabel setText:welcome];
		[welcome release];
		algorithmOptionView.hidden = NO;
		
		// Set the data hiding method globally
		UIAppDelegate.binaryHiding = [binarySwitch isOn];
		UIAppDelegate.decimalHiding = [decimalSwitch isOn];

	}
	/*if ([params objectForKey:@"caller"]) {
		NSLog(@"Caller param received");
		//[self.infoLabel setText:@"Caller param received"];
	} else {
		NSLog(@"Caller param not received");
	}
	*/
};

///////////////////////////////////////////////////////////////////////////////////////////////////
// FBDialogDelegate

/** 
 * Called when a UIServer Dialog successfully return
 */
- (void)dialogDidComplete:(FBDialog*)dialog{
	[self.infoLabel setText:@"Dialog returned successfully"];
}

@end
