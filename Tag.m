//
//  Tag.m
//  Stegbook
//
//  Created by Loz Archer on 14/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Tag.h"


@implementation Tag

@synthesize name, x, y;

- (id) pointToTag:(CGPoint)pt image:(UIImage *)img {
    if ((self = [super init])) {
		NSLog(@"Point to Tag");
		NSLog(@"pt.x: %f",pt.x);
		NSLog(@"pt.y: %f",pt.y);
		NSLog(@"image.size.width: %f",img.size.width);
		NSLog(@"image.size.height: %f",img.size.height);
			
		NSString *storingX = [NSString stringWithFormat:@"%d", lroundf(pt.x / img.size.width * 100)];
		NSString *storingY = [NSString stringWithFormat:@"%d", lroundf(pt.y / img.size.height * 100)];
		
		NSLog(@"storingX: %@",storingX);
		NSLog(@"storingY: %@",storingY);
		
		if ((pt.x > img.size.width) || (pt.y > img.size.height)) {
			return nil;
		}
			
		self.name = @"None";
		self.x = storingX;
		self.y = storingY;
	}

    return self;
}

@end
