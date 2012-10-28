//
//  Profile.m
//  Nutrition
//
//  Created by Hans Andersson on 11/01/10.
//  Copyright 2011 Vigorware. All rights reserved.
//

#import "Profile.h"
#import "Nutrition_AppDelegate.h"
#import "CentimetersInchesTransformer.h"
#import "Statistic.h"
#import "Vital.h"

@implementation Profile

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key
{
	if ([key isEqualToString:@"age"]) return [NSSet setWithObject:@"dateOfBirth"];
	if ([key isEqualToString:@"reportEntries"]) return [NSSet setWithObjects:@"totalMetabolism",@"height",@"weight",@"waist",@"bodyFat",nil];
	if ([key isEqualToString:@"basalMetabolism"]) return [NSSet setWithObjects:@"bodyFat",@"bodyTemperature",@"weight",@"height",@"isMale",@"dateOfBirth",nil];
	if ([key isEqualToString:@"activityMetabolism"]) return [NSSet setWithObjects:@"basalMetabolism",@"activity1",@"activity2",@"activity3",@"activity4",nil];
	if ([key isEqualToString:@"totalMetabolism"]) return [NSSet setWithObjects:@"basalMetabolism",@"activityMetabolism",nil];
	if ([key isEqualToString:@"heightInches"]) return [NSSet setWithObjects:@"heightInchesTotal",nil];
	if ([key isEqualToString:@"heightFeet"]) return [NSSet setWithObjects:@"heightInchesTotal",nil];
	if ([key isEqualToString:@"heightInchesTotal"]) return [NSSet setWithObjects:@"height",nil];
	return [super keyPathsForValuesAffectingValueForKey:key];
}

- (NSDecimalNumber *) heightInchesTotal
{
	CentimetersInchesTransformer *heightsTransformer = [[CentimetersInchesTransformer alloc] init];
	return [heightsTransformer transformedValue:[self valueForKey:@"height"]];
}
- (NSDecimalNumber *) heightFeet
{
	NSDecimalNumber *heightInchesTotal = [self heightInchesTotal];
	NSDecimalNumber *inchesInFoot = [NSDecimalNumber decimalNumberWithString:@"12"];
	NSDecimalNumberHandler *wholeNumberBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:0 raiseOnExactness:NO raiseOnOverflow:YES raiseOnUnderflow:YES raiseOnDivideByZero:YES];
	return [heightInchesTotal decimalNumberByDividingBy:inchesInFoot withBehavior:wholeNumberBehavior];
}
- (NSDecimalNumber *) heightInches
{
	NSDecimalNumber *inchesInFoot = [NSDecimalNumber decimalNumberWithString:@"12"];
	NSDecimalNumber *heightFeet = [self heightFeet];
	return [[self heightInchesTotal] decimalNumberBySubtracting:[heightFeet decimalNumberByMultiplyingBy:inchesInFoot]];
}

- (void) setHeightInchesTotal:(NSDecimalNumber *)heightInchesTotal
{
	CentimetersInchesTransformer *heightsTransformer = [[CentimetersInchesTransformer alloc] init];
	[self setValue:[heightsTransformer reverseTransformedValue:heightInchesTotal] forKey:@"height"];
}
- (void) setHeightFeet:(NSDecimalNumber *)heightFeet
{
	NSDecimalNumber *inchesInFoot = [NSDecimalNumber decimalNumberWithString:@"12"];
	NSDecimalNumber *heightInches = [self heightInches];
	[self setHeightInchesTotal:[[heightFeet decimalNumberByMultiplyingBy:inchesInFoot] decimalNumberByAdding:heightInches]];
}
- (void) setHeightInches:(NSDecimalNumber *)heightInches
{
	NSDecimalNumber *inchesInFoot = [NSDecimalNumber decimalNumberWithString:@"12"];
	if ([heightInches compare:inchesInFoot]==NSOrderedDescending)
	{
		[self setHeightFeet:[[self heightFeet] decimalNumberByAdding:[NSDecimalNumber one]]];
		return (void)[self setHeightInches:[heightInches decimalNumberBySubtracting:inchesInFoot]];
	}
	NSDecimalNumber *heightFeet = [self heightFeet];
	[self setHeightInchesTotal:[[heightFeet decimalNumberByMultiplyingBy:inchesInFoot] decimalNumberByAdding:heightInches]];
}

