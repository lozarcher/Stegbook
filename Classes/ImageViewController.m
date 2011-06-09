//
//  ImageViewController.m
//  Stegbook
//
//  Created by Loz Archer on 12/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ImageViewController.h"
#import "Tag.h"
#import "StegbookAppDelegate.h"
#import "StegoViewController.h"
#import "LoggedInUser.h"

@implementation ImageViewController

@synthesize	photo, image, imageView, mode, stegoView;

#pragma mark -
#pragma mark View lifecycle

- (void)loadStegView:(id)sender {
	NSLog(@"Load steg view");
	StegoViewController *nextController = [[StegoViewController alloc] initWithNibName:@"StegoView" bundle:nil];
	nextController.photo = [self photo];
	[self.navigationController pushViewController:nextController animated:YES];
	[nextController release];
}

- (void)decodeTags:(id)sender {
	NSLog(@"Decode clicked");
	NSString *hiddenData = [photo decodeDataFromTags];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Decoded Data"
							   message: hiddenData
							  delegate: self
					 cancelButtonTitle: @"OK"
					 otherButtonTitles: nil];
    [alert show];
    [alert release];
	
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (mode == @"decode") {
		self.tabBarController.selectedIndex = 0;
		[self.navigationController popToRootViewControllerAnimated:YES];
	}
}

