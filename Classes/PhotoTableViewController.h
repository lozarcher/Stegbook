//
//  PhotoViewController.h
//  Stegbook
//
//  Created by Loz Archer on 11/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"
#import "Album.h"
#import "ProgressIndicator.h"

@interface PhotoTableViewController : UITableViewController 
<UITableViewDelegate, UITableViewDataSource, FBRequestDelegate, FBSessionDelegate>
{
	IBOutlet UITableView *photoTableView;
	NSMutableArray *photoControllers;
	NSString *albumId;
	ProgressIndicator *progressIndicator;
}
@property (nonatomic, retain) UITableView *photoTableView;
@property (nonatomic, retain) NSMutableArray *photoControllers;
@property (nonatomic, retain) Album	*album;

@end
