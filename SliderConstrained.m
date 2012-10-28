//
//  SliderConstrained.m
//  Nutrition
//
//  Created by Hans Andersson on 11/01/12.
//  Copyright 2011 Vigorware. All rights reserved.
//

#import "SliderConstrained.h"


@implementation SliderConstrained

@synthesize constrainedMaxValue;

- (void) setConstrainedMaxValue:(double)newConstrainedMaxValue
{
	if (newConstrainedMaxValue<[self constrainedMinValue]) [self setConstrainedMinValue:newConstrainedMaxValue];
	constrainedMaxValue = newConstrainedMaxValue;
	if ([self doubleValue]>constrainedMaxValue) [self setDoubleValue:constrainedMaxValue];
}

@synthesize constrainedMinValue;

- (void) setConstrainedMinValue:(double)newConstrainedMinValue
{
	if (newConstrainedMinValue>[self constrainedMaxValue]) [self setConstrainedMaxValue:newConstrainedMinValue];
	constrainedMinValue = newConstrainedMinValue;
	if ([self doubleValue]<constrainedMinValue) [self setDoubleValue:constrainedMinValue];
}

- (void) setDoubleValue:(double)aDouble
{
	if (aDouble>constrainedMaxValue) aDouble = constrainedMaxValue;
	if (aDouble<constrainedMinValue) aDouble = constrainedMinValue;
	[super setDoubleValue:aDouble];
}

- (void) setFloatValue:(float)aFloat
{
	if (aFloat>(float)constrainedMaxValue) aFloat = (float)constrainedMaxValue;
	if (aFloat<(float)constrainedMinValue) aFloat = (float)constrainedMinValue;
	[super setFloatValue:aFloat];
}

- (void) setIntValue:(int)anInt
{
	if (anInt>floor(constrainedMaxValue)) anInt = floor(constrainedMaxValue);
	if (anInt<ceil(constrainedMinValue)) anInt = ceil(constrainedMinValue);
	[super setIntValue:anInt];
}

@end
