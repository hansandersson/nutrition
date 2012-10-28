//
//  Nutrition_AppDelegate.m
//  Nutrition
//
//  Created by Hans Andersson on 11/01/06.
//  Copyright Vigorware 2011 . All rights reserved.
//

#import "Nutrition_AppDelegate.h"
#import "Nutrient.h"

@implementation Nutrition_AppDelegate

@synthesize window;

/**
    Returns the support directory for the application, used to store the Core Data
    store file.  This code uses a directory named "Nutrition" for
    the content, either in the NSApplicationSupportDirectory location or (if the
    former cannot be found), the system's temporary directory.
 */

- (NSString *) applicationSupportDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();
    return [basePath stringByAppendingPathComponent:@"Vigorware"];
}


/**
    Creates, retains, and returns the managed object model for the application 
    by merging all of the models found in the application bundle.
 */
 
- (NSManagedObjectModel *)managedObjectModel
{
    if (managedObjectModel) return managedObjectModel;
	
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


/**
    Returns the persistent store coordinator for the application.  This 
    implementation will create and return a coordinator, having added the 
    store for the application to it.  (The directory for the store is created, 
    if necessary.)
 */

- (NSPersistentStoreCoordinator *) persistentStoreCoordinator
{
    if (persistentStoreCoordinator) return persistentStoreCoordinator;

    NSManagedObjectModel *mom = [self managedObjectModel];
    if (!mom)
	{
        NSAssert(NO, @"Managed object model is nil");
        NSLog(@"%@:%s No model to generate a store from", [self class], _cmd);
        return nil;
    }

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *applicationSupportDirectory = [self applicationSupportDirectory];
    NSError *error = nil;
    
    if ( ![fileManager fileExistsAtPath:applicationSupportDirectory isDirectory:NULL] )
	{
		if (![fileManager createDirectoryAtPath:applicationSupportDirectory withIntermediateDirectories:NO attributes:nil error:&error])
		{
            NSAssert(NO, ([NSString stringWithFormat:@"Failed to create App Support directory %@ : %@", applicationSupportDirectory,error]));
            NSLog(@"Error creating application support directory at %@ : %@",applicationSupportDirectory,error);
            return nil;
		}
    }
    
    NSURL *url = [NSURL fileURLWithPath:[applicationSupportDirectory stringByAppendingPathComponent:@"Nutrition"]];
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType 
                                                configuration:nil 
                                                URL:url 
                                                options:nil 
                                                error:&error])
	{
        [[NSApplication sharedApplication] presentError:error];
        [persistentStoreCoordinator release], persistentStoreCoordinator = nil;
        return nil;
    }    

    return persistentStoreCoordinator;
}

/**
    Returns the managed object context for the application (which is already
    bound to the persistent store coordinator for the application.) 
 */
 
