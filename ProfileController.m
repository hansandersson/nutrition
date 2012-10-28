//
//  ProfileController.m
//  Nutrition
//
//  Created by Hans Andersson on 11/01/11.
//  Copyright 2011 Vigorware. All rights reserved.
//

#import "ProfileController.h"
#import "Nutrition_AppDelegate.h"
#import "Profile.h"
#import "Nutrient.h"

@implementation ProfileController

- (void) controlTextDidEndEditing:(NSNotification *)notification
{
	NSControl *control = [notification object];
	NSString *profileName = [control stringValue];
	
	if ([profileName isEqualToString:@""])
	{
		[profilesArrayController setSelectedObjects:[NSArray array]];
		return (void)[[[control window] toolbar] validateVisibleItems];
	}
	
	NSManagedObjectContext *managedObjectContext = [(Nutrition_AppDelegate *)[NSApp delegate] managedObjectContext];
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	
	NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Profile" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entityDescription];
	[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"name == %@",profileName]];
	
	NSArray *existingProfiles = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
	if ([existingProfiles count]==1)
	{
		[profilesArrayController setSelectedObjects:existingProfiles];
		return (void)[[[control window] toolbar] validateVisibleItems];
	}
	
	NSAlert *newProfileAlert = [NSAlert alertWithMessageText:[NSString stringWithFormat:@"Are you sure you want to create a new profile named “%@”?",[control stringValue]] defaultButton:@"Create New Profile" alternateButton:@"Cancel" otherButton:nil informativeTextWithFormat:@"Creating a new profile will erase no existing profiles or data, but the new profile will start with generic default settings."];
	
	[newProfileAlert beginSheetModalForWindow:[(Nutrition_AppDelegate *)[NSApp delegate] window] modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:control];
}

- (void) alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(id)contextInfo
{
	if (returnCode==NSAlertDefaultReturn)
	{
		NSManagedObjectContext *managedObjectContext = [(Nutrition_AppDelegate *)[NSApp delegate] managedObjectContext];
		
		[[managedObjectContext undoManager] beginUndoGrouping];
		Profile *newProfile = (Profile *)[(Nutrition_AppDelegate *)[NSApp delegate] uniqueManagedObjectWithEntityName:@"Profile" keysValuesDictionary:[NSDictionary dictionaryWithObjectsAndKeys:[contextInfo stringValue],@"name",nil]];
		
		/*NSArray *defaultReferences = [NSArray arrayWithObjects:@"nutrition.gov",@"mypyramid.gov",@"eatright.org",@"cdc.gov/nutrition",@"nlm.nih.gov/medlineplus/nutrition.html",@"webmd.com/diet/default.htm",@"nutrition.about.com",@"nutrition.org",@"nutritiondata.self.com",nil];
		for (NSString *nextReferenceURLString in defaultReferences) [(Nutrition_AppDelegate *)[NSApp delegate] uniqueManagedObjectWithEntityName:@"Reference" keysValuesDictionary:[NSDictionary dictionaryWithObjectsAndKeys:newProfile,@"profile",nextReferenceURLString,@"urlString",nil]];*/
		
		NSArray *defaultNutrients = [NSArray arrayWithObjects:
									 [(Nutrition_AppDelegate *)[NSApp delegate] uniqueManagedObjectWithEntityName:@"Nutrient" keysValuesDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"Energy",@"scientificName",@"kcal",@"unit",@"Calories",@"commonName",nil]],
									 [(Nutrition_AppDelegate *)[NSApp delegate] uniqueManagedObjectWithEntityName:@"Nutrient" keysValuesDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"Total lipid (fat)",@"scientificName",@"g",@"unit",@"Fat",@"commonName",nil]],
									 [(Nutrition_AppDelegate *)[NSApp delegate] uniqueManagedObjectWithEntityName:@"Nutrient" keysValuesDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"Protein",@"scientificName",@"g",@"unit",@"Protein",@"commonName",nil]],
									 [(Nutrition_AppDelegate *)[NSApp delegate] uniqueManagedObjectWithEntityName:@"Nutrient" keysValuesDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"Carbohydrate, by difference",@"scientificName",@"g",@"unit",@"Carbohydrate",@"commonName",nil]],
									 [(Nutrition_AppDelegate *)[NSApp delegate] uniqueManagedObjectWithEntityName:@"Nutrient" keysValuesDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"Fatty acids, total trans",@"scientificName",@"g",@"unit",@"Trans Fat",@"commonName",nil]],
									 [(Nutrition_AppDelegate *)[NSApp delegate] uniqueManagedObjectWithEntityName:@"Nutrient" keysValuesDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"Fatty acids, total saturated",@"scientificName",@"g",@"unit",@"Saturated Fat",@"commonName",nil]],
									 [(Nutrition_AppDelegate *)[NSApp delegate] uniqueManagedObjectWithEntityName:@"Nutrient" keysValuesDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"Fatty acids, total monounsaturated",@"scientificName",@"g",@"unit",@"Monounsaturated Fat",@"commonName",nil]],
									 [(Nutrition_AppDelegate *)[NSApp delegate] uniqueManagedObjectWithEntityName:@"Nutrient" keysValuesDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"Fatty acids, total polyunsaturated",@"scientificName",@"g",@"unit",@"Polyunsaturated Fat",@"commonName",nil]],
									 [(Nutrition_AppDelegate *)[NSApp delegate] uniqueManagedObjectWithEntityName:@"Nutrient" keysValuesDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"Starch",@"scientificName",@"g",@"unit",@"Starch",@"commonName",nil]],
									 [(Nutrition_AppDelegate *)[NSApp delegate] uniqueManagedObjectWithEntityName:@"Nutrient" keysValuesDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"Sugars, total",@"scientificName",@"g",@"unit",@"Sugar",@"commonName",nil]],
									 nil];
		
		[[newProfile mutableSetValueForKey:@"nutrients"] addObjectsFromArray:defaultNutrients];
		[[managedObjectContext undoManager] endUndoGrouping];
		
		[profilesArrayController setSelectedObjects:[NSArray arrayWithObject:newProfile]];
		[[[contextInfo window] toolbar] validateVisibleItems];
	}
	else
	{
		[contextInfo setStringValue:@""];
		[profilesArrayController setSelectedObjects:[NSArray array]];
		[[[contextInfo window] toolbar] validateVisibleItems];
	}

}

@end