- (NSManagedObject *) fieldWithName:(NSString *)name
{
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:[NSEntityDescription entityForName:@"Field" inManagedObjectContext:[self managedObjectContext]]];
	[fetchRequest setPredicate:[NSComparisonPredicate
								predicateWithLeftExpression:[NSExpression expressionForKeyPath:@"name"]
								rightExpression:[NSExpression expressionForConstantValue:name]
								modifier:NSDirectPredicateModifier
								type:NSLikePredicateOperatorType
								options:0]];
	
	NSArray *existingFields = [[self managedObjectContext] executeFetchRequest:fetchRequest error:nil];
	
	return [existingFields count]>0 ? [existingFields lastObject] : nil;
}

- (NSMutableArray *) mutableArrayValueForKey:(NSString *)key
{
	NSManagedObject *field = [self fieldWithName:key];
	if (!field) return [super mutableArrayValueForKey:key];
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:[NSEntityDescription entityForName:@"Measurement" inManagedObjectContext:[self managedObjectContext]]];
	
	[fetchRequest
	 setPredicate:
	 
	 [NSCompoundPredicate
	  andPredicateWithSubpredicates:
	  
	  [NSArray
	   arrayWithObjects:
	   
	   [NSComparisonPredicate
		predicateWithLeftExpression:[NSExpression expressionForKeyPath:@"field"]
		rightExpression:[NSExpression expressionForConstantValue:field]
		modifier:NSDirectPredicateModifier
		type:NSEqualToPredicateOperatorType
		options:0],
	   [NSComparisonPredicate
		predicateWithLeftExpression:[NSExpression expressionForKeyPath:@"profile"]
		rightExpression:[NSExpression expressionForConstantValue:self]
		modifier:NSDirectPredicateModifier
		type:NSEqualToPredicateOperatorType
		options:0],
	   nil]
	  
	  ]
	 
	 ];
	
	[fetchRequest setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]]];
	
	return [[[self managedObjectContext] executeFetchRequest:fetchRequest error:nil] mutableCopy];
}

- (id) valueForUndefinedKey:(NSString *)key
{
	if ([key length]>12 && [[key substringFromIndex:[key length]-12] isEqualToString:@"Measurements"]) return [self mutableArrayValueForKey:[key substringToIndex:[key length]-12]];
	
	NSManagedObject *field = [self fieldWithName:key];
	if (!field) return [super valueForUndefinedKey:key];
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:[NSEntityDescription entityForName:@"Measurement" inManagedObjectContext:[self managedObjectContext]]];
	[fetchRequest setPredicate:[NSComparisonPredicate
								predicateWithLeftExpression:[NSExpression expressionForKeyPath:@"field"]
								rightExpression:[NSExpression expressionForConstantValue:field]
								modifier:NSDirectPredicateModifier
								type:NSEqualToPredicateOperatorType
								options:0]];
	[fetchRequest setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]]];
	
	NSArray *existingMeasurements = [[self managedObjectContext] executeFetchRequest:fetchRequest error:nil];
	if (![existingMeasurements count]) return [field valueForKey:@"valueDefault"];
	
	return [[existingMeasurements lastObject] valueForKey:@"value"];
}

