//
//  ProgressIndicator.m
//  Stegbook
//
//  Created by Loz Archer on 05/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ProgressIndicator.h"

@implementation ProgressIndicator

- (void) showAlert:(NSString *)title message:(NSString *)message {	
	progressAlert = [[UIAlertView alloc] initWithTitle:title
								message:message
								delegate: self
								cancelButtonTitle: nil
								otherButtonTitles: nil];

	UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	activityView.frame = CGRectMake(139.0f-18.0f, 80.0f, 37.0f, 37.0f);
	[progressAlert addSubview:activityView];
	[activityView startAnimating];
	[progressAlert show];
	[progressAlert release];
}

- (void) hideAlert {
	[progressAlert dismissWithClickedButtonIndex:0 animated:TRUE];
}

@end
