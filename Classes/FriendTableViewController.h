//
//  FriendViewController.h
//  Stegbook
//
//  Created by Loz Archer on 22/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"
#import "ProgressIndicator.h"

@interface FriendTableViewController : UITableViewController
<UITableViewDelegate, UITableViewDataSource, FBRequestDelegate, FBSessionDelegate>
{
	IBOutlet UITableView *friendTable;
	NSMutableArray *friendControllers;
	ProgressIndicator *progressIndicator;
}

@property (nonatomic, retain) UITableView *friendTable;
@property (nonatomic, retain) NSMutableArray *friendControllers;

@end
