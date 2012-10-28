//
//  FoodsController.m
//  Nutrition
//
//  Created by Hans Andersson on 11/01/06.
//  Copyright 2011 Vigorware. All rights reserved.
//

#import "FoodsController.h"
#import "Nutrition_AppDelegate.h"

@implementation FoodsController

@synthesize foods;
@synthesize foodUnits;

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
	return [foods count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)rowIndex
{
	return [[foods objectAtIndex:rowIndex] valueForKey:@"name"];
}

- (NSManagedObject *)selectedFood
{
	NSDictionary *selectedFoodNameValue = [foods objectAtIndex:(NSUInteger)[foodsTableView selectedRow]];
	
	NSManagedObjectContext *managedObjectContext = [(Nutrition_AppDelegate *)[NSApp delegate] managedObjectContext];
	[[managedObjectContext undoManager] disableUndoRegistration];
	NSManagedObject *selectedFood = [(Nutrition_AppDelegate *)[NSApp delegate] uniqueManagedObjectWithEntityName:@"Food" keysValuesDictionary:selectedFoodNameValue];
	[[managedObjectContext undoManager] enableUndoRegistration];
	
	return selectedFood;
}

- (id) init
{
	if (self=[super init])
	{
		foods = [NSMutableArray array];
		foodUnits = [NSMutableArray array];
	}
	return self;
}

