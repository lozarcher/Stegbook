//
//  StegbookAppDelegate.m
//  Stegbook
//
//  Created by Loz Archer on 10/11/2010.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "StegbookAppDelegate.h"
#import "FBConnect.h"

@implementation StegbookAppDelegate

@synthesize window, splashView;
@synthesize tabBarController;
@synthesize facebook;
@synthesize binaryHiding, decimalHiding;



#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
	facebook = [[Facebook alloc] init];

    // Add the tab bar controller's view to the window and display.
    [window addSubview:tabBarController.view];
    [window makeKeyAndVisible];

	// keep splashview for a bit
	splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	splashView.image = [UIImage imageNamed:@"Default.png"];

	[window addSubview:splashView];
	[self performSelector:@selector(removeSplash) withObject:nil afterDelay:1];

    return YES;
}

-(void)removeSplash;
{
	[splashView removeFromSuperview];
	[splashView release];
}

- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
	NSLog(@"Touched");
	[splashView setHidden:TRUE];
}

- (void)applicationWillResignActive:(UIApplication *)application {
	NSLog(@"Resigning active");
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
	NSLog(@"Application entered background");

    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
	NSLog(@"Application will enter background");

    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
	NSLog(@"Application became active");
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
	NSLog(@"Application terminating");

    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}

- (void) enableEncodeAndDecode:(BOOL)enable {
	UIViewController *viewController = (UIViewController *) [[tabBarController viewControllers] objectAtIndex:1];
	[viewController.tabBarItem setEnabled:enable];
	viewController = (UIViewController *) [[tabBarController viewControllers] objectAtIndex:2];
	[viewController.tabBarItem setEnabled:enable];
}

#pragma mark -
#pragma mark UITabBarControllerDelegate methods

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	NSLog(@"Application has received a memory warning");

    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	NSLog(@"Application dealloc");
    [tabBarController release];
    [window release];
	[facebook release];
    [super dealloc];
}

@end

