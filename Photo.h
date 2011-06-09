//
//  Photo.h
//  Stegbook
//
//  Created by Loz Archer on 14/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Photo : NSObject {
	NSString *name;
	NSURL *thumbnailUrl;
	NSURL *imageUrl;
	NSString *uploadedBy;
	NSString *timestamp;
	NSString *objectId;
	NSString *pid;
	NSMutableArray *tags;
}

-(NSString *)decodeDataFromTags;
-(void)encodeDataInTags:(NSString *)hiddenData;
void fp2bin(double fp, char* binString);

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSURL *thumbnailUrl;
@property (nonatomic, retain) NSURL *imageUrl;
@property (nonatomic, retain) NSString *objectId;
@property (nonatomic, retain) NSString *pid;
@property (nonatomic, retain) NSString *uploadedBy;
@property (nonatomic, retain) NSString *timestamp;
@property (nonatomic, retain) NSMutableArray *tags;

@end	
