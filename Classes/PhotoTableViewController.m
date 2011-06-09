//
//  PhotoViewController.m
//  Stegbook
//
//  Created by Loz Archer on 11/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PhotoTableViewController.h"
#import "ImageViewController.h"
#import "StegbookAppDelegate.h"
#import "Photo.h"
#import "Tag.h"
#import "AsyncImageView.h"

@implementation PhotoTableViewController

@synthesize photoTableView, photoControllers, album;

#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
    }
    return self;
}
*/


#pragma mark -
#pragma mark View lifecycle

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/

- (void)viewWillAppear:(BOOL)animated {
	NSLog(@"in photoTableViewController");
	if (self.photoControllers != nil) {
		self.photoControllers = nil;
	}
	self.photoControllers = [[NSMutableArray alloc] init];
	
	progressIndicator = [[ProgressIndicator alloc] init];
	[progressIndicator showAlert:@"Retrieving photos" message:@"Please wait..."];
	
	NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								UIAppDelegate.facebook.accessToken,@"access_token",
								@"getPhotos",@"requestingMethod",
								@"200",@"limit",
								album.albumId, @"albumId",
								album.name, @"albumName", nil];
	NSLog(@"Album id: %@",album.albumId);
	NSString *requestUrl = [[NSString alloc] initWithFormat:@"%@/photos",album.albumId];
	[UIAppDelegate.facebook requestWithGraphPath:requestUrl andParams:params andDelegate:self];
	[requestUrl release];
	NSLog(@"requested photos...");
    [super viewWillAppear:animated];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
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


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.photoControllers count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 75;
}


- (UITableViewCell *) getCellContentView:(NSString *)cellIdentifier {
	
	CGRect CellFrame = CGRectMake(0, 0, 300, 75);
	CGRect Label1Frame = CGRectMake(80, 10, 220, 25);
	CGRect Label2Frame = CGRectMake(80, 40, 220, 25);
	UILabel *lblTemp;
	
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:CellFrame reuseIdentifier:cellIdentifier] autorelease];
	
	//Initialize Label with tag 1.
	lblTemp = [[UILabel alloc] initWithFrame:Label1Frame];
	lblTemp.tag = 1;
	[cell.contentView addSubview:lblTemp];
	[lblTemp release];
	
	//Initialize Label with tag 2.
	lblTemp = [[UILabel alloc] initWithFrame:Label2Frame];
	lblTemp.tag = 2;
	lblTemp.font = [UIFont boldSystemFontOfSize:12];
	lblTemp.textColor = [UIColor lightGrayColor];
	[cell.contentView addSubview:lblTemp];
	[lblTemp release];
	
	return cell;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
	AsyncImageView *oldImage;
	UITableViewCell *cell = [self getCellContentView:CellIdentifier];
	
    // Configure the cell...
	NSUInteger row = [indexPath row];
	NSLog(@"Drawing row %d", row);
	ImageViewController *controller = [self.photoControllers objectAtIndex:row];
	
	UILabel *headingLabel = (UILabel *)[cell viewWithTag:1];
	[headingLabel setText:[NSString stringWithFormat:@"By %@", controller.photo.uploadedBy]];
	[headingLabel setTextColor:[UIColor blackColor]];
	
	UILabel *timestampLabel = (UILabel *)[cell viewWithTag:2];
	
	NSLog(@"Date : %@",controller.photo.timestamp);
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	
	[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
	NSDate *myDate = [[[NSDate alloc] init] autorelease];
	myDate = [dateFormatter dateFromString:controller.photo.timestamp];
	
	[timestampLabel setText:[NSString stringWithFormat:@"on %@", myDate]];
	[timestampLabel setTextColor:[UIColor grayColor]];
	
		
	CGRect frame = CGRectMake(0,0,75,75);
	
	if (oldImage != nil) {
		AsyncImageView* asyncImage = [[[AsyncImageView alloc]
								   initWithFrame:frame] autorelease];
		asyncImage.tag = [indexPath row];
		[asyncImage loadImageFromURL:controller.photo.thumbnailUrl];

		[cell.contentView addSubview:asyncImage];
	} else {
		[cell.contentView addSubview:oldImage];
	}
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {	
	return @"Next select a photo";
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	NSUInteger row = [indexPath row];
	ImageViewController *nextController = [self.photoControllers objectAtIndex:row];
	[self.navigationController pushViewController:nextController animated:YES];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	self.photoControllers = nil;
    [super viewDidUnload];
}


- (void)dealloc {
	[self.photoControllers release];
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// FBRequestDelegate

/**
 * Callback when a request receives Response
 */ 
- (void)request:(FBRequest*)request didReceiveResponse:(NSURLResponse*)response{
	NSLog(@"received response");
	NSLog(@"%@",request);
	NSLog(@"%@",response);

};

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
	
	if (requestor == @"getPhotos") {
		[progressIndicator hideAlert];
		result = [result objectForKey:@"data"];
		NSLog(@"Photo : %@", result);
		NSInteger numberOfPhotos = [result count];
		NSLog(@"Got %d photos", numberOfPhotos);
		for (id photo in result) {
			Photo *thisPhoto = [[Photo alloc] init];
			
			thisPhoto.name = [photo objectForKey:@"name"];
			thisPhoto.objectId = [photo objectForKey:@"id"];
			
			NSDictionary *from = [photo objectForKey:@"from"];
			thisPhoto.uploadedBy = [from objectForKey:@"name"];
			thisPhoto.timestamp = [photo objectForKey:@"created_time"];
			
			thisPhoto.pid = nil;
			NSLog(@"Photo object ID: %@", thisPhoto.objectId);
			NSLog(@"Photo pid: %@", thisPhoto.pid);
			
			NSLog(@"Photo Link: %@", [photo objectForKey:@"link"]);
			thisPhoto.thumbnailUrl = [[NSURL alloc] initWithString:[photo objectForKey:@"picture"]];
			thisPhoto.imageUrl = [[NSURL alloc] initWithString:[photo objectForKey:@"source"]];
			
			NSArray *tags = [photo valueForKeyPath:@"tags.data"];
			
			for (id tag in tags) {
				NSLog(@"Tag data : %@", tag);
				Tag *thisTag = [[Tag alloc] init];
				thisTag.name = [tag objectForKey:@"name"];
				thisTag.x = [tag objectForKey:@"x"];
				thisTag.y = [tag objectForKey:@"y"];
				[thisPhoto.tags addObject:thisTag];
				[thisTag release];
			}
			
			NSLog(@"Number of tags: %d",[tags count]);
			
			ImageViewController *nextController = [[ImageViewController alloc] initWithNibName:@"TagImageView" bundle:nil];

			nextController.photo = thisPhoto;
			nextController.title = thisPhoto.name;
			nextController.mode = @"decode";
			[self.photoControllers addObject:nextController];
			[nextController release];			
			[thisPhoto release];
			
			//NSLog(@"Photo data: %@", result);
		}

				
		[self.tableView reloadData];
	}
	
}

@end

