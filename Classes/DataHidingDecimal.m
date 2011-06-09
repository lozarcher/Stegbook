//
//  DataHidingFraction.m
//  Stegbook
//
//  Created by Loz Archer on 29/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DataHidingDecimal.h"

@implementation DataHidingDecimal

+(NSString *)hideDataInCoordinate:(NSString *)coord data:(int)data {
	coord = [NSString stringWithFormat:@"%@.%d",coord,data];
	coord = [coord stringByAppendingFormat:@"%d", arc4random() % 8 + 1];
	return coord;
}


+(int)decodeDataFromCoordinate:(NSString *)coord {
	char space = ' ';
	NSLog(@"Got coordinate %@", coord);
	NSArray *splitTag = [[NSArray alloc] initWithArray:[[NSString stringWithFormat:@"%@",coord] componentsSeparatedByString:@"."]];
	int data = (int)space;
	if ([splitTag count] > 1) {
		NSString *fraction = [splitTag objectAtIndex:1];
		NSLog(@"Got fraction %@", fraction);
		fraction = [fraction stringByReplacingCharactersInRange:NSMakeRange([fraction length]-1, 1) withString:@""];
		NSLog(@"Stripped last digit %@", fraction);
		data = [fraction intValue];
		NSLog(@"Returning int value %d", data);
	}
	return data;
}

@end
