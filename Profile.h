//
//  Profile.h
//  Nutrition
//
//  Created by Hans Andersson on 11/01/10.
//  Copyright 2011 Vigorware. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Profile : NSManagedObject {}

@property (readwrite,assign) NSDecimalNumber *heightInchesTotal;
@property (readwrite,assign) NSDecimalNumber *heightFeet;
@property (readwrite,assign) NSDecimalNumber *heightInches;

@property (readonly) NSDecimalNumber *age;
@property (readonly) NSDecimalNumber *basalMetabolism;
@property (readonly) NSDecimalNumber *waistHeightPercentage;
@property (readonly) NSDecimalNumber *bodyMassIndex;
@property (readonly) NSDecimalNumber *activityMetabolism;
@property (readonly) NSDecimalNumber *totalMetabolism;

@property (readonly) NSArray *statistics;
@property (readonly) NSArray *measurementSummaries;
@property (readonly) NSArray *reportEntries;

- (NSManagedObject *)fieldWithName:(NSString *)name;
- (void) consumptionOfNutrient:(NSManagedObject *)nutrient withTimeInterval:(NSTimeInterval)timeInterval untilDate:(NSDate *)date;

@end
