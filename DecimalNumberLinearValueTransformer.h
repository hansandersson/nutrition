//
//  DecimalNumberLinearValueTransformer.h
//  Nutrition
//
//  Created by Hans Andersson on 11/01/14.
//  Copyright 2011 Vigorware. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface DecimalNumberLinearValueTransformer : NSValueTransformer {}

+ (NSDecimalNumber *) transformationCoefficient;
+ (NSDecimalNumber *) transformationConstant;

@end
