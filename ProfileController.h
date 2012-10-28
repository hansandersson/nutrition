//
//  ProfileController.h
//  Nutrition
//
//  Created by Hans Andersson on 11/01/11.
//  Copyright 2011 Vigorware. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ProfileController : NSObject <NSTextFieldDelegate> {
	IBOutlet NSArrayController *profilesArrayController;
}

@end
