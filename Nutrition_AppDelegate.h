//
//  Nutrition_AppDelegate.h
//  Nutrition
//
//  Created by Hans Andersson on 11/01/06.
//  Copyright Vigorware 2011 . All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Nutrition_AppDelegate : NSObject 
{
    NSWindow *window;
    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
	
	IBOutlet NSArrayController *profilesArrayController;
}

@property (nonatomic, retain) IBOutlet NSWindow *window;

@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;

- (NSManagedObject *)activeProfile;
- (NSManagedObject *)uniqueManagedObjectWithEntityName:(NSString *)entityName keysValuesDictionary:(NSDictionary *)keysValuesDictionary;

- (IBAction)saveAction:sender;

@end
