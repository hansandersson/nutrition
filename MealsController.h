//
//  MealsController.h
//  Nutrition
//
//  Created by Hans Andersson on 11/01/09.
//  Copyright 2011 Vigorware. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MealsController : NSObject {}

- (NSManagedObject *)mealtimeForName:(NSString *)mealtimeName;
- (NSManagedObject *)mealForDate:(NSDate *)date mealtime:(NSManagedObject *)mealtime;

@end
