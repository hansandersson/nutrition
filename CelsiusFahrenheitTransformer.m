//
//  CelsiusFahrenheitTransformer.m
//  Nutrition
//
//  Created by Hans Andersson on 11/01/14.
//  Copyright 2011 Vigorware. All rights reserved.
//

#import "CelsiusFahrenheitTransformer.h"


@implementation CelsiusFahrenheitTransformer

+ (NSDecimalNumber *) transformationCoefficient { return [NSDecimalNumber decimalNumberWithString:@"1.8"]; }
+ (NSDecimalNumber *) transformationConstant { return [NSDecimalNumber decimalNumberWithString:@"32"]; }

@end
