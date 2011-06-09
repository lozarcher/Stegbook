//
//  UploadImageViewController.m
//  Stegbook
//
//  Created by Loz Archer on 21/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UploadImageViewController.h"
#import "StegbookAppDelegate.h"
#import "ImageViewController.h"
#import "Photo.h"

@implementation UploadImageViewController

@synthesize albumPicker, albumNames, albumIds, image;

static NSInteger selectedAlbumIndex = 0;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	if (self.albumNames == nil) {
		progressIndicator = [[ProgressIndicator alloc] init];
		[progressIndicator showAlert:@"Retrieving albums" message:@"Please wait..."];
		NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								   UIAppDelegate.facebook.accessToken,@"access_token",
								   @"getAlbums",@"requestingMethod",nil];
		[UIAppDelegate.facebook requestWithGraphPath:@"me/albums" andParams:params andDelegate:self];
		NSLog(@"requested albums...");
		NSMutableDictionary *initDictionary = [[NSMutableDictionary alloc] init];
		self.albumIds = initDictionary;
		[initDictionary release];
	
		NSMutableArray *initNames = [[NSMutableArray alloc] init];
		self.albumNames = initNames;
		[initNames release];
	}
	[super viewDidLoad];
}

- (void)uploadPhoto:(id)sender {
	//NSInteger selectedRow = [albumPicker selectedRowInComponent:0];
	NSInteger selectedRow = selectedAlbumIndex;
	NSString *albumName = [albumNames objectAtIndex:selectedRow];
	NSLog(@"albumPicker = %@", albumPicker);
	NSLog(@"Selected item in picker: %d", selectedRow);
	
	NSString *albumId = [albumIds objectForKey:albumName];
	NSLog(@"Uploading photo to album %@ albumId %@", albumName, albumId);
	progressIndicator = [[ProgressIndicator alloc] init];
	[progressIndicator showAlert:@"Uploading photo" message:@"Please wait..."];
	
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
									self.image, @"picture",
								    @"uploadPhoto",@"requestingMethod",
									nil];
	[UIAppDelegate.facebook requestWithGraphPath:[NSString stringWithFormat:@"%@/photos",albumId] 
						   andParams: params
					   andHttpMethod: @"POST" 
						 andDelegate: self];

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
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
	self.albumNames = nil;
	self.albumIds = nil;
	self.image = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[albumNames release];
	[albumIds release];
    [super dealloc];
}

#pragma mark - 
#pragma mark Picker Data Source Methods 
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
} 
- (NSInteger)pickerView:(UIPickerView *)pickerView
  numberOfRowsInComponent:(NSInteger)component { 
	NSLog(@"Number of rows : %d", [albumNames count]);
	return [albumNames count];
} 
#pragma mark Picker Delegate Methods 
- (NSString *)pickerView:(UIPickerView *)pickerView
	titleForRow:(NSInteger)row
	forComponent:(NSInteger)component 
{ 
	NSString* title = [albumNames objectAtIndex:row];
	NSLog(@"Title for row %d component %d = %@", row, component, title);
	return title;
}
//PickerViewController.m
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	selectedAlbumIndex = row;
	NSLog(@"Selected row %d (%@) in component %d", row, [albumNames objectAtIndex:row], component);
}

#pragma mark - 
#pragma mark Facebook Delegate Methods 

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
	NSLog(@"%@",[error localizedDescription]);
}

/**
 * Called when a request returns and its response has been parsed into an object.
 * The resulting object may be a dictionary, an array, a string, or a number, depending
 * on thee format of the API response.
 */
- (void)request:(FBRequest*)request didLoad:(id)result {
	NSMutableDictionary *params = request.params;
	NSString *requestor = [params objectForKey:@"requestingMethod"];
	NSLog(@"Requesting method: %@",requestor);
	
	if (requestor == @"getAlbums") {

		result = [result objectForKey:@"data"];
		NSInteger numberOfAlbums = [result count];
		NSLog(@"Got %d albums", numberOfAlbums);
		for (id album in result) {
			//NSLog(@"Album data %@", [NSString stringWithFormat:@"%@", album]);

			NSString *albumId = [album objectForKey:@"id"];
			NSString *albumName = [album objectForKey:@"name"];
			[self.albumIds setObject:albumId forKey:albumName];
			[self.albumNames addObject:albumName];
		}
		UIBarButtonItem *uploadButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(uploadPhoto:)];
		self.navigationItem.rightBarButtonItem = uploadButton;
		NSLog(@"Reloading album picker...");
		[albumPicker reloadComponent:0];
		[progressIndicator hideAlert];
	}	
	if (requestor == @"uploadPhoto") {
		NSLog(@"Response back from uploadPhoto: %@",result);
		NSString *photoId = [result objectForKey:@"id"];
		// Get more information about the photo
		NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
									   UIAppDelegate.facebook.accessToken,@"access_token",
									   @"getPhotoInfo",@"requestingMethod",nil];
		[UIAppDelegate.facebook requestWithGraphPath:[NSString stringWithFormat:@"%@",photoId] andParams:params andDelegate:self];
		NSLog(@"requested photo info...");	
	}
	if (requestor == @"getPhotoInfo") {
		[progressIndicator hideAlert];
		ImageViewController *nextController = [[ImageViewController alloc] initWithNibName:@"TagImageView" bundle:nil];
		nextController.title = @"Tag Photo";
		nextController.image = image;
		Photo *newPhoto = [[Photo alloc] init];
		newPhoto.name = @"";
		newPhoto.objectId = [result objectForKey:@"id"];
		newPhoto.thumbnailUrl = [[NSURL alloc] initWithString:[result objectForKey:@"picture"]];
		newPhoto.imageUrl = [[NSURL alloc] initWithString:[result objectForKey:@"source"]];
		nextController.photo = newPhoto;
		nextController.mode = @"encode";
		[newPhoto release];
		
		[self.navigationController pushViewController:nextController animated:YES];
		[nextController release];
	}
}

@end
