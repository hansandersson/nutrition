//
//  Statistic.m
//  Nutrition
//
//  Created by Hans Andersson on 11/01/19.
//  Copyright 2011 Ultramentem. All rights reserved.
//

#import "Statistic.h"
#import "Nutrition_AppDelegate.h"
#import "Expression.h"
#import "Profile.h"

@implementation Statistic

- (NSDecimalNumber *) decimalValueForActiveProfile
{
	Profile *activeProfile = [(Nutrition_AppDelegate *)[NSApp delegate] activeProfile];
	if ([[[self entity] name] isEqualToString:@"Field"]) return [activeProfile valueForKey:[self valueForKey:@"name"]];
	if ([[[self entity] name] isEqualToString:@"Index"]) return [(Expression *)[self valueForKey:@"expression"] decimalValueRelativeToProfile:activeProfile];
	return nil;
}

@end
