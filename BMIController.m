//
//  BMIController.m
//  Nutrition
//
//  Created by Hans Andersson on 11/01/12.
//  Copyright 2011 Vigorware. All rights reserved.
//

#import "BMIController.h"


@implementation BMIController

- (void) controlTextDidEndEditing:(NSNotification *)notification
{
	NSControl *control = [notification object];
	
	double heightMetersSquared = pow([centimetersField doubleValue]/100,2);
	
	if (control==kilogramsField || control==poundsField)
	{
		[super controlTextDidEndEditing:notification];
		
		if ([kilogramsField doubleValue]/heightMetersSquared<18.5)
		{
			[kilogramsField setDoubleValue:18.5001*heightMetersSquared];
			return (void)[self controlTextDidEndEditing:[NSNotification notificationWithName:NSControlTextDidEndEditingNotification object:kilogramsField]];
		}
		
		[indexField setDoubleValue:[kilogramsField doubleValue]/heightMetersSquared];
	}
	else
	{
		[kilogramsField setDoubleValue:[indexField doubleValue]*heightMetersSquared];
		[self controlTextDidEndEditing:[NSNotification notificationWithName:NSControlTextDidEndEditingNotification object:kilogramsField]];
	}
}

@end
