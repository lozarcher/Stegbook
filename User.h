//
//  User.h
//  Stegbook
//
//  Created by Loz Archer on 15/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <foundation/Foundation.h>

@interface User : NSObject {
    NSString *username;
	NSString *userid;
}

@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *userId;


@end
