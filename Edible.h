//
//  Edible.h
//  Nutrition
//
//  Created by Hans Andersson on 11/01/10.
//  Copyright 2011 Vigorware. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Edible : NSManagedObject {}

- (NSDecimalNumber *) normalizedAllotmentOfNutrient:(NSManagedObject *)nutrient;
- (NSDecimalNumber *) allotmentOfNutrient:(NSManagedObject *)nutrient grams:(NSDecimalNumber *)grams;
- (NSDecimalNumber *) allotmentOfNutrient:(NSManagedObject *)nutrient quantifier:(NSManagedObject *)quantifier;
- (NSDecimalNumber *) allotmentOfNutrient:(NSManagedObject *)nutrient quantifier:(NSManagedObject *)quantifier quantity:(NSDecimalNumber *)quantity;

@end
