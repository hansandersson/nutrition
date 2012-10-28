//
//  MealSheetController.m
//  Nutrition
//
//  Created by Hans Andersson on 11/01/09.
//  Copyright 2011 Vigorware. All rights reserved.
//

#import "MealSheetController.h"
#import "Nutrition_AppDelegate.h"
#import "FoodsController.h"
#import "HelpingsController.h"
#import "MealsController.h"

@implementation MealSheetController

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
	return [[[self selectedMeal] mutableSetValueForKey:@"helpings"] count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)rowIndex
{
	NSManagedObject *helping = [[[[self selectedMeal] mutableSetValueForKey:@"helpings"] allObjects] objectAtIndex:rowIndex];
	switch ([[[tableColumn headerCell] stringValue] isEqualToString:@"Food"])
	{
		case YES: return [helping valueForKeyPath:@"edible.name"];
		case NO: return [NSString stringWithFormat:@"%@ %@",[helping valueForKey:@"quantity"],[helping valueForKeyPath:@"quantifier.name"]];
	}
	return nil;
}

- (void) openMealSheet:(id)sender
{
	[datePicker setDateValue:[NSDate dateWithTimeIntervalSince1970:((int)[[NSDate date] timeIntervalSince1970]/(15*60))*(15*60)]];
	[helpingsTableView reloadData];
	[NSApp beginSheet:mealSheet modalForWindow:[(Nutrition_AppDelegate *)[NSApp delegate] window] modalDelegate:nil didEndSelector:nil contextInfo:nil];
}

- (void) controlTextDidEndEditing:(NSNotification *)notification
{
	if ([notification object]==mealNameBox) [helpingsTableView reloadData];
	if ([notification object]==quantityTextField || [notification object]==mealNameBox) return [addButton setEnabled:[quantityTextField doubleValue]>0 && [mealNameBox stringValue]];
}

- (void) controlTextDidChange:(NSNotification *)notification
{
	if ([notification object]==searchTextField) return [self search:[notification object]];
}

- (void) reloadHelpings:(id)sender
{
	[helpingsTableView reloadData];
}

- (NSManagedObject *)selectedMeal
{
	NSManagedObjectContext *managedObjectContext = [(Nutrition_AppDelegate *)[NSApp delegate] managedObjectContext];
	
	NSManagedObject *profile = [(Nutrition_AppDelegate *)[NSApp delegate] activeProfile];
	NSString *mealtimeName = [mealNameBox stringValue];
	
	if (!profile || !mealtimeName || [mealtimeName isEqualToString:@""]) return nil;
	
	[[[profile managedObjectContext] undoManager] disableUndoRegistration];
	NSManagedObject *mealtime = [(Nutrition_AppDelegate *)[NSApp delegate] uniqueManagedObjectWithEntityName:@"Time" keysValuesDictionary:[NSDictionary dictionaryWithObject:mealtimeName forKey:@"name"]];
	[[[profile managedObjectContext] undoManager] enableUndoRegistration];
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	
	NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Meal" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entityDescription];
	[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"profile == %@ AND time == %@ AND date == %@",profile,mealtime,[datePicker dateValue]]];
	NSArray *existingEntities = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
	if ([existingEntities count]==1) return [existingEntities lastObject];
	
	return nil;
}

- (void) tableViewSelectionDidChange:(NSNotification *)notification
{
	NSTableView *tableView = [notification object];
	
	[quantityTextField setStringValue:@""];
	[quantityTextField setEnabled:NO];
	[unitsPopUpButton setEnabled:NO];
	[unitsPopUpButton removeAllItems];
	[unitsPopUpButton display];
	
	if ([[tableView selectedRowIndexes] count]!=1) return [addButton setEnabled:NO];
	
	[detailProgressIndicator startAnimation:[notification object]];
	
	[foodsController setUnitsForFood:[foodsController selectedFood]];
	
	[detailProgressIndicator stopAnimation:self];
	
	[unitsPopUpButton setEnabled:YES];
	[quantityTextField setEnabled:YES];
	[[quantityTextField window] makeFirstResponder:quantityTextField];
}

- (void) search:(id)sender
{
	[foodsController findFoodsForString:[searchTextField stringValue]];
}

- (void) add:(id)sender
{
	[addButton setEnabled:NO];
	
	NSManagedObject *selectedMeal = [mealsController
									 mealForDate:[datePicker dateValue]
									 mealtime:[mealsController
											   mealtimeForName:[mealNameBox stringValue]
											   ]
									 ];
	
	[[helpingsController
				newHelpingForEdible:[foodsController selectedFood]
				quantifier:[[foodUnitsArrayController selectedObjects] lastObject]
				quantity:[NSDecimalNumber decimalNumberWithString:[quantityTextField stringValue]]
				]
	 setValue:selectedMeal
	 forKey:@"meal"
	 ];
	
	[searchTextField setStringValue:@""];
	[self search:sender];
	
	[helpingsTableView reloadData];
}

- (void) closeMealSheet:(id)sender
{
	[mealSheet orderOut:sender];
	[NSApp endSheet:mealSheet];
}

@end
