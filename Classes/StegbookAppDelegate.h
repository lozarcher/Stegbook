//
//  StegbookAppDelegate.h
//  Stegbook
//
//  Created by Loz Archer on 10/11/2010.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "FBConnect.h"
#import "User.h"

#define UIAppDelegate \
((StegbookAppDelegate *)[UIApplication sharedApplication].delegate)

@interface StegbookAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
	Facebook* facebook;
    UITabBarController *tabBarController;
	BOOL binaryHiding;
	BOOL decimalHiding;
	UIImageView* splashView;
}

- (void) enableEncodeAndDecode:(BOOL)enable;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) Facebook* facebook;
@property (nonatomic) BOOL binaryHiding;
@property (nonatomic) BOOL decimalHiding;
@property (nonatomic, retain) UIImageView* splashView;

@end
