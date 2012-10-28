//
//  CentimetersInchesTransformer.m
//  Nutrition
//
//  Created by Hans Andersson on 11/01/14.
//  Copyright 2011 Vigorware. All rights reserved.
//

#import "CentimetersInchesTransformer.h"


@implementation CentimetersInchesTransformer

+ (NSDecimalNumber *) transformationCoefficient { return [[NSDecimalNumber one] decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"2.54"]]; }

@end
