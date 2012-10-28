//
//  Vital.h
//  Nutrition
//
//  Created by Hans Andersson on 11/01/21.
//  Copyright 2011 Ultramentem. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Statistic.h"

@interface Vital : Statistic {
	NSDecimalNumber *decimalValue;
}

@property (readwrite,copy) NSDecimalNumber *decimalValue;

@end
