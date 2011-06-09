//
//  UploadImageViewController.h
//  Stegbook
//
//  Created by Loz Archer on 21/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"
#import "ProgressIndicator.h"

@interface UploadImageViewController : UIViewController
<UIPickerViewDelegate, UIPickerViewDataSource, FBRequestDelegate, FBSessionDelegate>
{
	IBOutlet UIPickerView *albumPicker;
	NSMutableDictionary *albumIds;
	NSMutableArray *albumNames;
	UIImage *image;
	ProgressIndicator* progressIndicator;
}

@property (nonatomic, retain) UIPickerView *albumPicker;
@property (nonatomic, retain) NSMutableDictionary *albumIds;
@property (nonatomic, retain) NSMutableArray *albumNames;
@property (nonatomic, retain) UIImage *image;

@end
