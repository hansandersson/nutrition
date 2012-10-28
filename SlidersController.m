//
//  SlidersController.m
//  Nutrition
//
//  Created by Hans Andersson on 11/01/12.
//  Copyright 2011 Vigorware. All rights reserved.
//

#import "SlidersController.h"
#import "SliderConstrained.h"

@implementation SlidersController

- (void) awakeFromNib
{
	[activity1Slider setConstrainedMaxValue:[activity1Slider maxValue]];
	[activity2Slider setConstrainedMaxValue:[activity2Slider maxValue]];
	[activity3Slider setConstrainedMaxValue:[activity3Slider maxValue]];
	[activity4Slider setConstrainedMaxValue:[activity4Slider maxValue]];
}

- (void) updateConstraints:(id)sender
{
	double hoursFilled = [activity1Slider doubleValue]+[activity2Slider doubleValue]+[activity3Slider doubleValue]+[activity4Slider doubleValue];
	double hoursRemaining = 24-hoursFilled;
	
	if (sender!=activity1Slider) [activity1Slider setConstrainedMaxValue:[activity1Slider doubleValue]+hoursRemaining];
	if (sender!=activity2Slider) [activity2Slider setConstrainedMaxValue:[activity2Slider doubleValue]+hoursRemaining];
	if (sender!=activity3Slider) [activity3Slider setConstrainedMaxValue:[activity3Slider doubleValue]+hoursRemaining];
	if (sender!=activity4Slider) [activity4Slider setConstrainedMaxValue:[activity4Slider doubleValue]+hoursRemaining];
}

@end
