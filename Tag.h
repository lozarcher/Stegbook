//
//  Tag.h
//  Stegbook
//
//  Created by Loz Archer on 14/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Tag : NSObject {
	NSString *name;
	NSString *x;
	NSString *y;
}

- (id) pointToTag:(CGPoint)pt image:(UIImage *)img;

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *x;
@property (nonatomic, retain) NSString *y;

@end
