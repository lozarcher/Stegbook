//
//  User.m
//  Stegbook
//
//  Created by Loz Archer on 15/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LoggedInUser.h"

static LoggedInUser *sharedUser = nil;

@implementation LoggedInUser

@synthesize username, userId;

#pragma mark Singleton Methods
+ (id)sharedUser {
	@synchronized(self) {
		if(sharedUser == nil)
			sharedUser = [[super allocWithZone:NULL] init];
	}
	return sharedUser;
}
+ (id)allocWithZone:(NSZone *)zone {
	return [[self sharedUser] retain];
}
- (id)copyWithZone:(NSZone *)zone {
	return self;
}
- (id)retain {
	return self;
}
- (unsigned)retainCount {
	return UINT_MAX; //denotes an object that cannot be released
}
- (void)release {
	// never release
}
- (id)autorelease {
	return self;
}
- (id)init {
	if (self = [super init]) {
		username = nil;
		userId = nil;
	}
	return self;
}
- (void)dealloc {
	// Should never be called, but just here for clarity really.
	[username release];
	[super dealloc];
}

@end