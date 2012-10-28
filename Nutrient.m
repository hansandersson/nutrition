//
//  Nutrient.m
//  Nutrition
//
//  Created by Hans Andersson on 11/01/10.
//  Copyright 2011 Vigorware. All rights reserved.
//

#import "Nutrient.h"


@implementation Nutrient

- (id) valueForKey:(NSString *)key
{
	if ([key isEqualToString:@"name"])
	{
		if ([self primitiveValueForKey:@"commonName"] && ![[self primitiveValueForKey:@"commonName"] isEqualToString:@""]) return [self valueForKey:@"commonName"];
		return [self valueForKey:@"scientificName"];
	}
	return [super valueForKey:key];
}

- (void) addSubnutrient:(Nutrient *)subnutrient contributionQuantity:(NSDecimalNumber *)contributionQuantity
{
	NSManagedObjectContext *managedObjectContext = [subnutrient managedObjectContext];
	[[[self managedObjectContext] undoManager] beginUndoGrouping];
	NSManagedObject *composition = [[NSManagedObject alloc] initWithEntity:[NSEntityDescription entityForName:@"Composition" inManagedObjectContext:managedObjectContext] insertIntoManagedObjectContext:managedObjectContext];
	[composition setValue:self forKey:@"supernutrient"];
	[composition setValue:subnutrient forKey:@"subnutrient"];
	[composition setValue:contributionQuantity forKey:@"quantity"];
	[[[self managedObjectContext] undoManager] endUndoGrouping];
}

@end
