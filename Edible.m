//
//  Edible.m
//  Nutrition
//
//  Created by Hans Andersson on 11/01/10.
//  Copyright 2011 Vigorware. All rights reserved.
//

#import "Edible.h"
#import "Portion.h"

@implementation Edible

- (NSDecimalNumber *) normalizedAllotmentOfNutrient:(NSManagedObject *)nutrient
{
	if ([[[self entity] name] isEqualToString:@"Food"])
	{
		NSArray *allotments = [[self mutableSetValueForKey:@"allotments"] allObjects];
		for (NSManagedObject *nextAllotment in allotments) if ([nextAllotment valueForKey:@"nutrient"]==nutrient) return [nextAllotment valueForKey:@"quntity"];
		return [NSDecimalNumber zero];
	}
	else
	{
		NSDecimalNumber *totalAllotment = [NSDecimalNumber zero];
		NSDecimalNumber *totalMass = [NSDecimalNumber zero];
		NSArray *ingredients = [[self mutableSetValueForKey:@"ingredients"] allObjects];
		for (Portion *nextIngredient in ingredients)
		{
			totalAllotment = [totalAllotment decimalNumberByAdding:[nextIngredient allotmentOfNutrient:nutrient]];
			totalMass = [totalMass decimalNumberByAdding:[nextIngredient grams]];
		}
		return [totalAllotment decimalNumberByDividingBy:totalMass];
	}
}

- (NSDecimalNumber *) allotmentOfNutrient:(NSManagedObject *)nutrient grams:(NSDecimalNumber *)grams
{
	return [[self normalizedAllotmentOfNutrient:nutrient] decimalNumberByMultiplyingBy:grams];
}

- (NSDecimalNumber *) allotmentOfNutrient:(NSManagedObject *)nutrient quantifier:(NSManagedObject *)quantifier
{
	return [self allotmentOfNutrient:nutrient quantifier:quantifier quantity:[NSDecimalNumber one]];
}

- (NSDecimalNumber *) allotmentOfNutrient:(NSManagedObject *)nutrient quantifier:(NSManagedObject *)quantifier quantity:(NSDecimalNumber *)quantity
{
	NSDecimalNumber *normalizedAllotment = [self normalizedAllotmentOfNutrient:nutrient];
	NSDecimalNumber *grams = [quantifier valueForKey:@"grams"];
	return [[normalizedAllotment decimalNumberByMultiplyingBy:grams] decimalNumberByMultiplyingBy:quantity];
}

@end
