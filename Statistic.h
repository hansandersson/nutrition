//
//  Statistic.h
//  Nutrition
//
//  Created by Hans Andersson on 11/01/19.
//  Copyright 2011 Ultramentem. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Statistic : NSManagedObject {}

@property (readonly) NSDecimalNumber *decimalValueForActiveProfile;

@end
