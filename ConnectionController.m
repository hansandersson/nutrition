//
//  ConnectionController.m
//  Nutrition
//
//  Created by Hans Andersson on 11/01/12.
//  Copyright 2011 Vigorware. All rights reserved.
//

#import "ConnectionController.h"


@implementation ConnectionController

- (void) awakeFromNib
{
	[super awakeFromNib];
	[self setConnectionStatus:NO];
	[self updateStatus];
}

- (void) updateStatus:(id)sender { [self updateStatus]; }
- (void) updateStatus
{
	[retryButton setHidden:YES];
	[retryingProgressIndicator startAnimation:self];
	[[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.vigorware.net"]] delegate:self startImmediately:YES];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	[retryingProgressIndicator stopAnimation:self];
	[self setConnectionStatus:NO];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
	[retryingProgressIndicator stopAnimation:self];
	[self setConnectionStatus:YES];
}

- (void) setConnectionStatus:(BOOL)connectionStatus
{
	[statusField setStringValue:connectionStatus?@"Online":@"Offline"];
	[statusView setImage:connectionStatus?[[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ok" ofType:@"tiff"]]:[[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"warning" ofType:@"tiff"]]];
	[notConnectedField setHidden:connectionStatus];
	[retryButton setHidden:connectionStatus];
	[connectedField setHidden:!connectionStatus];
	[newAccountButton setHidden:!connectionStatus];
	[usernameField setHidden:!connectionStatus];
	[passwordField setHidden:!connectionStatus];
	[loginButton setHidden:!connectionStatus];
}

- (void) createAccount:(id)sender
{
	
}
- (void) logIn:(id)sender
{
	
}

@end
