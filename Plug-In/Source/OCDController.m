#import "OCDController.h"

@implementation OCDController

+ (instancetype)sharedController {
	static id sharedController;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{ sharedController = [self new]; });
	return sharedController;
}

- (void)addMenusToWindowMenu {
	NSMenu *menu = [NSApp ocd_windowMenu];
	
	[menu ocd_addSeparatorItem];
	
	NSMenu *moveMenu = [NSMenu new]; {
		[moveMenu ocd_addItemWithTitle:@"Center" target:self action:@selector(moveWindowToCenter) keyEquivalent:@"c"];
		
		[moveMenu ocd_addSeparatorItem];
		
		[moveMenu ocd_addItemWithTitle:@"Top Left"   target:self action:@selector(moveWindowToTopLeft)   keyEquivalent:@"q"];
		[moveMenu ocd_addItemWithTitle:@"Top Center" target:self action:@selector(moveWindowToTopMiddle) keyEquivalent:@"w"];
		[moveMenu ocd_addItemWithTitle:@"Top Right"  target:self action:@selector(moveWindowToTopRight)  keyEquivalent:@"e"];
		
		[moveMenu ocd_addSeparatorItem];
		
		[moveMenu ocd_addItemWithTitle:@"Bottom Left"   target:self action:@selector(moveWindowToBottomLeft)   keyEquivalent:@"z"];
		[moveMenu ocd_addItemWithTitle:@"Bottom Center" target:self action:@selector(moveWindowToBottomMiddle) keyEquivalent:@"x"];
		[moveMenu ocd_addItemWithTitle:@"Bottom Right"  target:self action:@selector(moveWindowToBottomRight)  keyEquivalent:@"v"];
		
		[moveMenu ocd_addSeparatorItem];
		
		[moveMenu ocd_addItemWithTitle:[NSString stringWithFormat:@"%.0f pt Up",    self.nudgeGranularity] target:self action:@selector(moveWindowSlightlyUp)    keyEquivalent:@"↑"];
		[moveMenu ocd_addItemWithTitle:[NSString stringWithFormat:@"%.0f pt Right", self.nudgeGranularity] target:self action:@selector(moveWindowSlightlyRight) keyEquivalent:@"→"];
		[moveMenu ocd_addItemWithTitle:[NSString stringWithFormat:@"%.0f pt Down",  self.nudgeGranularity] target:self action:@selector(moveWindowSlightlyDown)  keyEquivalent:@"↓"];
		[moveMenu ocd_addItemWithTitle:[NSString stringWithFormat:@"%.0f pt Left",  self.nudgeGranularity] target:self action:@selector(moveWindowSlightlyLeft)  keyEquivalent:@"←"];
	}
	
	[menu ocd_addItemWithTitle:@"Move to" submenu:moveMenu];
	
	NSMenu *resizeMenu = [NSMenu new]; {
		[resizeMenu ocd_addItemWithTitle:@"Screen Size" target:self action:@selector(resizeWindowToScreenSize) keyEquivalent:@"m"];
		[resizeMenu ocd_addItemWithTitle:@"Screen Width" target:self action:@selector(resizeWindowToScreenWidth) keyEquivalent:@"j"];
		[resizeMenu ocd_addItemWithTitle:@"Screen Height" target:self action:@selector(resizeWindowToScreenHeight) keyEquivalent:@"h"];
		
		[resizeMenu ocd_addSeparatorItem];
		
		[resizeMenu ocd_addItemWithTitle:@"½ Screen Width" target:self action:@selector(resizeWindowToHalfOfScreenWidth) keyEquivalent:@"2"];
	}
	
	[menu ocd_addItemWithTitle:@"Resize to" submenu:resizeMenu];
	
	[menu ocd_addSeparatorItem];
	
	[menu ocd_addItemWithTitle:@"Desktop Level"  target:self action:@selector(toggleWindowDesktopLevel)  keyEquivalent:@"d"];
	[menu ocd_addItemWithTitle:@"Floating Level" target:self action:@selector(toggleWindowFloatingLevel) keyEquivalent:@"f"];
	
	[menu ocd_addSeparatorItem];
	
	[menu ocd_addItemWithTitle:@"Joins All Spaces" target:self action:@selector(toggleWindowCanJoinAllSpacesCollectionBehavior) keyEquivalent:@"s"];
}

- (BOOL)validateMenuItem:(NSMenuItem *)item {
	NSWindow *window = [NSApp keyWindow];
	
	if (!window)
		return NO;
	
	if (item.action == @selector(toggleWindowDesktopLevel))
		item.state = window.level == kCGDesktopWindowLevel;
	
	if (item.action == @selector(toggleWindowFloatingLevel))
		item.state = window.level == kCGFloatingWindowLevel;
	
	if (item.action == @selector(toggleWindowCanJoinAllSpacesCollectionBehavior))
		item.state = window.collectionBehavior == NSWindowCollectionBehaviorCanJoinAllSpaces;
	
	return YES;
}

