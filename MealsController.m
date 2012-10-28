//
//  MealsController.m
//  Nutrition
//
//  Created by Hans Andersson on 11/01/09.
//  Copyright 2011 Vigorware. All rights reserved.
//

#import "MealsController.h"
#import "Nutrition_AppDelegate.h"

@implementation MealsController

- (NSManagedObject *)mealtimeForName:(NSString *)mealtimeName
{
	NSManagedObjectContext *managedObjectContext = [(Nutrition_AppDelegate *)[NSApp delegate] managedObjectContext];
	[[managedObjectContext undoManager] disableUndoRegistration];
	NSManagedObject *mealtime = [(Nutrition_AppDelegate *)[NSApp delegate] uniqueManagedObjectWithEntityName:@"Time" keysValuesDictionary:[NSDictionary dictionaryWithObjectsAndKeys:mealtimeName,@"name",nil]];
	[[managedObjectContext undoManager] enableUndoRegistration];
	return mealtime;
}

- (NSManagedObject *)mealForDate:(NSDate *)date mealtime:(NSManagedObject *)mealtime
{
	NSManagedObject *profile = [(Nutrition_AppDelegate *)[NSApp delegate] activeProfile];
	if (!profile) return nil;
	
	NSManagedObjectContext *managedObjectContext = [profile managedObjectContext];
	[[managedObjectContext undoManager] disableUndoRegistration];
	NSManagedObject *meal = [(Nutrition_AppDelegate *)[NSApp delegate] uniqueManagedObjectWithEntityName:@"Meal" keysValuesDictionary:[NSDictionary dictionaryWithObjectsAndKeys:date,@"date",mealtime,@"time",profile,@"profile",nil]];
	[[managedObjectContext undoManager] enableUndoRegistration];
	
	return meal;
}

@end
