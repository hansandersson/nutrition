//
//  ConnectionController.h
//  Nutrition
//
//  Created by Hans Andersson on 11/01/12.
//  Copyright 2011 Vigorware. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ConnectionController : NSObject {
	IBOutlet NSImageView *statusView;
	IBOutlet NSTextField *statusField;
	IBOutlet NSTextField *connectedField;
	IBOutlet NSTextField *notConnectedField;

	IBOutlet NSButton *retryButton;
	IBOutlet NSProgressIndicator *retryingProgressIndicator;

	IBOutlet NSButton *newAccountButton;
	IBOutlet NSTextField *usernameField;
	IBOutlet NSTextField *passwordField;
	IBOutlet NSButton *loginButton;
}

- (void) updateStatus:(id)sender;
- (void) updateStatus;

- (void) setConnectionStatus:(BOOL)connectionStatus;

- (void) createAccount:(id)sender;
- (void) logIn:(id)sender;

@end
