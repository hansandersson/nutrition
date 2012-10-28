//
//  Measurement.m
//  Nutrition
//
//  Created by Hans Andersson on 11/01/14.
//  Copyright 2011 Vigorware. All rights reserved.
//

#import "Measurement.h"


@implementation Measurement

- (void) setValue:(id)value forKey:(NSString *)key
{
	BOOL valueIsChanging = [key isEqualToString:@"value"];
	if (valueIsChanging) [[self valueForKey:@"profile"] willChangeValueForKey:[self valueForKeyPath:@"field.name"]];
	[super setValue:value forKey:key];
	if (valueIsChanging) [[self valueForKey:@"profile"] didChangeValueForKey:[self valueForKeyPath:@"field.name"]];
}

@end
