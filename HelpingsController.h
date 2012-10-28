//
//  HelpingsController.h
//  Nutrition
//
//  Created by Hans Andersson on 11/01/09.
//  Copyright 2011 Vigorware. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface HelpingsController : NSObject {}

- (NSManagedObject *)newHelpingForEdible:(NSManagedObject *)edible quantifier:(NSManagedObject *)quantifier quantity:(NSDecimalNumber *)quantity;

@end
