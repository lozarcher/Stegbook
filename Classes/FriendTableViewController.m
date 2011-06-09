//
//  FriendViewController.m
//  Stegbook
//
//  Created by Loz Archer on 22/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FriendTableViewController.h"
#import "AlbumTableViewController.h"
#import "StegbookAppDelegate.h"
#import "User.h"
#import "LoggedInUser.h"

@implementation FriendTableViewController

@synthesize friendTable, friendControllers;

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

	if (self.friendControllers != nil) {
		self.friendControllers = nil;
	}
	self.friendControllers = [[NSMutableArray alloc] init];
		
	progressIndicator = [[ProgressIndicator alloc] init];
	[progressIndicator showAlert:@"Retrieving friends" message:@"Please wait..."];
		
	NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								   UIAppDelegate.facebook.accessToken,@"access_token",
								   @"getFriends",@"requestingMethod",nil];
	[UIAppDelegate.facebook requestWithGraphPath:@"me/friends" andParams:params andDelegate:self];
	NSLog(@"requested friends...");
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


#pragma mark -
#pragma mark Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	NSUInteger row = [indexPath row];
	FriendTableViewController *nextController = [self.friendControllers objectAtIndex:row];
	[self.navigationController pushViewController:nextController animated:YES];
	// ...
	// Pass the selected object to the new view controller.
	//[self.navigationController pushViewController:detailViewController animated:YES];
	//[detailViewController release];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	NSLog(@"There are %d rows", [self.friendControllers count]);
    return [self.friendControllers count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {	
	return @"Select a friend from the list below";
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *FriendCell = @"FriendCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FriendCell];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FriendCell] autorelease];
    }
	
	
    // Configure the cell...
	NSUInteger row = [indexPath row];
	NSLog(@"Drawing row %d", row);
	AlbumTableViewController *controller = [self.friendControllers objectAtIndex:row];
	cell.textLabel.text = controller.title;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	controller = nil;
    return cell;
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
	
	AlbumTableViewController *newController = [[AlbumTableViewController alloc] init];
	newController.user = [LoggedInUser sharedUser];
	newController.title = @"Me";
	[friendControllers addObject:newController];
	[newController release];
	
	if (requestor == @"getFriends") {
		[progressIndicator hideAlert];
		
		result = [result objectForKey:@"data"];
		NSInteger numberOfFriends = [result count];
		NSLog(@"Got %d friends", numberOfFriends);
		
		NSSortDescriptor *nameSD = [NSSortDescriptor sortDescriptorWithKey: @"name" ascending: YES];
		NSArray *sortedByName = [result sortedArrayUsingDescriptors:[NSArray arrayWithObject:nameSD]];
		
		for (id friend in sortedByName) {
			NSString *friendId = [friend objectForKey:@"id"];
			NSString *friendName = [friend objectForKey:@"name"];
			AlbumTableViewController *newController = [[AlbumTableViewController alloc] init];
			newController.title = friendName;
			newController.user = [[User alloc] init];
			newController.user.userId = friendId;
			newController.user.username	= friendName;
			[self.friendControllers addObject:newController];
			[newController release];	
		}
		[self.friendTable reloadData];
	}
	
}

@end
