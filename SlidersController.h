//
//  SlidersController.h
//  Nutrition
//
//  Created by Hans Andersson on 11/01/12.
//  Copyright 2011 Vigorware. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SliderConstrained;

@interface SlidersController : NSObject {
	IBOutlet SliderConstrained *activity1Slider;
	IBOutlet SliderConstrained *activity2Slider;
	IBOutlet SliderConstrained *activity3Slider;
	IBOutlet SliderConstrained *activity4Slider;
	
	IBOutlet NSTextField *activity1Field;
	IBOutlet NSTextField *activity2Field;
	IBOutlet NSTextField *activity3Field;
	IBOutlet NSTextField *activity4Field;
}

- (void) updateConstraints:(id)sender;

@end
