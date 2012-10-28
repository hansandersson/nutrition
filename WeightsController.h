//
//  WeightsController.h
//  Nutrition
//
//  Created by Hans Andersson on 11/01/12.
//  Copyright 2011 Vigorware. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface WeightsController : NSObject <NSTextFieldDelegate> {
	IBOutlet NSTextField *kilogramsField;
	IBOutlet NSTextField *poundsField;
}

@end
