//
//  UIProgressHUD.m
//  Stegbook
//
//  Created by Loz Archer on 30/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UIProgressHUD.h"


@implementation UIProgressHUD

- (void) killHUD: (id) aHUD {
	[aHUD show:NO]; 
	[aHUD release];
}

- (void) presentSheet {
	id HUD = [[UIProgressHUD alloc] initWithWindow:[contentView superview]]; 
	[HUD setText:@"Downloading File. Please wait."]; 
	[HUD show:YES];
	[self performSelector:@selector(killHUD:) withObject:HUD afterDelay:5.0];
}
@end
