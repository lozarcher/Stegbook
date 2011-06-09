//
//  StegoViewController.h
//  Stegbook
//
//  Created by Loz Archer on 15/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"
#import "FBConnect.h"
#import "ProgressIndicator.h"

@interface StegoViewController : UIViewController
<UITextFieldDelegate, FBRequestDelegate, FBSessionDelegate, UIAlertViewDelegate>
{
	Photo *photo;
	IBOutlet UILabel *tagTotalLabel;
	IBOutlet UILabel *charsLeftLabel;
	IBOutlet UILabel *charsTotalLabel;
	IBOutlet UITextField *stegoTextField;
	NSInteger maximumChars;
	ProgressIndicator *progressIndicator;
}

@property (nonatomic, retain) Photo *photo;
@property (nonatomic, retain) UILabel *tagTotalLabel;
@property (nonatomic, retain) UILabel *charsLeftLabel;
@property (nonatomic, retain) UILabel *charsTotalLabel;
@property (nonatomic, retain) UITextField *stegoTextField;
@property (nonatomic) NSInteger maximumChars;

-(IBAction)enteredCharacter:(id)sender;

@end
