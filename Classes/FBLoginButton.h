//
//  FBLoginButton.h
//  Stegbook
//
//  Created by Loz Archer on 10/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBLoginButton : UIButton {
	BOOL isLoggedIn;
}

@property(nonatomic) BOOL isLoggedIn; 

- (void) updateImage;

@end