#pragma mark -

- (CGFloat)edgeMargin {
	return 10;
}

- (CGFloat)nudgeGranularity {
	return 25;
}

- (CGFloat)statusBarHeight {
	return NSStatusBar.systemStatusBar.thickness;
}

#pragma mark -

- (void)moveWindowToCenter {
	[[NSApp keyWindow] center];
}

- (void)moveWindowToTopLeft {
	NSWindow *window = [NSApp keyWindow];
	NSScreen *screen = window.screen;
	
	[window setFrame:NSMakeRect(self.edgeMargin,
	                            screen.visibleFrame.size.height - self.edgeMargin - self.statusBarHeight - window.frame.size.height,
	                            window.frame.size.width, window.frame.size.height) display:YES animate:YES];
}

- (void)moveWindowToTopMiddle {
	NSWindow *window = [NSApp keyWindow];
	NSScreen *screen = window.screen;
	
	[window setFrame:NSMakeRect(screen.visibleFrame.size.width / 2 - window.frame.size.width / 2,
	                            screen.visibleFrame.size.height - self.edgeMargin - self.statusBarHeight - window.frame.size.height,
	                            window.frame.size.width, window.frame.size.height) display:YES animate:YES];
}

- (void)moveWindowToTopRight {
	NSWindow *window = [NSApp keyWindow];
	NSScreen *screen = window.screen;
	
	[window setFrame:NSMakeRect(screen.visibleFrame.size.width - window.frame.size.width - self.edgeMargin,
	                            screen.visibleFrame.size.height - self.edgeMargin - self.statusBarHeight - window.frame.size.height,
	                            window.frame.size.width, window.frame.size.height) display:YES animate:YES];
}

- (void)moveWindowToBottomLeft {
	
}

- (void)moveWindowToBottomMiddle {
	
}

- (void)moveWindowToBottomRight {
	
}

- (void)moveWindowSlightlyUp {
	
}

- (void)moveWindowSlightlyRight {
	
}

- (void)moveWindowSlightlyDown {
	
}

- (void)moveWindowSlightlyLeft {
	
}

#pragma mark -

- (void)resizeWindowToScreenSize {
	NSWindow *window = [NSApp keyWindow];
	NSScreen *screen = window.screen;
	
	[window setFrame:NSRectFromCGRect(CGRectInset(NSRectToCGRect(screen.visibleFrame), self.edgeMargin, self.edgeMargin)) display:YES animate:YES];
}

- (void)resizeWindowToScreenWidth {
//	NSWindow *window = [NSApp keyWindow];
//	NSScreen *screen = window.screen;
//	
//	[window setFrame:NSMakeRect(screen.visibleFrame.size.width - window.frame.size.width - self.edgeMargin,
//	                            screen.visibleFrame.size.height - self.edgeMargin - self.statusBarHeight - window.frame.size.height,
//	                            window.frame.size.width, window.frame.size.height) display:YES animate:YES];
}

- (void)resizeWindowToScreenHeight {
//	NSWindow *window = [NSApp keyWindow];
//	NSScreen *screen = window.screen;
//	
//	[window setFrame:NSMakeRect(screen.visibleFrame.size.width - window.frame.size.width - self.edgeMargin,
//	                            screen.visibleFrame.size.height - self.edgeMargin - self.statusBarHeight - window.frame.size.height,
//	                            window.frame.size.width, window.frame.size.height) display:YES animate:YES];
}

- (void)resizeWindowToHalfOfScreenWidth {
	
}

#pragma mark -

- (void)toggleWindowDesktopLevel {
	NSWindow *window = [NSApp keyWindow];

	if (window.level != kCGDesktopWindowLevel)
		window.level = kCGDesktopWindowLevel;
	else
		window.level = kCGNormalWindowLevel;
}

- (void)toggleWindowFloatingLevel {
	NSWindow *window = [NSApp keyWindow];
	
	if (window.level != kCGFloatingWindowLevel)
		window.level = kCGFloatingWindowLevel;
	else
		window.level = kCGNormalWindowLevel;
}

#pragma mark -

- (void)toggleWindowCanJoinAllSpacesCollectionBehavior {
	NSWindow *window = [NSApp keyWindow];
	
	if (window.collectionBehavior != NSWindowCollectionBehaviorCanJoinAllSpaces)
		window.collectionBehavior = NSWindowCollectionBehaviorCanJoinAllSpaces;
	else
		window.collectionBehavior = NSWindowCollectionBehaviorDefault;
}

@end
