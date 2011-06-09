//
//  FBLoginButton.m
//  Stegbook
//
//  Created by Loz Archer on 10/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FBLoginButton.h"
#import "Facebook.h"

#import <dlfcn.h>

@implementation FBLoginButton

@synthesize isLoggedIn;

/**
 * return the regular button image according to the login status
 */
- (UIImage*)buttonImage {
	if (isLoggedIn) {
		return [UIImage imageNamed:@"LogoutNormal.png"];
	} else {
		return [UIImage imageNamed:@"LoginNormal.png"];
	}
}

/**
 * return the highlighted button image according to the login status
 */
- (UIImage*)buttonHighlightedImage {
	if (isLoggedIn) {
		return [UIImage imageNamed:@"LogoutPressed.png"];
	} else {
		return [UIImage imageNamed:@"LoginPressed.png"];
	}
}

/**
 * To be called whenever the login status is changed
 */
- (void)updateImage {
	self.imageView.image = [self buttonImage];
	[self setImage: [self buttonImage]
		  forState: UIControlStateNormal];
	
	[self setImage: [self buttonHighlightedImage]
		  forState: UIControlStateHighlighted |UIControlStateSelected];
}

@end