- (void) setValue:(id)value forUndefinedKey:(NSString *)key
{
	NSManagedObject *field = [self fieldWithName:key];
	if (!field) return (void)[super setValue:value forUndefinedKey:key];
	
	NSDecimalNumber *valueMin = [field valueForKey:@"valueMin"];
	NSDecimalNumber *valueMax = [field valueForKey:@"valueMax"];
	
	NSAssert( (!valueMin || [valueMin compare:value]!=NSOrderedDescending) && (!valueMax || [valueMax compare:value]!=NSOrderedAscending), @"Proposed Measurement value %@ for Field ‘%@’ violates bounds [%@,%@]",value,key,valueMin,valueMax);
	
	[self willChangeValueForKey:key];
	[self willChangeValueForKey:[NSString stringWithFormat:@"%@Measurements",key]];
	
	[[[self managedObjectContext] undoManager] beginUndoGrouping];
	NSManagedObject *newMeasurement = [[NSManagedObject alloc] initWithEntity:[NSEntityDescription entityForName:@"Measurement" inManagedObjectContext:[self managedObjectContext]] insertIntoManagedObjectContext:[self managedObjectContext]];
	[newMeasurement setValue:field forKey:@"field"];
	[newMeasurement setValue:value forKey:@"value"];
	[newMeasurement setValue:[(Nutrition_AppDelegate *)[NSApp delegate] activeProfile] forKey:@"profile"];
	[[[self managedObjectContext] undoManager] endUndoGrouping];
	
	[self didChangeValueForKey:key];
	[self didChangeValueForKey:[NSString stringWithFormat:@"%@Measurements",key]];
}

- (void) consumptionOfNutrient:(NSManagedObject *)nutrient withTimeInterval:(NSTimeInterval)timeInterval untilDate:(NSDate *)date
{
	//find relevant meals
	//find relevant helpings
}

- (NSDecimalNumber *) age
{
	return [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSinceDate:[self valueForKey:@"dateOfBirth"]]/31556926.0]];
}

