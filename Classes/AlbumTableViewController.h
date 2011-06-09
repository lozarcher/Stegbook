//
//  AlbumTableViewController.h
//  Stegbook
//
//  Created by Loz Archer on 11/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FBConnect.h"
#import "User.h"
#import "ProgressIndicator.h"

@interface AlbumTableViewController : UITableViewController
<UITableViewDelegate, UITableViewDataSource, FBRequestDelegate, FBSessionDelegate>
{
	IBOutlet UITableView *albumTableView;
	NSMutableArray *albumControllers;
	User *user;
	ProgressIndicator* progressIndicator;
}

@property (nonatomic, retain) UITableView *albumTableView;
@property (nonatomic, retain) NSMutableArray *albumControllers;
@property (nonatomic, retain) User *user;

@end
