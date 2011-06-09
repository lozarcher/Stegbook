//
//  ImageViewController.h
//  Stegbook
//
//  Created by Loz Archer on 12/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h";
#import "FBConnect.h"

@interface ImageViewController : UIViewController
	<FBRequestDelegate, FBSessionDelegate, UIAlertViewDelegate>
{
	Photo *photo;
	UIImage *image;
	IBOutlet UIImageView *imageView;
	UIViewController *stegoView;
	NSString *mode;
}

@property (nonatomic, retain) Photo *photo;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UIViewController *stegoView;
@property (nonatomic, retain) NSString *mode;

@end
