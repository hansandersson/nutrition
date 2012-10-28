//
//  MealSheetController.h
//  Nutrition
//
//  Created by Hans Andersson on 11/01/09.
//  Copyright 2011 Vigorware. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class FoodsController;
@class HelpingsController;
@class MealsController;

@interface MealSheetController : NSObject <NSTableViewDataSource> {
	IBOutlet FoodsController *foodsController;
	IBOutlet HelpingsController *helpingsController;
	IBOutlet MealsController *mealsController;

	IBOutlet NSArrayController *foodUnitsArrayController;
	
	IBOutlet NSWindow *mealSheet;
	
	IBOutlet NSComboBox *mealNameBox;
	IBOutlet NSDatePicker *datePicker;
	
	IBOutlet NSSearchField *searchTextField;
	
	IBOutlet NSTableView *helpingsTableView;
	
	IBOutlet NSProgressIndicator *detailProgressIndicator;
	IBOutlet NSTextField *quantityTextField;
	IBOutlet NSPopUpButton *unitsPopUpButton;
	IBOutlet NSButton *addButton;
}

- (void) openMealSheet:(id)sender;
- (void) closeMealSheet:(id)sender;

- (void) reloadHelpings:(id)sender;

- (void) search:(id)sender;
- (void) add:(id)sender;

- (NSManagedObject *)selectedMeal;

@end
