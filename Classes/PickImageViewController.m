    //
//  PickImageViewController.m
//  Stegbook
//
//  Created by Loz Archer on 20/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PickImageViewController.h"
#import "UploadImageViewController.h"
#import "UIImageResize.h"

@implementation PickImageViewController

static int imageResizeBounds = 400;

//@synthesize pickImageView;

-(void)takePhoto:(id)sender {
	
	UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = 
	UIImagePickerControllerSourceTypeCamera;
	
	[self presentModalViewController:imagePickerController animated:YES];

	[imagePickerController release];
}

-(void)chooseFromLibrary:(id)sender {
	
	UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = 
	UIImagePickerControllerSourceTypePhotoLibrary;
	
	[self presentModalViewController:imagePickerController animated:YES];
	[imagePickerController release];
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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
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


// Image picker controller delegate
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	
	// Access the uncropped image from info dictionary
	UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];

	//resize here
	UIImage *scaledImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit
														bounds:CGSizeMake(imageResizeBounds,imageResizeBounds)
										  interpolationQuality:kCGInterpolationDefault];
	image = nil;
	
	/*
	 if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
		// Save image
		UIImageWriteToSavedPhotosAlbum(scaledImage, self, @selector(scaledImage:didFinishSavingWithError:contextInfo:), nil);
	}
	 */
	[picker dismissModalViewControllerAnimated:YES];
    picker.view.hidden = YES;
	
	//upload to facebook
	//in callback create an image view controller as shown below
	//also set the photo object within it so that the image displays
	//also need to choose which album to upload into
	UploadImageViewController *nextController = [[UploadImageViewController alloc] init];
	nextController.title = @"Upload image";
	nextController.image = scaledImage;
	[self.navigationController pushViewController:nextController animated:YES];
	[nextController release];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
	UIAlertView *alert;
	
	// Unable to save the image  
	if (error)
		alert = [[UIAlertView alloc] initWithTitle:@"Error" 
										   message:@"Unable to save image to Photo Album." 
										  delegate:self cancelButtonTitle:@"Ok" 
								 otherButtonTitles:nil];
	[alert show];
	[alert release];


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
}

@end
