//
//  Album.m
//  Stegbook
//
//  Created by Loz Archer on 14/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Album.h"
#import "Photo.h"

@implementation Album

@synthesize name, albumId, photoCount, photos;

- (id)init { 
    if ((self = [super init])) {
        photos = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
	for (Photo *thisPhoto in photos) {
		[thisPhoto release];
	}
    [photos release];
    [super dealloc];
}

@end
