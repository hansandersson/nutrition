//
//  ReportsCollectionViewItem.m
//  Nutrition
//
//  Created by Hans Andersson on 11/01/15.
//  Copyright 2011 Ultramentem. All rights reserved.
//

#import "ReportsCollectionViewItem.h"


@implementation ReportsCollectionViewItem

- (void) getMoreInformation:(id)sender
{
	[[[NSAppleScript alloc] initWithSource:[NSString stringWithFormat:@"open location \"%@\" without error reporting",[[self representedObject] valueForKey:@"source"]]] executeAndReturnError:nil];
}

@end
