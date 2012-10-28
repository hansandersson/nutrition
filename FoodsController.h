//
//  FoodsController.h
//  Nutrition
//
//  Created by Hans Andersson on 11/01/06.
//  Copyright 2011 Vigorware. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FoodsController : NSObject <NSTableViewDelegate, NSTableViewDataSource> {
	IBOutlet NSProgressIndicator *searchProgressIndicator;
	IBOutlet NSTableView *foodsTableView;
	
	IBOutlet NSTextField *quantityTextField;
	IBOutlet NSPopUpButton *unitsPopUpButton;
	
	NSMutableArray *foods;
	NSMutableArray *foodUnits;
	
	NSURLConnection *activeURLConnection;
	NSMutableData *dataReceived;
}

@property (readonly) NSArray *foods;
@property (readonly) NSArray *foodUnits;

- (NSManagedObject *)selectedFood;

- (void) findFoodsForString:(NSString *)searchString;
- (void) setUnitsForFood:(NSManagedObject *)food;

@end
