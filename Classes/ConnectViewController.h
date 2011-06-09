//
//  LoginViewController.h
//  Stegbook
//
//  Created by Loz Archer on 10/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"
#import "FBLoginButton.h"
#import "ProgressIndicator.h"

@class Reachability;

static NSString* kAppId = @"121706031221323";

@interface ConnectViewController : UIViewController
<FBRequestDelegate,
FBDialogDelegate,
FBSessionDelegate>
{
	IBOutlet UILabel* infoLabel;
	IBOutlet UISwitch* binarySwitch;
	IBOutlet UISwitch* decimalSwitch;
	IBOutlet FBLoginButton* fbButton;
	IBOutlet UIView* algorithmOptionView;
	NSArray* permissions;
	Reachability* internetReachable;
    Reachability* hostReachable;
	ProgressIndicator* progressIndicator;
}

@property(nonatomic, retain) UILabel* infoLabel;
@property(nonatomic, retain) FBLoginButton* fbButton;
@property(nonatomic, retain) UIView* algorithmOptionView;
@property(nonatomic, retain) UISwitch* binarySwitch;
@property(nonatomic, retain) UISwitch* decimalSwitch;
@property(nonatomic, retain) NSArray* permissions;
-(IBAction) fbButtonClick: (id) sender;
-(IBAction) switchChanged: (id) sender;
- (void) checkNetworkStatus:(NSNotification *)notice;

@end
