//
//  ViewController.m
//  Flashcards
//
//  Created by Hans Anderson on 09/07/04.
//  Copyright 2009 Vigorware Tech Studios. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

@synthesize window;
@synthesize tabView;

- (void) tabView:(NSTabView *)someTabView willSelectTabViewItem:(NSTabViewItem *)tabViewItem
{
	[[window toolbar] setSelectedItemIdentifier:[tabViewItem identifier]];
	/*if ([tabViewItem isKindOfClass:[TabViewItemDelegated class]])
	{
		TabViewItemDelegated *tabViewItemDelegated = (TabViewItemDelegated *)tabViewItem;
		if ([[tabViewItemDelegated delegate] respondsToSelector:@selector(prepareView)]) [(TabViewItemController *)[tabViewItemDelegated delegate] prepareView];
	}*/
}

- (void) awakeFromNib
{
	toolbarItems = [NSMutableDictionary dictionary];
	
	NSMutableArray *identifiers = [NSMutableArray array];
	for (NSTabViewItem *tab in [tabView tabViewItems])
	{
		NSString *identifier = [tab identifier];
		
		[identifiers addObject:identifier];
		
		NSToolbarItem *toolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:identifier];
		[toolbarItem setPaletteLabel:identifier];
		[toolbarItem setLabel:identifier];
		[toolbarItem setImage:[[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[identifier lowercaseString] ofType:@"tiff"]]];
		[toolbarItem setTarget:self];
		[toolbarItem setAction:@selector(displayTab:)];
		[toolbarItem setAutovalidates:YES];
		
		[toolbarItems setObject:toolbarItem forKey:identifier];
	}
	
	toolbarIdentifiers = [identifiers copy];
	
	NSToolbar *toolbar = [[NSToolbar alloc] initWithIdentifier:@"toolbar"];
    [toolbar setDelegate:self];  //this is how the toolbar knows what can be selected and such.
    [toolbar setAllowsUserCustomization:NO];  //this is just a pref window, so we don't need to allow customization.
    [toolbar setAutosavesConfiguration:NO];  //we just set everything up manually, so no need for this.
	
    [window setToolbar:toolbar];  //sets the toolbar to "toolbar"
	
	[toolbar setSelectedItemIdentifier:[[tabView selectedTabViewItem] identifier]];
	
	[toolbar validateVisibleItems];
}

- (BOOL) validateToolbarItem:(NSToolbarItem *)toolbarItem
{
	if (delegate && [delegate respondsToSelector:@selector(validateToolbarItem:)]) return [delegate validateToolbarItem:toolbarItem];
	return YES;
}

- (NSToolbarItem *) toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag
{
	(void)toolbar;
	(void)flag;
    return [toolbarItems objectForKey:itemIdentifier];
}

- (NSArray *) toolbarAllowedItemIdentifiers:(NSToolbar*)theToolbar
{
	(void)theToolbar;
    return [self toolbarDefaultItemIdentifiers:theToolbar];
}

- (NSArray *) toolbarDefaultItemIdentifiers:(NSToolbar*)theToolbar
{
	(void)theToolbar;
    return toolbarIdentifiers;
}

- (NSArray *) toolbarSelectableItemIdentifiers:(NSToolbar *)theToolbar
{
	(void)theToolbar;
	return toolbarIdentifiers;
}

- (void) displayTab:(id)sender
{
	[tabView selectTabViewItemWithIdentifier:[sender label]];
}

@end
