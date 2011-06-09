//
//  StegoViewController.m
//  Stegbook
//
//  Created by Loz Archer on 15/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "StegoViewController.h"
#import "Photo.h"
#import "Tag.h"
#import "StegbookAppDelegate.h"
#import "FBConnect.h"

@implementation StegoViewController

@synthesize photo, stegoTextField, maximumChars, charsLeftLabel, charsTotalLabel, tagTotalLabel;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

-(void)saveATag {
	NSLog(@"In saveATag. %d tags left",[photo.tags count]);
	
	Tag *thisTag = [photo.tags objectAtIndex:0];
	NSLog(@"Name: %@",thisTag.name);
	NSLog(@"Tag X: %@", thisTag.x);
	NSLog(@"Tag Y: %@", thisTag.y);
	NSLog(@"Photo pid: %@", photo.pid);		
			
	NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys: 
						[NSString stringWithFormat:@"%@",photo.pid], @"pid",
						@"addTag", @"requestingMethod",
						@"None", @"tag_text",
						[NSString stringWithFormat:@"%@", thisTag.x], @"x",
						[NSString stringWithFormat:@"%@",thisTag.y], @"y",
						UIAppDelegate.facebook.accessToken,@"access_token",
						nil];
	NSLog(@"sending addTag request");
	[photo.tags removeObjectAtIndex:0];
	[UIAppDelegate.facebook requestWithMethodName: @"photos.addTag" andParams: params andHttpMethod: @"POST" andDelegate: self];	
}

- (void)saveTags:(id)sender {
	NSLog(@"Save tags");
	NSLog(@"There are %d tags",[photo.tags count]);

	// encode data in tags
	[photo encodeDataInTags:stegoTextField.text];
	
	//NSLog(@"Checking by decoding...");
	//NSString *decodedData = [[NSString alloc] initWithString:[photo decodeDataFromTags]];
	//NSLog(@"Decoded string %@", decodedData);
	//[decodedData release];
	
	// store tags
	NSLog (@"About to store %d tags...",[photo.tags count]);
	progressIndicator = [[ProgressIndicator alloc] init];
	[progressIndicator showAlert:@"Saving tags" message:@"Please wait..."];
	
	if ([photo.tags count] > 0) {
		[self saveATag];
	}
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveTags:)];
	
	self.navigationItem.rightBarButtonItem = saveButton;
	self.navigationItem.title = @"Hide Data";
	NSInteger numberOfTags = [photo.tags count];
	maximumChars = numberOfTags * 2;
	charsTotalLabel.text =[NSString stringWithFormat:@"You can hide up to %d characters in %d tags", maximumChars, numberOfTags];
	charsLeftLabel.text =[NSString stringWithFormat:@"%d characters remaining",maximumChars];
    [super viewDidLoad];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
	NSLog(@"Stegoviewcontroller recieved memory warning");
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	NSLog(@"Stegoviewcontroller unloading");

    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	NSLog(@"Stegoviewcontroller deallocated");

    [super dealloc];
}

																		
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	if (range.location >= maximumChars) {
        return NO; // return NO to not change text
	}
    return YES;
}

- (IBAction)enteredCharacter:(id)sender {
	
	charsLeftLabel.text = [NSString stringWithFormat:@"%d characters remaining",maximumChars-[stegoTextField.text length]];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// FBRequestDelegate

/**
 * Callback when a request receives Response
 */ 
- (void)request:(FBRequest*)request didReceiveResponse:(NSURLResponse*)response{
	NSLog(@"received response");
}

/**
 * Called when an error prevents the request from completing successfully.
 */
- (void)request:(FBRequest*)request didFailWithError:(NSError*)error{
	NSLog(@"Error: %@",[error localizedDescription]);
	NSLog(@"URL was %@", request.url);
	NSLog(@"Params were %@", request.params);
};

/**
 * Called when a request returns and its response has been parsed into an object.
 * The resulting object may be a dictionary, an array, a string, or a number, depending
 * on thee format of the API response.
 */
- (void)request:(FBRequest*)request didLoad:(id)result {
	NSLog(@"Request loaded");
	NSMutableDictionary *params = request.params;
	NSString *requestor = [params objectForKey:@"requestingMethod"];
	
	NSLog(@"Requesting method: %@",requestor);
	if ([requestor isEqualToString:@"addTag"]) {
		NSLog(@"Add tag response received");
		NSLog(@"Response: %@", result);
		if ([photo.tags count] > 0) {
			[self saveATag];
		} else {
			[progressIndicator hideAlert];
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Encoded Data"
															message: @"Your message has been hidden"
														   delegate: self
												  cancelButtonTitle: @"OK"
												  otherButtonTitles: nil];
			[alert show];
			[alert release];
		}
	}
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	self.tabBarController.selectedIndex = 0;
	[self.navigationController popToRootViewControllerAnimated:YES];
}


@end
