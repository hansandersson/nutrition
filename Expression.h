//
//  Expression.h
//  Nutrition
//
//  Created by Hans Andersson on 11/01/20.
//  Copyright 2011 Ultramentem. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Profile;

@interface Expression : NSObject {}

+ (Expression *)expressionTreeWithStringRepresentation:(NSString *)stringRepresentation;

- (NSString *) stringValueRelativeToProfile:(Profile *)profile;
- (NSDecimalNumber *) decimalValueRelativeToProfile:(Profile *)profile;

@end
