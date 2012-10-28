//
//  Meal.m
//  Nutrition
//
//  Created by Hans Andersson on 11/01/10.
//  Copyright 2011 Vigorware. All rights reserved.
//

#import "Meal.h"
#import "Portion.h"

@implementation Meal

- (NSDecimalNumber *)allotmentOfNutrient:(NSManagedObject *)nutrient
{
	NSArray *helpings = [self valueForKey:@"helpings"];
	NSDecimalNumber *totalAllotment = [NSDecimalNumber zero];
	for (Portion *nextHelping in helpings) [totalAllotment decimalNumberByAdding:[nextHelping allotmentOfNutrient:nutrient]];
	return totalAllotment;
}

@end
