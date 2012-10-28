//
//  WeightsController.m
//  Nutrition
//
//  Created by Hans Andersson on 11/01/12.
//  Copyright 2011 Vigorware. All rights reserved.
//

#import "WeightsController.h"


@implementation WeightsController

- (void) controlTextDidEndEditing:(NSNotification *)notification
{
	NSControl *control = [notification object];
	if (control==kilogramsField) [poundsField setDoubleValue:[kilogramsField doubleValue]*2.20462262];
	else if (control==poundsField) [kilogramsField setDoubleValue:[poundsField doubleValue]/2.20462262];
}

@end