- (NSManagedObjectContext *) managedObjectContext
{
    if (managedObjectContext) return managedObjectContext;

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator)
	{
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"Failed to initialize the store" forKey:NSLocalizedDescriptionKey];
        [dict setValue:@"There was an error building up the data file." forKey:NSLocalizedFailureReasonErrorKey];
        NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    managedObjectContext = [[NSManagedObjectContext alloc] init];
    [managedObjectContext setPersistentStoreCoordinator:coordinator];
	
	[[managedObjectContext undoManager] disableUndoRegistration];
	
	[self uniqueManagedObjectWithEntityName:@"Field" keysValuesDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"bodyFat",@"name",[NSDecimalNumber zero],@"valueMin",[NSDecimalNumber decimalNumberWithString:@"100"],@"valueMax",NO,@"isCustom",nil]];
	[self uniqueManagedObjectWithEntityName:@"Field" keysValuesDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"waist",@"name",[NSDecimalNumber decimalNumberWithString:@"50"],@"valueMin",[NSDecimalNumber decimalNumberWithString:@"100"],@"valueDefault",NO,@"isCustom",nil]];
	[self uniqueManagedObjectWithEntityName:@"Field" keysValuesDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"weight",@"name",[NSDecimalNumber decimalNumberWithString:@"30"],@"valueMin",[NSDecimalNumber decimalNumberWithString:@"80"],@"valueDefault",NO,@"isCustom",nil]];
	
	/***INITIALIZE NUTRIENT RELATIONS***/
	
	Nutrient *kilocalorie = (Nutrient *)[self uniqueManagedObjectWithEntityName:@"Nutrient" keysValuesDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"Energy",@"scientificName",@"kcal",@"unit",@"Calories",@"commonName",nil]];
	
	//Contributors to KILOCALORIE
	Nutrient *totalFat = (Nutrient *)[self uniqueManagedObjectWithEntityName:@"Nutrient" keysValuesDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"Total lipid (fat)",@"scientificName",@"g",@"unit",@"Fat",@"commonName",nil]];
	Nutrient *totalProtein = (Nutrient *)[self uniqueManagedObjectWithEntityName:@"Nutrient" keysValuesDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"Protein",@"scientificName",@"g",@"unit",@"Protein",@"commonName",nil]];
	Nutrient *totalCarbohydrate = (Nutrient *)[self uniqueManagedObjectWithEntityName:@"Nutrient" keysValuesDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"Carbohydrate, by difference",@"scientificName",@"g",@"unit",@"Carbohydrate",@"commonName",nil]];
	
	[self uniqueManagedObjectWithEntityName:@"Composition" keysValuesDictionary:[NSDictionary dictionaryWithObjectsAndKeys:totalFat,@"subnutrient",kilocalorie,@"supernutrient",[NSDecimalNumber decimalNumberWithMantissa:9 exponent:0 isNegative:NO],@"quantity",nil]];
	[self uniqueManagedObjectWithEntityName:@"Composition" keysValuesDictionary:[NSDictionary dictionaryWithObjectsAndKeys:totalProtein,@"subnutrient",kilocalorie,@"supernutrient",[NSDecimalNumber decimalNumberWithMantissa:4 exponent:0 isNegative:NO],@"quantity",nil]];
	[self uniqueManagedObjectWithEntityName:@"Composition" keysValuesDictionary:[NSDictionary dictionaryWithObjectsAndKeys:totalCarbohydrate,@"subnutrient",kilocalorie,@"supernutrient",[NSDecimalNumber decimalNumberWithMantissa:4 exponent:0 isNegative:NO],@"quantity",nil]];
	
	//Contributors to FAT
	Nutrient *transFat = (Nutrient *)[self uniqueManagedObjectWithEntityName:@"Nutrient" keysValuesDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"Fatty acids, total trans",@"scientificName",@"g",@"unit",@"Trans Fat",@"commonName",nil]];
	Nutrient *saturatedFat = (Nutrient *)[self uniqueManagedObjectWithEntityName:@"Nutrient" keysValuesDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"Fatty acids, total saturated",@"scientificName",@"g",@"unit",@"Saturated Fat",@"commonName",nil]];
	Nutrient *monounsaturatedFat = (Nutrient *)[self uniqueManagedObjectWithEntityName:@"Nutrient" keysValuesDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"Fatty acids, total monounsaturated",@"scientificName",@"g",@"unit",@"Monounsaturated Fat",@"commonName",nil]];
	Nutrient *polyunsaturatedFat = (Nutrient *)[self uniqueManagedObjectWithEntityName:@"Nutrient" keysValuesDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"Fatty acids, total polyunsaturated",@"scientificName",@"g",@"unit",@"Polyunsaturated Fat",@"commonName",nil]];
	
	[self uniqueManagedObjectWithEntityName:@"Composition" keysValuesDictionary:[NSDictionary dictionaryWithObjectsAndKeys:transFat,@"subnutrient",totalFat,@"supernutrient",[NSDecimalNumber decimalNumberWithMantissa:1 exponent:0 isNegative:NO],@"quantity",nil]];
	[self uniqueManagedObjectWithEntityName:@"Composition" keysValuesDictionary:[NSDictionary dictionaryWithObjectsAndKeys:saturatedFat,@"subnutrient",totalFat,@"supernutrient",[NSDecimalNumber decimalNumberWithMantissa:1 exponent:0 isNegative:NO],@"quantity",nil]];
	[self uniqueManagedObjectWithEntityName:@"Composition" keysValuesDictionary:[NSDictionary dictionaryWithObjectsAndKeys:monounsaturatedFat,@"subnutrient",totalFat,@"supernutrient",[NSDecimalNumber decimalNumberWithMantissa:1 exponent:0 isNegative:NO],@"quantity",nil]];
	[self uniqueManagedObjectWithEntityName:@"Composition" keysValuesDictionary:[NSDictionary dictionaryWithObjectsAndKeys:polyunsaturatedFat,@"subnutrient",totalFat,@"supernutrient",[NSDecimalNumber decimalNumberWithMantissa:1 exponent:0 isNegative:NO],@"quantity",nil]];
	//missing individual fatty acids...
	
	//Contributors to CARBOHYDRATE
	Nutrient *starch = (Nutrient *)[self uniqueManagedObjectWithEntityName:@"Nutrient" keysValuesDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"Starch",@"scientificName",@"g",@"unit",@"Starch",@"commonName",nil]];
	Nutrient *sugar = (Nutrient *)[self uniqueManagedObjectWithEntityName:@"Nutrient" keysValuesDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"Sugars, total",@"scientificName",@"g",@"unit",@"Sugar",@"commonName",nil]];
	
	[self uniqueManagedObjectWithEntityName:@"Composition" keysValuesDictionary:[NSDictionary dictionaryWithObjectsAndKeys:starch,@"subnutrient",totalCarbohydrate,@"supernutrient",[NSDecimalNumber decimalNumberWithMantissa:1 exponent:0 isNegative:NO],@"quantity",nil]];
	[self uniqueManagedObjectWithEntityName:@"Composition" keysValuesDictionary:[NSDictionary dictionaryWithObjectsAndKeys:sugar,@"subnutrient",totalCarbohydrate,@"supernutrient",[NSDecimalNumber decimalNumberWithMantissa:1 exponent:0 isNegative:NO],@"quantity",nil]];
	
	//Contributors to PROTEIN
	//Do the amino acids here...
	
	[[managedObjectContext undoManager] enableUndoRegistration];
	
    return managedObjectContext;
}

