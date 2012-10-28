//
//  KilogramsPoundsTransformer.m
//  Nutrition
//
//  Created by Hans Andersson on 11/01/14.
//  Copyright 2011 Vigorware. All rights reserved.
//

#import "KilogramsPoundsTransformer.h"


@implementation KilogramsPoundsTransformer

+ (NSDecimalNumber *) transformationCoefficient { return [NSDecimalNumber decimalNumberWithString:@"2.20462262"]; }

@end
