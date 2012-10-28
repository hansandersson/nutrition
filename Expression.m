//
//  Expression.m
//  Nutrition
//
//  Created by Hans Andersson on 11/01/20.
//  Copyright 2011 Ultramentem. All rights reserved.
//

#import "Expression.h"
#import "Profile.h"
#import "Nutrition_AppDelegate.h"

@implementation Expression

+ (Expression *)expressionTreeWithStringRepresentation:(NSString *)stringRepresentation
{
	NSManagedObjectContext *managedObjectContext = [(Nutrition_AppDelegate *)[NSApp delegate] managedObjectContext];
	
	Expression *result;
	
	if ((!stringRepresentation)||[stringRepresentation isEqualToString:@""])
	{
		result = [[NSManagedObject alloc] initWithEntity:[NSEntityDescription entityForName:@"Constant" inManagedObjectContext:managedObjectContext] insertIntoManagedObjectContext:managedObjectContext]; 
		[result setValue:[NSDecimalNumber zero] forKey:@"decimalValue"];
		return result;
	}
	
	NSString *parenses = [NSString stringWithString:@"()"];
	NSString *stringWithFirstCharacter = [stringRepresentation substringToIndex:0];
	
	if ([stringWithFirstCharacter isEqualToString:@"("])
	{
		for (NSUInteger parensCount = 1, c = 1; c<[stringRepresentation length]; c++)
		{
			if ([[stringRepresentation substringWithRange:NSMakeRange(c, 1)] isEqualToString:@"("]) ++parensCount;
			else if ([[stringRepresentation substringWithRange:NSMakeRange(c, 1)] isEqualToString:@")"]) --parensCount;
			
			if (parensCount==0)
			{
				result = [self expressionTreeWithStringRepresentation:[stringRepresentation substringWithRange:NSMakeRange(1, c)]];
				
				if ((c+1)==[stringRepresentation length]) return result;
				else
				{
					Expression *left = result;
					result = [[NSManagedObject alloc] initWithEntity:[NSEntityDescription entityForName:@"Operation" inManagedObjectContext:managedObjectContext] insertIntoManagedObjectContext:managedObjectContext];
					[result setValue:left forKey:@"operandLeft"];
					
					stringRepresentation = [stringRepresentation substringFromIndex:(c+1)];
					
					if ([stringRepresentation length]>1)
					{
						stringWithFirstCharacter = [stringRepresentation substringToIndex:0];
						
						if ([stringWithFirstCharacter isEqualToString:@"*"]
							|| [stringWithFirstCharacter isEqualToString:@"+"]
							|| [stringWithFirstCharacter isEqualToString:@"/"]
							|| [stringWithFirstCharacter isEqualToString:@"-"]
							|| [stringWithFirstCharacter isEqualToString:@"^"])
						{
							[result setValue:stringWithFirstCharacter forKey:@"operator"];
							stringRepresentation = [stringRepresentation substringFromIndex:1];
							[result setValue:[self expressionTreeWithStringRepresentation:stringRepresentation] forKey:@"operandRight"];
							return result;
						}
					}
				}
				break;
			}
		}
		return nil;		
	}
	
	NSCharacterSet *letterCharacterSet = [NSCharacterSet letterCharacterSet];
	if ([letterCharacterSet characterIsMember:[stringWithFirstCharacter characterAtIndex:0]])
	{
		//continue over the course of the letters until you reach the end
		
		//depending on what follows, we build either...
		//...a variable
		//...or...
		//...an operation
	}
	
	NSCharacterSet *numeralCharacterSet = [NSCharacterSet decimalDigitCharacterSet];
	if ([stringWithFirstCharacter isEqualToString:@"-"]||[stringWithFirstCharacter isEqualToString:@"."]||[numeralCharacterSet characterIsMember:[stringWithFirstCharacter characterAtIndex:0]])
	{
		//continue over the course of the numerals until you reach the end
		
		//depending on what follows, we build either...
		//...a constant
		//...or...
		//...an operation
	}
	
	return nil;
}

- (NSString *) stringValueRelativeToProfile:(Profile *)profile
{
	if ([self valueForKey:@"decimalValue"]) return [[self valueForKey:@"decimalValue"] stringValue];
	else if ([self valueForKey:@"fieldName"]) return [self valueForKey:@"fieldName"];
	else if ([self valueForKey:@"operator"] && [self valueForKey:@"operandLeft"] && [self valueForKey:@"operandRight"]) return [NSString stringWithFormat:@"(%@%@%@)",
																																[[self valueForKey:@"operandLeft"] stringValueRelativeToProfile:profile],
																																[self valueForKey:@"operator"],
																																[[self valueForKey:@"operandRight"] stringValueRelativeToProfile:profile]];
	return nil;
}

- (NSDecimalNumber *) decimalValueRelativeToProfile:(Profile *)profile
{
	if ([self valueForKey:@"decimalValue"]) return [self valueForKey:@"decimalValue"];
	if ([self valueForKey:@"fieldName"]) return [profile valueForKey:[self valueForKey:@"fieldName"]];
	if ([self valueForKey:@"operator"] && [self valueForKey:@"operandLeft"] && [self valueForKey:@"operandRight"])
	{
		NSDecimalNumber *leftDecimalValue = [[self valueForKey:@"operandLeft"] decimalValueRelativeToProfile:profile];
		NSDecimalNumber *rightDecimalValue = [[self valueForKey:@"operandRight"] decimalValueRelativeToProfile:profile];
		if ([[self valueForKey:@"operator"] isEqualToString:@"+"]) return [leftDecimalValue decimalNumberByAdding:rightDecimalValue];
		else if ([[self valueForKey:@"operator"] isEqualToString:@"*"]) return [leftDecimalValue decimalNumberByMultiplyingBy:rightDecimalValue];
		else if ([[self valueForKey:@"operator"] isEqualToString:@"/"]) return [leftDecimalValue decimalNumberByDividingBy:rightDecimalValue];
		else if ([[self valueForKey:@"operator"] isEqualToString:@"-"]) return [leftDecimalValue decimalNumberBySubtracting:rightDecimalValue];
		else if ([[self valueForKey:@"operator"] isEqualToString:@"^"]) return [leftDecimalValue decimalNumberByRaisingToPower:[rightDecimalValue integerValue]];
	}
	return nil;
}

@end