// The pid is needed by the old API, which we need to use for adding tags
-(void)getPidFromObjectId:(NSString *)objId {
	User *sharedUser = [LoggedInUser sharedUser];
	NSString* fql = [NSString stringWithFormat:
					 @"SELECT pid, object_id FROM photo WHERE aid IN ( SELECT aid FROM album WHERE owner=%@)",
					 sharedUser.userId];
	NSLog(@"Querying with: %@", fql);
	
	NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys: 
								   fql, @"query",
								   @"pidFromObjectId", @"requestingMethod",
								   UIAppDelegate.facebook.accessToken,@"access_token",
								   nil];
	
	[UIAppDelegate.facebook requestWithMethodName:@"fql.query" andParams:params andHttpMethod:@"POST" andDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated {
	
	if (mode == @"encode") {
		UIBarButtonItem *stegButton = [[UIBarButtonItem alloc] initWithTitle:@"Hide Data" style:UIBarButtonSystemItemAdd target:self action:@selector(loadStegView:)];
		self.navigationItem.rightBarButtonItem = stegButton;
		[stegButton release];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Place Tags"
														message: @"Tap your photo to place up to 20 tags upon it. You will be able to hide two characters of data within each tag you place"
													   delegate: self
											  cancelButtonTitle: @"OK"
											  otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
	if (mode == @"decode") {
		UIBarButtonItem *decodeButton = [[UIBarButtonItem alloc] initWithTitle:@"Get Data" style:UIBarButtonSystemItemAdd target:self action:@selector(decodeTags:)];
		self.navigationItem.rightBarButtonItem = decodeButton;
		[decodeButton release];				
	}

	if (imageView.image == nil) {
		NSData *data = [[NSData alloc] initWithContentsOfURL:photo.imageUrl];
		UIImage *sourceImage = [[UIImage alloc] initWithData:data];
		
		float actualHeight = sourceImage.size.height;
		float actualWidth = sourceImage.size.width;
		float imgRatio = actualWidth/actualHeight;
		//float maxRatio = 320.0/480.0;
		float maxRatio = imageView.frame.size.width / imageView.frame.size.height; 
			
		NSLog(@"Image size: %f %f", actualWidth, actualHeight);
		NSLog(@"Frame size: %f %f", imageView.frame.size.width, imageView.frame.size.height);
		
		if(imgRatio!=maxRatio){
			if(imgRatio < maxRatio){
				//imgRatio = 480.0 / actualHeight;
				imgRatio = imageView.frame.size.height / actualHeight;
				actualWidth = imgRatio * actualWidth;
				//actualHeight = 480.0;
				actualHeight = imageView.frame.size.height;
			}
			else{
				//imgRatio = 320.0 / actualWidth;
				imgRatio = imageView.frame.size.width / actualWidth;
				actualHeight = imgRatio * actualHeight;
				//actualWidth = 320.0;
				actualWidth = imageView.frame.size.width;

			}
		}
		CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
		UIGraphicsBeginImageContext(rect.size);
		[sourceImage drawInRect:rect];
		UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		imageView.frame = rect;
		imageView.image = resizedImage;
		self.image = resizedImage;
		
		[sourceImage release];
		[data release];
		
		[self getPidFromObjectId:photo.objectId];

		NSLog(@"Tags: %d",[photo.tags count]);
		for (Tag *thisTag in photo.tags) {

			CGPoint pt = CGPointMake([thisTag.x floatValue] * actualWidth / 100,
									 [thisTag.y floatValue] * actualHeight / 100);
			NSLog(@"Tag Name: %@", thisTag.name);
			NSLog(@"Tag X: %@", thisTag.x);
			NSLog(@"Tag Y: %@", thisTag.y);
			NSLog(@"Pixels X: %f", pt.x);
			NSLog(@"Pixels Y: %f", pt.y);
			
			UIImage *tagPin = [UIImage imageNamed:@"pin.png"];
			UIImageView *i=[[UIImageView alloc] initWithImage:tagPin];
			[i setFrame:CGRectMake(pt.x-(tagPin.size.width/2),pt.y-tagPin.size.height,tagPin.size.width,tagPin.size.height)]; 
			[imageView addSubview:i];
			[i release];
		}
	}
}



- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    // Retrieve the touch point
	UITouch *touch = [touches anyObject];
    CGPoint pt = [touch locationInView:imageView];
	NSLog(@"Touched at %f %f", pt.x, pt.y);
	
	if (mode == @"encode" ) {
		if(([touch view] == imageView) && ([photo.tags count] < 20)) {			
			UIImage *tagPin = [UIImage imageNamed:@"pin.png"];
			UIImageView *i=[[UIImageView alloc] initWithImage:tagPin];
			[i setFrame:CGRectMake(pt.x-(tagPin.size.width/2),pt.y-tagPin.size.height,tagPin.size.width,tagPin.size.height)]; 
			[[self view] addSubview:i];
			[[self.view superview] bringSubviewToFront:i];
			[i release];
			[photo.tags addObject:[[Tag alloc] pointToTag:pt image:self.image]];
		}
	}
}

/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */
 - (void)viewWillDisappear:(BOOL)animated {
	 [super viewWillDisappear:animated];
 }
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */
/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
// FBRequestDelegate

/**
 * Callback when a request receives Response
 */ 
- (void)request:(FBRequest*)request didReceiveResponse:(NSURLResponse*)response{
	NSLog(@"received response");
	NSLog(@"Url was %@", request.url);
	NSLog(@"Params were %@", request.params);
}

/**
 * Called when an error prevents the request from completing successfully.
 */
- (void)request:(FBRequest*)request didFailWithError:(NSError*)error{
	NSLog(@"%@",[error localizedDescription]);
};

/**
 * Called when a request returns and its response has been parsed into an object.
 * The resulting object may be a dictionary, an array, a string, or a number, depending
 * on thee format of the API response.
 */
- (void)request:(FBRequest*)request didLoad:(id)result {
	NSMutableDictionary *params = request.params;
	NSString *requestor = [params objectForKey:@"requestingMethod"];

	NSLog(@"Requesting method: %@",requestor);

	if ([requestor isEqualToString:@"pidFromObjectId"]) {
		NSLog(@"pidFromObjectId");
		
		NSLog(@"Got %d results", [result count]);
		NSMutableDictionary *idsDictionary = [[NSMutableDictionary alloc] init];
		NSLog(@"Object ID is %@", photo.objectId);
		for (id pair in result) {
			NSString *pid = [pair objectForKey:@"pid"];
			NSString *objectId = [pair objectForKey:@"object_id"];
			[idsDictionary setObject:pid forKey:[NSString stringWithFormat:@"%@",objectId]];
		}		
		photo.pid = [idsDictionary objectForKey:[NSString stringWithFormat:@"%@",photo.objectId]];
		[idsDictionary release];
		
		
		/*
		 Use this in the tagging view controller to set the tags, after having deleted any first
		 
		NSLog(@"objectId: %@", photo.objectId);
		NSLog(@"pid: %@", photo.pid);
		NSLog(@"access_token: %@", UIAppDelegate.facebook.accessToken);
		
		 NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys: 
		 [NSString stringWithFormat:@"%@",photo.pid], @"pid",
		 @"addTag", @"requestingMethod",
		 @"None", @"tag_text",
		 [NSString stringWithFormat:@"%f", newtagX], @"x",
		 [NSString stringWithFormat:@"%f", newtagY], @"y",
		 UIAppDelegate.facebook.accessToken,@"access_token",
		 nil];
		 
		 [UIAppDelegate.facebook requestWithMethodName: @"photos.addTag" andParams: params andHttpMethod: @"POST" andDelegate: self];
		 */
	}
}
@end
