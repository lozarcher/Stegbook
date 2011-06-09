//
//  ProgressIndicator.h
//  Stegbook
//
//  Created by Loz Archer on 05/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ProgressIndicator : NSObject {
	UIAlertView *progressAlert;
}

- (void) showAlert:(NSString *)title message:(NSString *)message;
- (void) hideAlert;

@end
