//
//  DataHidingFloatingPoint.m
//  Stegbook
//
//  Created by Loz Archer on 29/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DataHidingBinary.h"

@implementation DataHidingBinary

static int binaryStringLength = 11;
static int FP2BIN_STRING_MAX = 1077;

void fp2bin_i(double fp_int, char* binString)
{
	int bitCount = 0;
	int i;
	char binString_temp[FP2BIN_STRING_MAX];
	
	do
	{
		binString_temp[bitCount++] = '0' + (int)fmod(fp_int,2);
		fp_int = floor(fp_int/2);
	} while (fp_int > 0);
	
	/* Reverse the binary string */
	for (i=0; i<bitCount; i++)
		binString[i] = binString_temp[bitCount-i-1];
	
	binString[bitCount] = 0; //Null terminator
}

void fp2bin_f(double fp_frac, char* binString)
{
	int bitCount = 0;
	double fp_int;
	
	while (fp_frac > 0)
	{
		fp_frac*=2;
		fp_frac = modf(fp_frac,&fp_int);
		binString[bitCount++] = '0' + (int)fp_int;
	}
	binString[bitCount] = 0; //Null terminator
}

void fp2bin(double fp, char* binString)
{
	double fp_int, fp_frac;
	/* Separate integer and fractional parts */
	fp_frac = modf(fp,&fp_int);
	
	/* Convert integer part, if any */
	if (fp_int != 0)
		fp2bin_i(fp_int,binString);
	else
		strcpy(binString,"0");
	
	strcat(binString,"."); // Radix point
	
	/* Convert fractional part, if any */
	if (fp_frac != 0)
		fp2bin_f(fp_frac,binString+strlen(binString)); //Append
	else
		strcpy(binString+strlen(binString),"0");
}

+(NSString *)hideDataInCoordinate:(NSString *)coord data:(int)data {

	 int exponent;
	 char binString[FP2BIN_STRING_MAX];
	 double fraction = 0;
	 NSLog(@"Old coordinate %@",coord);
	 fraction = frexp ( [coord floatValue], &exponent );
	 NSLog(@"= %f * %d", fraction, exponent);
	 fp2bin(fraction,binString);

	
	NSString *binNsstring = [NSString stringWithFormat:@"%s",binString];

	NSLog(@"Before truncating or packing: %@ = %@ * 2^ %d", coord, binNsstring, exponent);

	if ([binNsstring length] > binaryStringLength) {
		NSLog(@"Truncating / rounding...");
		// Round up if next bit is a 1
		char nextBit = [binNsstring characterAtIndex:binaryStringLength+1];
		if (nextBit == '1') {
			binNsstring = [binNsstring stringByReplacingCharactersInRange:NSMakeRange(binaryStringLength, 1) withString:@"1"];
		}
		
		// Truncate the rest
		binNsstring = [binNsstring stringByReplacingCharactersInRange:NSMakeRange(binaryStringLength, [binNsstring length]-binaryStringLength) withString:@""];
	} else {
		NSLog(@"Packing...");
		// pack string to length of mantissa
		while ([binNsstring length] <= binaryStringLength) {
			binNsstring = [binNsstring stringByAppendingFormat:@"0"];
		}
		NSLog(@"Before data hiding: %@ = %@ * 2^ %d", coord, binNsstring, exponent);
	}
	 fp2bin(data,binString);	
	 NSString *hiddenDataBinary = [NSString stringWithFormat:@"%s",binString];
	 hiddenDataBinary = [hiddenDataBinary stringByReplacingOccurrencesOfString:@".0" withString:@""];
	 while ([hiddenDataBinary length] < 8) {
		 hiddenDataBinary = [NSString stringWithFormat:@"0%@", hiddenDataBinary];
	 }
	 
	 
	 //replace least significant byte with data
	 NSString *packedString = [binNsstring stringByReplacingCharactersInRange:NSMakeRange([binNsstring length]-8,8)
																   withString:hiddenDataBinary];
	 
	 float newValue = 0;
	 
	 NSLog(@"Packed mantissa: %@", packedString);
	 
	 float multiplier = 0;
	 for (int i=0; i<[packedString length]; i++) {
		 char currentCharacter = [packedString characterAtIndex:i];
		 if (currentCharacter == '.') {
			 multiplier = 1;
		 }
		 if (currentCharacter == '1') {
			newValue = newValue + multiplier;
		 }
		 multiplier = multiplier / 2;
	 }
	newValue = newValue * pow(2,exponent);
	NSLog(@"Coord before rounding %f",newValue);
	coord = [NSString stringWithFormat:@"%0.5g", newValue];
	NSLog(@"Coord after rounding %@",coord);
	return coord;
}

+(int)decodeDataFromCoordinate:(NSString *)coord {
	int exponent;
	char binString[FP2BIN_STRING_MAX];
	float fCoord = [coord floatValue];
	NSLog(@"decoding coordinate %f",fCoord);
	double fraction = frexp ( fCoord, &exponent );
	NSLog(@"%f = %f * %d", fCoord, fraction, exponent);
	fp2bin(fraction,binString);
	
	NSString *binNsstring = [NSString stringWithFormat:@"%s",binString];
	// pack string to length of mantissa
	NSLog(@"Before truncating or packing: %@ = %@ * 2^ %d", coord, binNsstring, exponent);
	
	int roundUp = 0;
	
	if ([binNsstring length] > binaryStringLength+1) {
		NSLog(@"Truncating...");
		// Round up if next bit is a 1
		char nextBit = [binNsstring characterAtIndex:binaryStringLength+1];
		NSLog(@"Next bit = %c", nextBit);
		if (nextBit == '1') {
			roundUp = 1;
			NSLog(@"Next bit is 1, so rounding up");
			//binNsstring = [binNsstring stringByReplacingCharactersInRange:NSMakeRange(binaryStringLength, 1) withString:@"1"];
		}
		
		NSLog(@"Truncating the rest...");
		// Truncate the rest
		binNsstring = [binNsstring stringByReplacingCharactersInRange:NSMakeRange(binaryStringLength+1, [binNsstring length]-binaryStringLength-1) withString:@""];
	} else {
		NSLog(@"Packing...");
		// pack string to length of mantissa
		while ([binNsstring length] <= binaryStringLength) {
			binNsstring = [binNsstring stringByAppendingFormat:@"0"];
		}
		NSLog(@"Converted to proper length: %@ = %@ * 2^ %d", coord, binNsstring, exponent);
	}
	
	NSLog(@"Binary: %@", binNsstring);
	NSString *hiddenBinary = binNsstring;
	
	hiddenBinary = [hiddenBinary substringWithRange:NSMakeRange([binNsstring length]-8, 8)];
	
	NSLog (@"Hidden binary: %@", hiddenBinary);
	int multiplier = 1;
	int hiddenValue = 0;
	for (int i=7; i>=0; i--) {
		if ([hiddenBinary characterAtIndex:i] == '1') {
			hiddenValue = hiddenValue + multiplier;
		}
		multiplier = multiplier * 2;
	}

	NSLog(@"Got value: %d", hiddenValue);
	if (roundUp) {
		hiddenValue = hiddenValue + roundUp;
		NSLog(@"Rounded up: %d", hiddenValue);
	}
	//NSString *decodedChar = [[NSString alloc] initWithFormat:"%c",(char)hiddenValue];
	NSLog(@"Got hidden char: %c", hiddenValue);
	
	return hiddenValue;
}

@end
