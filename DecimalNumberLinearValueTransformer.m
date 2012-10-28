//
//  DecimalNumberLinearValueTransformer.m
//  Nutrition
//
//  Created by Hans Andersson on 11/01/14.
//  Copyright 2011 Vigorware. All rights reserved.
//

#import "DecimalNumberLinearValueTransformer.h"


@implementation DecimalNumberLinearValueTransformer

+ (BOOL) allowsReverseTransformation { return YES; }
+ (Class) transformedValueClass { return [NSDecimalNumber class]; }

+ (NSDecimalNumber *) transformationCoefficient { return [NSDecimalNumber one]; }
+ (NSDecimalNumber *) transformationConstant { return [NSDecimalNumber zero]; }

- (id) transformedValue:(id)value
{
	return [
			[
			 value
			 decimalNumberByMultiplyingBy:
			 [[self class] transformationCoefficient]
			 ]
			decimalNumberByAdding:
			[[self class] transformationConstant]
			];
}
- (id) reverseTransformedValue:(id)value
{
	return [
			[
			 value
			 decimalNumberBySubtracting:
			 [[self class] transformationConstant]
			 ]
			decimalNumberByDividingBy:
			[[self class] transformationCoefficient]
			]; 
}

@end