- (void) findFoodsForString:(NSString *)searchString
{
	searchString = [searchString stringByReplacingOccurrencesOfString:@"," withString:@" "];
	
	NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.nal.usda.gov/fnic/foodcomp/cgi-bin/nut_search_new.pl"]];
	[urlRequest setHTTPBody:[[NSString stringWithFormat:@"FOOD_GROUPS=-1&Keywords=%@",searchString] dataUsingEncoding:NSUTF8StringEncoding]];
	[urlRequest setHTTPMethod:@"POST"];
	
	if (activeURLConnection) [activeURLConnection cancel];
	
	[searchProgressIndicator setHidden:NO];
	[searchProgressIndicator startAnimation:self];
	
	dataReceived = [NSMutableData data];
	activeURLConnection = [NSURLConnection connectionWithRequest:urlRequest delegate:self];	
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	[self willChangeValueForKey:@"foods"];
	[foods removeAllObjects];
	[self didChangeValueForKey:@"foods"];
	
	[searchProgressIndicator stopAnimation:self];
	[searchProgressIndicator setHidden:YES];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[dataReceived appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSString *rawHTML = [[NSString alloc] initWithData:dataReceived encoding:NSUTF8StringEncoding];
	NSArray *htmlComponents = [rawHTML componentsSeparatedByString:@"<Input type=radio NAME= \"MSRE_NO\" VALUE=\""];
	
	foods = [NSMutableArray arrayWithCapacity:([htmlComponents count]-1)];
	for (NSUInteger i=1; i<[htmlComponents count]; i++)
	{
		NSString *nextComponent = [htmlComponents objectAtIndex:i];
		NSArray *nextComponentParts = [nextComponent componentsSeparatedByString:@"\"><font color = \"black\" size = -1>"];
		
		NSString *code = [nextComponentParts objectAtIndex:0];
		NSString *name = [[[[nextComponentParts objectAtIndex:1] componentsSeparatedByString:@" </font>"] objectAtIndex:0] stringByReplacingOccurrencesOfString:@"<BR>" withString:@""];
		
		[foods addObject:[NSDictionary dictionaryWithObjectsAndKeys:name,@"name",code,@"code",nil]];
	}
	[foodsTableView reloadData];
	
	[searchProgressIndicator stopAnimation:self];
	[searchProgressIndicator setHidden:YES];
}

- (void) setUnitsForFood:(NSManagedObject *)food
{
	[self willChangeValueForKey:@"foodUnits"];
	[foodUnits removeAllObjects];
	[self didChangeValueForKey:@"foodUnits"];
	
	if (food)
	{
		NSManagedObjectContext *managedObjectContext = [food managedObjectContext];
		[[managedObjectContext undoManager] disableUndoRegistration];
		
		[self willChangeValueForKey:@"foodUnits"];
		
		//Get source
		NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.nal.usda.gov/fnic/foodcomp/cgi-bin/measure.pl"]];
		[urlRequest setHTTPMethod:@"POST"];
		[urlRequest setHTTPBody:[[NSString stringWithFormat:@"submit=Submit&MSRE_NO=%@",[food valueForKey:@"code"]] dataUsingEncoding:NSUTF8StringEncoding]];
		
		NSString *servingsHTML = [[NSString alloc] initWithData:[NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil] encoding:NSUTF8StringEncoding];
		
		//Prepare arguments
		[urlRequest setURL:[NSURL URLWithString:@"http://www.nal.usda.gov/fnic/foodcomp/cgi-bin/list_nut_edit.pl"]];
		
		NSMutableString *httpBodyString = [NSMutableString stringWithString:@"MSRE_NO0=100grams&GRAMS_100=10"];
		
		NSArray *hiddenInputs = [servingsHTML componentsSeparatedByString:@"<INPUT TYPE=\"hidden\" NAME=\""];
		hiddenInputs = [hiddenInputs subarrayWithRange:NSMakeRange(1, [hiddenInputs count]-1)];
		
		for (NSString *nextHiddenInputString in hiddenInputs)
		{
			NSArray *parts = [nextHiddenInputString componentsSeparatedByString:@"\" VALUE=\""];
			NSString *name = [parts objectAtIndex:0];
			NSString *value = [[[parts objectAtIndex:1] componentsSeparatedByString:@"\">"] objectAtIndex:0];
			[httpBodyString appendFormat:@"&%@=%@",name,value];
		}
		
		[urlRequest setHTTPBody:[httpBodyString dataUsingEncoding:NSUTF8StringEncoding]];
		[urlRequest setHTTPMethod:@"POST"];
		
		//Get nutrients
		NSString *nutritionTableHTMLString = [[NSString alloc] initWithData:[NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil] encoding:NSUTF8StringEncoding];
		
		NSArray *nutritionTableEntries = [nutritionTableHTMLString componentsSeparatedByString:@"<tr>"];
		for (NSUInteger i=1; i<[nutritionTableEntries count]; i++)
		{
			NSString *nextEntryString = [nutritionTableEntries objectAtIndex:i];
			NSArray *parts = [nextEntryString componentsSeparatedByString:@"<td >"];
			if ([parts count]>1)
			{
				NSString *nutrientName = [[parts objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
				NSString *nutrientUnit = [[parts objectAtIndex:2] substringWithRange:NSMakeRange(21, [[parts objectAtIndex:2] length]-28)];
				NSString *nutrientAllotmentString = [[parts objectAtIndex:3] substringWithRange:NSMakeRange(20, [[parts objectAtIndex:3] length]-27)];
				NSDecimalNumber *nutrientAllotmentQuantity = [NSDecimalNumber decimalNumberWithString:[nutrientAllotmentString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
				
				NSManagedObject *nutrient = [(Nutrition_AppDelegate *)[NSApp delegate] uniqueManagedObjectWithEntityName:@"Nutrient" keysValuesDictionary:[NSDictionary dictionaryWithObjectsAndKeys:nutrientName,@"scientificName",nutrientUnit,@"unit",nil]];
				NSManagedObject *allotment = [(Nutrition_AppDelegate *)[NSApp delegate] uniqueManagedObjectWithEntityName:@"Allotment" keysValuesDictionary:[NSDictionary dictionaryWithObjectsAndKeys:nutrient,@"nutrient",food,@"food",nil]];
				[allotment setValue:[nutrientAllotmentQuantity decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithMantissa:1 exponent:3 isNegative:NO]] forKey:@"quantity"];
			}
		}
		
		//Parse quantifiers
		NSArray *servingsStrings = [servingsHTML componentsSeparatedByString:@"<td headers=\"header3\"><font color = \"black\" size=-1>"];
		
		
		for (NSUInteger i=1; i<[servingsStrings count]; i++)
		{
			NSString *nextServingString = [servingsStrings objectAtIndex:i];
			
			NSArray *parts = [nextServingString componentsSeparatedByString:@"</font></td><td headers=\"header4\"><font color = \"black\" size=-1><center>"];
			
			NSString *name = [parts objectAtIndex:0];
			NSDecimalNumber *gramEquivalent = [NSDecimalNumber decimalNumberWithString:[[[parts objectAtIndex:1] componentsSeparatedByString:@"</center>"] objectAtIndex:0]];
			
			
			NSString *multiplierString = [[name componentsSeparatedByString:@" "] objectAtIndex:0];
			NSArray *multiplierFractionParts = [multiplierString componentsSeparatedByString:@"/"];
			NSDecimalNumber *multiplier = [NSDecimalNumber decimalNumberWithString:multiplierString];
			if ([multiplierFractionParts count]>1) multiplier = [multiplier decimalNumberByDividingBy:[multiplierFractionParts lastObject]];
			
			NSMutableArray *nameParts = [[name componentsSeparatedByString:@" "] mutableCopy];
			[nameParts removeObjectAtIndex:0];
			name = [nameParts componentsJoinedByString:@" "];
			gramEquivalent = [gramEquivalent decimalNumberByDividingBy:multiplier];
			
			NSManagedObject *quantifier = [(Nutrition_AppDelegate *)[NSApp delegate] uniqueManagedObjectWithEntityName:@"Quantifier" keysValuesDictionary:[NSDictionary dictionaryWithObjectsAndKeys:name,@"name",food,@"edible",nil]];
			[quantifier setValue:gramEquivalent forKey:@"grams"];
			if (![foodUnits containsObject:quantifier]) [foodUnits addObject:quantifier];
		}
		[self didChangeValueForKey:@"foodUnits"];
		
		[[managedObjectContext undoManager] enableUndoRegistration];
	}
}

@end
