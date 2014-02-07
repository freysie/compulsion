#import "OCDController.h"

@implementation OCDController

+ (instancetype)sharedController {
	static id sharedController;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{ sharedController = [self new]; });
	return sharedController;
}

- (instancetype)init {
	self = [super init];
	
	NSMenu *menu = [NSApp ocd_windowMenu];
	
	NSMenu *moveMenu = [NSMenu new]; {
		[moveMenu ocd_addItemWithTitle:@"Center" target:self action:@selector(moveWindowToCenter:) keyEquivalent:@"c"];
		
		[moveMenu ocd_addSeparatorItem];
		
		[moveMenu ocd_addItemWithTitle:@"Top Left"   target:self action:@selector(moveWindowToTopLeft:)   keyEquivalent:@"q"];
		[moveMenu ocd_addItemWithTitle:@"Top Middle" target:self action:@selector(moveWindowToTopMiddle:) keyEquivalent:@"w"];
		[moveMenu ocd_addItemWithTitle:@"Top Right"  target:self action:@selector(moveWindowToTopRight:)  keyEquivalent:@"e"];
		
		[moveMenu ocd_addSeparatorItem];
		
		[moveMenu ocd_addItemWithTitle:@"Bottom Left"   target:self action:@selector(moveWindowToBottomLeft:)   keyEquivalent:@"z"];
		[moveMenu ocd_addItemWithTitle:@"Bottom Middle" target:self action:@selector(moveWindowToBottomMiddle:) keyEquivalent:@"x"];
		[moveMenu ocd_addItemWithTitle:@"Bottom Right"  target:self action:@selector(moveWindowToBottomRight:)  keyEquivalent:@"v"];
	}
	
	[menu ocd_addItemWithTitle:@"Move to" submenu:moveMenu];
	
	NSMenu *resizeMenu = [NSMenu new]; {
		[resizeMenu ocd_addItemWithTitle:@"½ Width" target:self action:@selector(resizeWindowToHalfWidth:) keyEquivalent:@"2"];
		
		[resizeMenu ocd_addSeparatorItem];
		
		[resizeMenu ocd_addItemWithTitle:@"Full Height" target:self action:@selector(resizeWindowToHalfWidth:) keyEquivalent:@"2"];
	}
	
	[menu ocd_addItemWithTitle:@"Resize to" submenu:resizeMenu];
	
	[menu ocd_addSeparatorItem];
	
	[menu ocd_addItemWithTitle:@"Desktop Level"  target:self action:@selector(toggleWindowDesktopLevel:)  keyEquivalent:@"d"];
	[menu ocd_addItemWithTitle:@"Floating Level" target:self action:@selector(toggleWindowFloatingLevel:) keyEquivalent:@"f"];
	
	[menu ocd_addSeparatorItem];
	
	[menu ocd_addItemWithTitle:@"Can Join All Spaces" target:self action:@selector(toggleWindowCanJoinAllSpacesCollectionBehavior:) keyEquivalent:@"s"];
	
	return self;
}

- (BOOL)validateMenuItem:(NSMenuItem *)item {
	NSWindow *window = [NSApp keyWindow];
	
	if (!window)
		return NO;
	
	if (item.action == @selector(toggleWindowDesktopLevel:))
		item.state = window.level == kCGDesktopWindowLevel;
	
	if (item.action == @selector(toggleWindowFloatingLevel:))
		item.state = window.level == kCGFloatingWindowLevel;
	
	if (item.action == @selector(toggleWindowCanJoinAllSpacesCollectionBehavior:))
		item.state = window.collectionBehavior == NSWindowCollectionBehaviorCanJoinAllSpaces;
	
	return YES;
}

#pragma mark -

- (void)moveWindowToCenter:(id)sender {
	[[NSApp keyWindow] center];
}

- (void)moveWindowToTopLeft:(id)sender {
	
}

- (void)moveWindowToTopMiddle:(id)sender {
	
}

- (void)moveWindowToTopRight:(id)sender {
	
}

- (void)moveWindowToBottomLeft:(id)sender {
	
}

- (void)moveWindowToBottomMiddle:(id)sender {
	
}

- (void)moveWindowToBottomRight:(id)sender {
	
}

#pragma mark -

- (void)resizeWindowToHalfWidth:(id)sender {
	
}

#pragma mark -

- (void)toggleWindowDesktopLevel:(id)sender {
	NSWindow *window = [NSApp keyWindow];

	if (window.level != kCGDesktopWindowLevel)
		window.level = kCGDesktopWindowLevel;
	else
		window.level = kCGNormalWindowLevel;
}

- (void)toggleWindowFloatingLevel:(id)sender {
	NSWindow *window = [NSApp keyWindow];
	
	if (window.level != kCGFloatingWindowLevel)
		window.level = kCGFloatingWindowLevel;
	else
		window.level = kCGNormalWindowLevel;
}

#pragma mark -

- (void)toggleWindowCanJoinAllSpacesCollectionBehavior:(id)sender {
	NSWindow *window = [NSApp keyWindow];
	
	if (window.collectionBehavior != NSWindowCollectionBehaviorCanJoinAllSpaces)
		window.collectionBehavior = NSWindowCollectionBehaviorCanJoinAllSpaces;
	else
		window.collectionBehavior = NSWindowCollectionBehaviorDefault;
}

@end