- (NSManagedObject *) activeProfile
{
	return [[profilesArrayController selectedObjects] count]>0?[[profilesArrayController selectedObjects] lastObject]:nil;
}

- (BOOL) validateToolbarItem:(NSToolbarItem *)toolbarItem
{
	return !![self activeProfile];
}

- (NSManagedObject *) uniqueManagedObjectWithEntityName:(NSString *)entityName keysValuesDictionary:(NSDictionary *)keysValuesDictionary
{
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	
	NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:[self managedObjectContext]];
	[fetchRequest setEntity:entityDescription];
	
	NSArray *keys = [keysValuesDictionary allKeys];
	NSMutableArray *subpredicates = [NSMutableArray array];
	for (NSString *nextKey in keys)
	{
		id nextValue = [keysValuesDictionary valueForKey:nextKey];
		[subpredicates addObject:[NSComparisonPredicate predicateWithLeftExpression:[NSExpression expressionForKeyPath:nextKey] rightExpression:[NSExpression expressionForConstantValue:nextValue] modifier:NSDirectPredicateModifier type:([nextValue isKindOfClass:[NSString class]] ? NSLikePredicateOperatorType : NSEqualToPredicateOperatorType) options:0]];
	}
	
	[fetchRequest setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:subpredicates]];
	
	NSArray *existingEntities = [[self managedObjectContext] executeFetchRequest:fetchRequest error:nil];
	if ([existingEntities count]==1) return [existingEntities lastObject];
	
	NSManagedObject *newEntity = [[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:[self managedObjectContext]];
	for (NSString *nextKey in keys) [newEntity setValue:[keysValuesDictionary valueForKey:nextKey] forKey:nextKey];
	
	return newEntity;
}

/**
    Returns the NSUndoManager for the application.  In this case, the manager
    returned is that of the managed object context for the application.
 */
 
- (NSUndoManager *) windowWillReturnUndoManager:(NSWindow *)window
{
    return [[self managedObjectContext] undoManager];
}


/**
    Performs the save action for the application, which is to send the save:
    message to the application's managed object context.  Any encountered errors
    are presented to the user.
 */
 
- (IBAction) saveAction:(id)sender
{

    NSError *error = nil;
    
    if (![[self managedObjectContext] commitEditing])
	{
        NSLog(@"%@:%s unable to commit editing before saving", [self class], _cmd);
    }

    if (![[self managedObjectContext] save:&error])
	{
        [[NSApplication sharedApplication] presentError:error];
    }
}


/**
    Implementation of the applicationShouldTerminate: method, used here to
    handle the saving of changes in the application managed object context
    before the application terminates.
 */
 
- (NSApplicationTerminateReply) applicationShouldTerminate:(NSApplication *)sender {

    if (!managedObjectContext) return NSTerminateNow;

    if (![managedObjectContext commitEditing])
	{
        NSLog(@"%@:%s unable to commit editing to terminate", [self class], _cmd);
        return NSTerminateCancel;
    }

    if (![managedObjectContext hasChanges]) return NSTerminateNow;

    NSError *error = nil;
    if (![managedObjectContext save:&error])
	{
        // This error handling simply presents error information in a panel with an 
        // "Ok" button, which does not include any attempt at error recovery (meaning, 
        // attempting to fix the error.)  As a result, this implementation will 
        // present the information to the user and then follow up with a panel asking 
        // if the user wishes to "Quit Anyway", without saving the changes.

        // Typically, this process should be altered to include application-specific 
        // recovery steps.  
                
        BOOL result = [sender presentError:error];
        if (result) return NSTerminateCancel;

        NSString *question = NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", @"Quit without saves error question message");
        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
        NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];

        NSInteger answer = [alert runModal];
        [alert release];
        alert = nil;
        
        if (answer == NSAlertAlternateReturn) return NSTerminateCancel;
    }

    return NSTerminateNow;
}


/**
    Implementation of dealloc, to release the retained variables.
 */
 
- (void) dealloc
{

    [window release];
    [managedObjectContext release];
    [persistentStoreCoordinator release];
    [managedObjectModel release];
	
    [super dealloc];
}


@end
