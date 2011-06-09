//
//  Album.h
//  Stegbook
//
//  Created by Loz Archer on 14/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Album : NSObject {
	NSString *name;
	NSString *albumId;
	NSMutableArray *photos;
	NSInteger photoCount;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *albumId;
@property (nonatomic, retain) NSMutableArray *photos;
@property (nonatomic) NSInteger photoCount;

@end
