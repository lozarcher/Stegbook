//
//  PickImageViewController.h
//  Stegbook
//
//  Created by Loz Archer on 20/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"

@interface PickImageViewController : UIViewController 
<UIImagePickerControllerDelegate, UINavigationControllerDelegate, FBRequestDelegate, FBSessionDelegate>
{
}

-(IBAction) takePhoto:(id)sender;
-(IBAction) chooseFromLibrary:(id)sender;

@end
