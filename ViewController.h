//
//  ViewController.h
//  Flashcards
//
//  Created by Hans Anderson on 09/07/04.
//  Copyright 2009 Vigorware Tech Studios. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ViewController : NSObject <NSTabViewDelegate, NSToolbarDelegate> {
	IBOutlet NSWindow *window;
	IBOutlet NSTabView *tabView;
	
	NSMutableDictionary *toolbarItems;
	NSArray *toolbarIdentifiers;
	
	IBOutlet id delegate;
}

@property (readonly) NSWindow *window;
@property (readonly) NSTabView *tabView;

- (IBAction)displayTab:(id)sender;

@end