- (NSDecimalNumber *) basalMetabolism
{
	double bmr;
	if ([self valueForKey:@"bodyFat"]!=nil)
	{
		double fatPercentage = [[self valueForKey:@"bodyFat"] doubleValue];
		double lean = [[self valueForKey:@"weight"] doubleValue]*(1.0-(fatPercentage/100.0));
		bmr = 370.0+(21.6*lean);
	}
	else
	{
		double weight = [[self valueForKey:@"weight"] doubleValue];
		double height = [[self valueForKey:@"height"] doubleValue];
		bmr = (10.0*weight) + (6.25*height) - (5.0*[[self age] doubleValue]) + ([[self valueForKey:@"isMale"] boolValue] ? 5.0 : (-161.0));
	}
	bmr *= 1.0+(([[self valueForKey:@"bodyTemperature"] doubleValue]-36.8)*(0.07/0.5));
	return [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",round(bmr)]];
}

- (NSDecimalNumber *) waistHeightPercentage
{ //FIXME: replace with an Index
	double waist = [[self valueForKey:@"waist"] doubleValue];
	double height = [[self valueForKey:@"height"] doubleValue];
	return [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",round(waist/height*1000)/10.0]];
}

- (NSDecimalNumber *) bodyMassIndex
{ //FIXME: replace with an Index
	double weight = [[self valueForKey:@"weight"] doubleValue];
	double height = [[self valueForKey:@"height"] doubleValue]/100;
	return [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",round(weight/pow(height,2)*10)/10.0]];
}

- (NSDecimalNumber *) activityMetabolism
{
	double hourlyBasalMetabolism = [[self basalMetabolism] doubleValue]/24.0;
	double activityMetabolism = (0.5)*[[self valueForKey:@"activity1"] doubleValue]
	+ (1.5)*[[self valueForKey:@"activity2"] doubleValue]
	+ (4.0)*[[self valueForKey:@"activity3"] doubleValue]
	+ (6.0)*[[self valueForKey:@"activity4"] doubleValue];
	activityMetabolism = round(activityMetabolism*hourlyBasalMetabolism);
	return [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",activityMetabolism]];
}

- (NSDecimalNumber *) totalMetabolism
{
	return [[self basalMetabolism] decimalNumberByAdding:[self activityMetabolism]];
}

- (NSArray *) statistics
{
	NSMutableArray *statistics = [NSMutableArray array];
	
	NSDictionary *vitalsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
									  [self age],@"age",
									  [self valueForKey:@"height"],@"height",
									  [self activityMetabolism],@"activityMetabolism",
									  [self basalMetabolism],@"basalMetabolism",
									  [self totalMetabolism],@"totalMetabolism",
									  nil];
	
	NSArray *vitalNames = [vitalsDictionary allKeys];
	
	for (NSString *nextVitalName in vitalNames)
	{
		Vital *newVital = [[Vital alloc] init];
		[newVital setValue:nextVitalName forKey:@"name"];
		[newVital setValue:NO forKey:@"isCustom"];
		[newVital setDecimalValue:[vitalsDictionary valueForKey:nextVitalName]];
	}
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	
	[fetchRequest setEntity:[NSEntityDescription entityForName:@"Field" inManagedObjectContext:[self managedObjectContext]]];
	NSArray *fields = [[self managedObjectContext] executeFetchRequest:fetchRequest error:nil];
	for (NSManagedObject *nextField in fields) [statistics addObject:nextField];
	
	[fetchRequest setEntity:[NSEntityDescription entityForName:@"Index" inManagedObjectContext:[self managedObjectContext]]];
	NSArray *indexes = [[self managedObjectContext] executeFetchRequest:fetchRequest error:nil];
	for (NSManagedObject *nextIndex in indexes) [statistics addObject:nextIndex];
	
	return [statistics copy];
}

- (NSArray *) reportEntries
{
	NSMutableArray *reportEntries = [NSMutableArray arrayWithObject:[NSDictionary dictionaryWithObjectsAndKeys:
																	 [NSString stringWithFormat:@"Daily Caloric Usage: %@",[self totalMetabolism]],@"headline",
																	 @"This estimate reflects your basal metabolism and lifestyle activity.",@"description",
																	 [[NSBundle mainBundle] pathForResource:@"statusBlue" ofType:@"tiff"],@"imagePath",
																	 @"http://en.wikipedia.org/wiki/Basal_metabolic_rate",@"source",
																	 nil]];
	
	NSDictionary *reportFormats = [NSDictionary dictionaryWithObjectsAndKeys:
								   
								   [NSDictionary dictionaryWithObjectsAndKeys: //Body Mass Index
									[self bodyMassIndex],@"value",
									[NSArray arrayWithObjects:
									 [NSDictionary dictionaryWithObjectsAndKeys:[NSDecimalNumber decimalNumberWithString:@"15"],@"max", @"Emaciated",@"description", [[NSBundle mainBundle] pathForResource:@"statusRed" ofType:@"png"],@"imagePath", nil],
									 [NSDictionary dictionaryWithObjectsAndKeys:[NSDecimalNumber decimalNumberWithString:@"18.5"],@"max", @"Underweight",@"description", [[NSBundle mainBundle] pathForResource:@"statusYellow" ofType:@"png"],@"imagePath", nil],
									 [NSDictionary dictionaryWithObjectsAndKeys:[NSDecimalNumber decimalNumberWithString:@"23"],@"max", @"Healthy",@"description", [[NSBundle mainBundle] pathForResource:@"statusGreen" ofType:@"png"],@"imagePath", nil],
									 [NSDictionary dictionaryWithObjectsAndKeys:[NSDecimalNumber decimalNumberWithString:@"27.5"],@"max", @"Overweight",@"description", [[NSBundle mainBundle] pathForResource:@"statusYellow" ofType:@"png"],@"imagePath", nil],
									 [NSDictionary dictionaryWithObjectsAndKeys:@"Obese",@"description", [[NSBundle mainBundle] pathForResource:@"statusRed" ofType:@"png"],@"imagePath", nil],
									 nil],@"templates",
									@"This measure relates weight to the square of height.",@"description",
									@"http://en.wikipedia.org/wiki/Body_mass_index",@"source",
									nil],@"Body Mass Index",
								   
								   [NSDictionary dictionaryWithObjectsAndKeys: //Waist–Height Percentage
									[self waistHeightPercentage],@"value",
									[NSArray arrayWithObjects:
									 [NSDictionary dictionaryWithObjectsAndKeys:[NSDecimalNumber decimalNumberWithString:[[self valueForKey:@"isMale"] boolValue]?@"50":@"49"],@"max", @"Optimal",@"description", [[NSBundle mainBundle] pathForResource:@"statusGreen" ofType:@"png"],@"imagePath", nil],
									 [NSDictionary dictionaryWithObjectsAndKeys:[NSDecimalNumber decimalNumberWithString:[[self valueForKey:@"isMale"] boolValue]?@"55":@"53"],@"max", @"Acceptable",@"description", [[NSBundle mainBundle] pathForResource:@"statusYellow" ofType:@"png"],@"imagePath", nil],
									 [NSDictionary dictionaryWithObjectsAndKeys:@"Hazardous",@"description", [[NSBundle mainBundle] pathForResource:@"statusRed" ofType:@"png"],@"imagePath", nil],
									 nil],@"templates",
									@"This measure relates waist Circumerence to height.",@"description",
									@"http://en.wikipedia.org/wiki/Waist",@"source",
									nil],@"Waist–Height Percentage",
								   
								   [NSDictionary dictionaryWithObjectsAndKeys: //Body-Fat Percentage
									[self valueForKey:@"bodyFat"],@"value",
									([[self valueForKey:@"isMale"] boolValue]
									 ?
									 [NSArray arrayWithObjects:
									  [NSDictionary dictionaryWithObjectsAndKeys:[NSDecimalNumber decimalNumberWithString:@"2"],@"max", @"Insufficient",@"description", [[NSBundle mainBundle] pathForResource:@"statusRed" ofType:@"png"],@"imagePath", nil],
									  [NSDictionary dictionaryWithObjectsAndKeys:[NSDecimalNumber decimalNumberWithString:@"5"],@"max", @"Minimal",@"description", [[NSBundle mainBundle] pathForResource:@"statusYellow" ofType:@"png"],@"imagePath", nil],
									  [NSDictionary dictionaryWithObjectsAndKeys:[NSDecimalNumber decimalNumberWithString:@"13"],@"max", @"Athletic",@"description", [[NSBundle mainBundle] pathForResource:@"statusGreen" ofType:@"png"],@"imagePath", nil],
									  [NSDictionary dictionaryWithObjectsAndKeys:[NSDecimalNumber decimalNumberWithString:@"17"],@"max", @"Healthy",@"description", [[NSBundle mainBundle] pathForResource:@"statusGreen" ofType:@"png"],@"imagePath", nil],
									  [NSDictionary dictionaryWithObjectsAndKeys:[NSDecimalNumber decimalNumberWithString:@"24"],@"max", @"Moderate",@"description", [[NSBundle mainBundle] pathForResource:@"statusYellow" ofType:@"png"],@"imagePath", nil],
									  [NSDictionary dictionaryWithObjectsAndKeys:@"Elevated",@"description", [[NSBundle mainBundle] pathForResource:@"statusRed" ofType:@"png"],@"imagePath", nil],
									  nil]
									 :
									 [NSArray arrayWithObjects:
									  [NSDictionary dictionaryWithObjectsAndKeys:[NSDecimalNumber decimalNumberWithString:@"10"],@"max", @"Insufficient",@"description", [[NSBundle mainBundle] pathForResource:@"statusRed" ofType:@"png"],@"imagePath", nil],
									  [NSDictionary dictionaryWithObjectsAndKeys:[NSDecimalNumber decimalNumberWithString:@"13"],@"max", @"Minimal",@"description", [[NSBundle mainBundle] pathForResource:@"statusYellow" ofType:@"png"],@"imagePath", nil],
									  [NSDictionary dictionaryWithObjectsAndKeys:[NSDecimalNumber decimalNumberWithString:@"20"],@"max", @"Athletic",@"description", [[NSBundle mainBundle] pathForResource:@"statusGreen" ofType:@"png"],@"imagePath", nil],
									  [NSDictionary dictionaryWithObjectsAndKeys:[NSDecimalNumber decimalNumberWithString:@"24"],@"max", @"Healthy",@"description", [[NSBundle mainBundle] pathForResource:@"statusGreen" ofType:@"png"],@"imagePath", nil],
									  [NSDictionary dictionaryWithObjectsAndKeys:[NSDecimalNumber decimalNumberWithString:@"31"],@"max", @"Moderate",@"description", [[NSBundle mainBundle] pathForResource:@"statusYellow" ofType:@"png"],@"imagePath", nil],
									  [NSDictionary dictionaryWithObjectsAndKeys:@"Elevated",@"description", [[NSBundle mainBundle] pathForResource:@"statusRed" ofType:@"png"],@"imagePath", nil],
									  nil]),@"templates",
									@"This measure relates fat to total body weight.",@"description",
									@"http://en.wikipedia.org/wiki/Body_fat_percentage",@"source",
									nil],@"Body-Fat Percentage",
								   
								   nil];
	
	NSArray *reportEntryFieldNames = [reportFormats allKeys];
	for (NSUInteger n=0; n<[reportEntryFieldNames count]; n++)
	{
		NSString *fieldName = [reportEntryFieldNames objectAtIndex:n];
		NSMutableDictionary *newReportEntry = [NSMutableDictionary dictionary];
		[newReportEntry setValue:[[reportFormats valueForKey:fieldName] valueForKey:@"description"] forKey:@"description"];
		[newReportEntry setValue:[[reportFormats valueForKey:fieldName] valueForKey:@"source"] forKey:@"source"];
		[newReportEntry setValue:[NSString stringWithFormat:@"%@: Unavailable",fieldName] forKey:@"headline"];
		[newReportEntry setValue:[[NSBundle mainBundle] pathForResource:@"statusYellow" ofType:@"png"] forKey:@"imagePath"];
		
		if ( [[reportFormats valueForKey:fieldName] valueForKey:@"value"] )
		{
			NSDecimalNumber *reportEntryValue = [[reportFormats valueForKey:fieldName] valueForKey:@"value"];
			NSArray *reportEntryTemplates = [[reportFormats valueForKey:fieldName] valueForKey:@"templates"];
			for (NSUInteger t=0; t<[reportEntryTemplates count]; t++)
			{
				NSDictionary *nextTemplate = [reportEntryTemplates objectAtIndex:t];
				
				if ( ![nextTemplate valueForKey:@"max"] || [[nextTemplate valueForKey:@"max"] compare:reportEntryValue]==NSOrderedDescending )
				{
					[newReportEntry setValue:[NSString stringWithFormat:@"%@: %@ (%@)",fieldName,reportEntryValue,[nextTemplate valueForKey:@"description"]] forKey:@"headline"];
					[newReportEntry setValue:[nextTemplate valueForKey:@"imagePath"] forKey:@"imagePath"];
					break;
				}
			}
		}
		
		[reportEntries addObject:newReportEntry];
	}
	
	return reportEntries;
}

- (NSArray *) measurementSummaries
{
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	
	[fetchRequest setEntity:[NSEntityDescription entityForName:@"Field" inManagedObjectContext:[self managedObjectContext]]];
	NSArray *fields = [[self managedObjectContext] executeFetchRequest:fetchRequest error:nil];
	NSMutableArray *measurementSummaries = [NSMutableArray arrayWithCapacity:[fields count]];
	for (NSManagedObject *nextField in fields)
	{
		NSString *fieldName = [nextField valueForKey:@"name"];
		NSArray *measurements = [self mutableArrayValueForKey:fieldName];
		
		NSDate *dateUpdated = [[measurements lastObject] valueForKey:@"date"];
		
		NSDecimalNumber *valuesLast = [[measurements lastObject] valueForKey:@"value"];
		NSDecimalNumber *valuesMin = nil;
		NSDecimalNumber *valuesMax = nil;
		
		for (NSManagedObject *nextMeasurement in measurements)
		{
			if (!valuesMin || [valuesMin compare:[nextMeasurement valueForKey:@"value"]]==NSOrderedDescending) valuesMin = [nextMeasurement valueForKey:@"value"];
			if (!valuesMax || [valuesMax compare:[nextMeasurement valueForKey:@"value"]]==NSOrderedAscending) valuesMax = [nextMeasurement valueForKey:@"value"];
		}
		
		[measurementSummaries addObject:[NSDictionary dictionaryWithObjectsAndKeys:
										 fieldName,@"fieldName",
										 valuesLast,@"valuesLast",
										 valuesMin,@"valuesMin",
										 valuesMax,@"valuesMax",
										 dateUpdated,@"dateUpdated",
										 measurements,@"entries",
										 [NSDecimalNumber decimalNumberWithMantissa:(unsigned long long)[measurements count] exponent:0 isNegative:NO],@"entriesCount",
										 nil]];
	}
	
	return measurementSummaries;
}

@end
