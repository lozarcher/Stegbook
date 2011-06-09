//
//  AsyncImageView.h
//  Stegbook
//
//  Created by Loz Archer on 01/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AsyncImageView : UIView {
    NSURLConnection* connection;
    NSMutableData* data;
}

- (void)loadImageFromURL:(NSURL*)url;


@end

