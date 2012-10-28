//
//  HelpingsController.m
//  Nutrition
//
//  Created by Hans Andersson on 11/01/09.
//  Copyright 2011 Vigorware. All rights reserved.
//

#import "HelpingsController.h"


@implementation HelpingsController

- (NSManagedObject *)newHelpingForEdible:(NSManagedObject *)edible quantifier:(NSManagedObject *)quantifier quantity:(NSDecimalNumber *)quantity
{
	NSManagedObjectContext *managedObjectContext = [edible managedObjectContext];
	NSAssert(managedObjectContext==[quantifier managedObjectContext], @"Internal inconsistency: edible and quantifier belong to distinct instances of NSManagedObjectContext");
	
	NSEntityDescription *helpingEntityDescription =  [NSEntityDescription entityForName:@"Helping" inManagedObjectContext:managedObjectContext];
	NSManagedObject *newHelping = [[NSManagedObject alloc] initWithEntity:helpingEntityDescription insertIntoManagedObjectContext:managedObjectContext];
	[newHelping setValue:quantity forKey:@"quantity"];
	[newHelping setValue:quantifier forKey:@"quantifier"];
	[newHelping setValue:edible forKey:@"edible"];
	
	return newHelping;
}

@end
