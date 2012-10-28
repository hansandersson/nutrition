//
//  SliderConstrained.h
//  Nutrition
//
//  Created by Hans Andersson on 11/01/12.
//  Copyright 2011 Vigorware. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SliderConstrained : NSSlider {
	double constrainedMaxValue;
	double constrainedMinValue;
}

@property (readwrite,assign) double constrainedMaxValue;
@property (readwrite,assign) double constrainedMinValue;

@end
