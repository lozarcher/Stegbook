//
//  AlbumTableViewController.m
//  Stegbook
//
//  Created by Loz Archer on 11/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AlbumTableViewController.h"
#import "PhotoTableViewController.h"
#import "StegbookAppDelegate.h"
#import "Album.h"
#import "Photo.h"
#import "Tag.h"
#import "User.h"

@implementation AlbumTableViewController

@synthesize albumTableView, albumControllers, user;

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

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)viewWillAppear:(BOOL)animated { 
	if (self.albumControllers != nil) {
		self.albumControllers = nil;
	}
	self.albumControllers = [[NSMutableArray alloc] init];

	progressIndicator = [[ProgressIndicator alloc] init];
	[progressIndicator showAlert:@"Retrieving albums" message:@"Please wait..."];
		
	NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								UIAppDelegate.facebook.accessToken,@"access_token",
								@"getAlbums",@"requestingMethod",nil];
	[UIAppDelegate.facebook requestWithGraphPath:[NSString stringWithFormat:@"%@/albums",user.userId] andParams:params andDelegate:self];
	NSLog(@"requested albums...");
	NSLog(@"request : %@/albums",user.userId);
	NSLog(@"params : %@", params);

	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {	
    [super viewDidAppear:animated];
}

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


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.albumControllers count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *AlbumCell = @"AlbumCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AlbumCell];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:AlbumCell] autorelease];
    }


    // Configure the cell...
	NSUInteger row = [indexPath row];
	PhotoTableViewController *controller = [self.albumControllers objectAtIndex:row];
	cell.textLabel.text = controller.title;
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%d photos", controller.album.photoCount];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	controller = nil;
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {	
	return @"Now select an album";
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
	AlbumTableViewController *nextController = [self.albumControllers objectAtIndex:row];
	[self.navigationController pushViewController:nextController animated:YES];
     // ...
     // Pass the selected object to the new view controller.
	 //[self.navigationController pushViewController:detailViewController animated:YES];
	 //[detailViewController release];
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
	self.albumControllers = nil;
    [super viewDidUnload];
}


- (void)dealloc {
	[self.albumControllers release];
    [super dealloc];
}

	  ///////////////////////////////////////////////////////////////////////////////////////////////////
	  // FBRequestDelegate
	  
	/**
	 * Callback when a request receives Response
	 */ 
	  - (void)request:(FBRequest*)request didReceiveResponse:(NSURLResponse*)response{
		  NSLog(@"received response");
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
		  
		  
		  if (requestor == @"getAlbums") {
			  result = [result objectForKey:@"data"];
			  NSLog(@"Album data %@", [NSString stringWithFormat:@"%@", result]);
			  NSInteger numberOfAlbums = [result count];
			  NSLog(@"Got %d albums", numberOfAlbums);
			  for (id album in result) {
				  NSString *albumId = [album objectForKey:@"id"];
				  NSString *albumName = [album objectForKey:@"name"];
				  NSInteger photoCount = [[album objectForKey:@"count"] intValue];
				  PhotoTableViewController *thisController = [[PhotoTableViewController alloc] init];
				  thisController.album = [[Album alloc] init];
				  thisController.title = albumName;
				  thisController.album.name = albumName;
				  thisController.album.albumId = albumId;
				  thisController.album.photoCount = photoCount;
				  
				  [self.albumControllers addObject:thisController];
				  [thisController release];
			  }
			  [self.tableView reloadData];
			  [progressIndicator hideAlert];
		  }
	  }

@end

