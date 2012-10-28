//
//  BMIController.h
//  Nutrition
//
//  Created by Hans Andersson on 11/01/12.
//  Copyright 2011 Vigorware. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "WeightsController.h"

@interface BMIController : WeightsController {
	IBOutlet NSTextField *centimetersField;
	IBOutlet NSTextField *indexField;
}

@end
