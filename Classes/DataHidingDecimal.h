//
//  DataHidingFraction.h
//  Stegbook
//
//  Created by Loz Archer on 29/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataHidingDecimal : NSObject {

}

+(NSString *)hideDataInCoordinate:(NSString *)coord data:(int)data;
+(int)decodeDataFromCoordinate:(NSString *)coord;

@end
