//
//  Photo.m
//  Stegbook
//
//  Created by Loz Archer on 14/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Photo.h"
#import "Tag.h"
#import "DataHidingDecimal.h"
#import "DataHidingBinary.h"
#import "StegbookAppDelegate.h"

@implementation Photo

@synthesize name, imageUrl, thumbnailUrl, tags, pid, objectId, uploadedBy, timestamp;

- (id)init { 
    if ((self = [super init])) {
        tags = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
	for (Tag *thisTag in tags) {
		[thisTag release];
	}
    [tags release];
    [super dealloc];
}

-(NSString *)decodeDataFromTags {
	
	NSString *decodedData = [[NSString alloc] init];
	
	for (Tag *thisTag in tags) {
		
		int xChar, yChar;
		if (UIAppDelegate.binaryHiding) {
			NSLog(@"Decoding data using binary method");
			NSLog(@"Decoding x coordinate %@",thisTag.x);
			xChar = [DataHidingBinary decodeDataFromCoordinate:thisTag.x];
			NSLog(@"Decoding y coordinate %@",thisTag.y);
			yChar = [DataHidingBinary decodeDataFromCoordinate:thisTag.y];
		} else {
			NSLog(@"Decoding data using decimal method");
			NSLog(@"Decoding x coordinate %@",thisTag.x);
			xChar = [DataHidingDecimal decodeDataFromCoordinate:thisTag.x];
			NSLog(@"Decoding y coordinate %@",thisTag.y);
			yChar = [DataHidingDecimal decodeDataFromCoordinate:thisTag.y];		
		}
		decodedData = [decodedData stringByAppendingFormat:@"%c%c",xChar,yChar];
	}
	NSLog(@"Decoded data: %@", decodedData);
	return decodedData;
}

-(void)encodeDataInTags:(NSString *)hiddenData {
	NSLog(@"Going to check %d characters...",[hiddenData length]);
	Tag *currentTag = [[Tag alloc] init];
			
	for (int i=0; i<[hiddenData length]; i++) {
		NSLog(@"Checking character %d of %d",i,[hiddenData length]);
		char hideChar = [hiddenData characterAtIndex:i];
		NSLog(@"Encoding %c",hideChar);
		int tagIndex = (int) i / 2;
		NSLog(@"Tag index %d of %d",tagIndex,[tags count]);

		currentTag = [tags objectAtIndex:tagIndex];
		NSLog(@"Got tag");
	
		NSLog(@"Encoding character %c as integer %d",hideChar,(int)hideChar);
		
		if (UIAppDelegate.binaryHiding) {
			NSLog(@"Encoding data using binary method");
			if (i % 2 == 0) {
				currentTag.x = [DataHidingBinary hideDataInCoordinate:currentTag.x data:(int)hideChar];
			} else {
				currentTag.y = [DataHidingBinary hideDataInCoordinate:currentTag.y data:(int)hideChar];
			}
		} else {
			NSLog(@"Encoding data using decimal method");
			if (i % 2 == 0) {
				currentTag.x = [DataHidingDecimal hideDataInCoordinate:currentTag.x data:(int)hideChar];
			} else {
				currentTag.y = [DataHidingDecimal hideDataInCoordinate:currentTag.y data:(int)hideChar];
			}
		}
	}
	[currentTag release];

	NSLog(@"Finishing");
}

@end
