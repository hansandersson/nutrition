//
//  Portion.m
//  Nutrition
//
//  Created by Hans Andersson on 11/01/10.
//  Copyright 2011 Vigorware. All rights reserved.
//

#import "Portion.h"
#import "Edible.h"

@implementation Portion

- (NSDecimalNumber *)allotmentOfNutrient:(NSManagedObject *)nutrient
{
	return [[self valueForKey:@"edible"] allotmentOfNutrient:nutrient quantifier:[self valueForKey:@"quantifier"] quantity:[self valueForKey:@"quantity"]];
}

- (NSDecimalNumber *)grams
{
	return [self valueForKeyPath:@"quantifier.grams"];
}

@end
