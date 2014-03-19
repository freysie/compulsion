#import "OCDController.h"

@implementation OCDController

+ (instancetype)sharedController {
	static id sharedController;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{ sharedController = [self new]; });
	return sharedController;
}

- (void)addMenusToWindowMenu {
	NSMenu *menu = [NSMenu new];
	
	[menu ocd_addItemWithTitle:@"Move" target:nil action:nil keyEquivalent:@""];
	
	[menu ocd_addItemWithTitle:@"Move to Center" target:self action:@selector(moveWindowToCenter) keyEquivalent:@"c"];
	
	[menu ocd_addSeparatorItem];
	
	[menu ocd_addItemWithTitle:@"Move to Top Left"   target:self action:@selector(moveWindowToTopLeft)   keyEquivalent:@"q"];
	[menu ocd_addItemWithTitle:@"Move to Top Center" target:self action:@selector(moveWindowToTopMiddle) keyEquivalent:@"w"];
	[menu ocd_addItemWithTitle:@"Move to Top Right"  target:self action:@selector(moveWindowToTopRight)  keyEquivalent:@"e"];
	
	[menu ocd_addSeparatorItem];
	
	[menu ocd_addItemWithTitle:@"Move to Bottom Left"   target:self action:@selector(moveWindowToBottomLeft)   keyEquivalent:@"z"];
	[menu ocd_addItemWithTitle:@"Move to Bottom Center" target:self action:@selector(moveWindowToBottomMiddle) keyEquivalent:@"x"];
	[menu ocd_addItemWithTitle:@"Move to Bottom Right"  target:self action:@selector(moveWindowToBottomRight)  keyEquivalent:@"v"];
	
	[menu ocd_addSeparatorItem];
	
	[menu ocd_addItemWithTitle:[NSString stringWithFormat:@"Move %.0f pt Up",    self.nudgeGranularity] target:self action:@selector(moveWindowSlightlyUp)    keyEquivalent:@"↑"];
	[menu ocd_addItemWithTitle:[NSString stringWithFormat:@"Move %.0f pt Right", self.nudgeGranularity] target:self action:@selector(moveWindowSlightlyRight) keyEquivalent:@"→"];
	[menu ocd_addItemWithTitle:[NSString stringWithFormat:@"Move %.0f pt Down",  self.nudgeGranularity] target:self action:@selector(moveWindowSlightlyDown)  keyEquivalent:@"↓"];
	[menu ocd_addItemWithTitle:[NSString stringWithFormat:@"Move %.0f pt Left",  self.nudgeGranularity] target:self action:@selector(moveWindowSlightlyLeft)  keyEquivalent:@"←"];
	
	[menu ocd_addSeparatorItem];
	
	[menu ocd_addItemWithTitle:@"Resize to Screen Size"   target:self action:@selector(resizeWindowToScreenSize)   keyEquivalent:@"m"];
	[menu ocd_addItemWithTitle:@"Resize to Screen Width"  target:self action:@selector(resizeWindowToScreenWidth)  keyEquivalent:@"j"];
	[menu ocd_addItemWithTitle:@"Resize to Screen Height" target:self action:@selector(resizeWindowToScreenHeight) keyEquivalent:@"h"];
	
	[menu ocd_addSeparatorItem];
	
	[menu ocd_addItemWithTitle:@"Resize to ⅔ Screen Width" target:self action:@selector(resizeWindowToTwoThirdsOfScreenWidth)   keyEquivalent:@"1"];
	[menu ocd_addItemWithTitle:@"Resize to ½ Screen Width" target:self action:@selector(resizeWindowToOneHalfOfScreenWidth)     keyEquivalent:@"2"];
	[menu ocd_addItemWithTitle:@"Resize to ⅓ Screen Width" target:self action:@selector(resizeWindowToOneThirdOfScreenWidth)    keyEquivalent:@"3"];
	[menu ocd_addItemWithTitle:@"Resize to ¼ Screen Width" target:self action:@selector(resizeWindowToOneQuarterOfScreenWidth)  keyEquivalent:@"4"];
	[menu ocd_addItemWithTitle:@"Resize to ⅕ Screen Width" target:self action:@selector(resizeWindowToOneFifthOfScreenWidth)    keyEquivalent:@"5"];
	[menu ocd_addItemWithTitle:@"Resize to ⅙ Screen Width" target:self action:@selector(resizeWindowToOneSixthOfScreenWidth)    keyEquivalent:@"6"];
	[menu ocd_addItemWithTitle:@"Resize to ⅜ Screen Width" target:self action:@selector(resizeWindowToThreeEightsOfScreenWidth) keyEquivalent:@"7"];
	[menu ocd_addItemWithTitle:@"Resize to ⅛ Screen Width" target:self action:@selector(resizeWindowToOneEightOfScreenWidth)    keyEquivalent:@"8"];
	[menu ocd_addItemWithTitle:@"Resize to ⅝ Screen Width" target:self action:@selector(resizeWindowToFiveEightsOfScreenWidth)  keyEquivalent:@"9"];
	
	[menu ocd_addSeparatorItem];
	
	[menu ocd_addItemWithTitle:@"Desktop Level"  target:self action:@selector(toggleWindowDesktopLevel)  keyEquivalent:@"d"];
	[menu ocd_addItemWithTitle:@"Floating Level" target:self action:@selector(toggleWindowFloatingLevel) keyEquivalent:@"f"];
	
	[menu ocd_addSeparatorItem];
	
	[menu ocd_addItemWithTitle:@"Joins All Spaces" target:self action:@selector(toggleWindowCanJoinAllSpacesCollectionBehavior) keyEquivalent:@"s"];
	
	[[NSApp ocd_windowMenu] ocd_insertItemWithTitle:@"Compulsion" submenu:menu atIndex:0];
	
//	[NSEvent addLocalMonitorForEventsMatchingMask:NSEventMaskSwipe | NSEventMaskBeginGesture | NSEventMaskGesture | NSEventMaskEndGesture handler:^(NSEvent *event) {
//		if ((event.modifierFlags & OCDKeyEquivalentMask) != OCDKeyEquivalentMask)
//			return event;
//		
//		switch (event.type) {
//			case NSEventTypeSwipe:
//				NSLog(@"Swipe occurred! x = %f, y = %f", event.deltaX, event.deltaY);
//				break;
//		}
//		
//		return event;
//	}];
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

#pragma mark - Move

- (void)moveWindowToCenter {
	NSWindow *window = [NSApp keyWindow];
	NSRect oldFrame = window.frame;
	[window center];
	NSRect newFrame = window.frame;
	[window setFrame:oldFrame display:NO];
	[window setFrame:newFrame display:YES animate:YES];
}

- (void)moveWindowToTopLeft {
	NSWindow *window = [NSApp keyWindow];
	NSScreen *screen = window.screen;
	
	[window setFrame:NSMakeRect(self.edgeMargin,
	                            NSHeight(screen.frame) - self.edgeMargin - self.statusBarHeight - NSHeight(window.frame),
	                            NSWidth(window.frame), NSHeight(window.frame)) display:YES animate:YES];
}

- (void)moveWindowToTopMiddle {
	NSWindow *window = [NSApp keyWindow];
	NSScreen *screen = window.screen;
	
	[window setFrame:NSMakeRect(NSWidth(screen.visibleFrame) / 2 - NSWidth(window.frame) / 2,
	                            NSHeight(screen.frame) - self.edgeMargin - self.statusBarHeight - NSHeight(window.frame),
	                            NSWidth(window.frame), NSHeight(window.frame)) display:YES animate:YES];
}

- (void)moveWindowToTopRight {
	NSWindow *window = [NSApp keyWindow];
	NSScreen *screen = window.screen;
	
	[window setFrame:NSMakeRect(NSWidth(screen.visibleFrame) - NSWidth(window.frame) - self.edgeMargin,
	                            NSHeight(screen.frame) - self.edgeMargin - self.statusBarHeight - NSHeight(window.frame),
	                            NSWidth(window.frame), NSHeight(window.frame)) display:YES animate:YES];
}

- (void)moveWindowToBottomLeft {
	NSWindow *window = [NSApp keyWindow];
	
	[window setFrame:NSMakeRect(self.edgeMargin, self.edgeMargin,
	                            NSWidth(window.frame), NSHeight(window.frame)) display:YES animate:YES];
}

- (void)moveWindowToBottomMiddle {
	NSWindow *window = [NSApp keyWindow];
	NSScreen *screen = window.screen;
	
	[window setFrame:NSMakeRect(NSWidth(screen.visibleFrame) / 2 - NSWidth(window.frame) / 2, self.edgeMargin,
	                            NSWidth(window.frame), NSHeight(window.frame)) display:YES animate:YES];
}

- (void)moveWindowToBottomRight {
	NSWindow *window = [NSApp keyWindow];
	NSScreen *screen = window.screen;
	
	[window setFrame:NSMakeRect(NSWidth(screen.visibleFrame) - NSWidth(window.frame) - self.edgeMargin, self.edgeMargin,
	                            NSWidth(window.frame), NSHeight(window.frame)) display:YES animate:YES];
}

- (void)moveWindowSlightlyUp    { NSWindow *window = [NSApp keyWindow]; [window setFrame:NSOffsetRect(window.frame, 0, +self.nudgeGranularity) display:YES animate:YES]; }
- (void)moveWindowSlightlyRight { NSWindow *window = [NSApp keyWindow]; [window setFrame:NSOffsetRect(window.frame, +self.nudgeGranularity, 0) display:YES animate:YES]; }
- (void)moveWindowSlightlyDown  { NSWindow *window = [NSApp keyWindow]; [window setFrame:NSOffsetRect(window.frame, 0, -self.nudgeGranularity) display:YES animate:YES]; }
- (void)moveWindowSlightlyLeft  { NSWindow *window = [NSApp keyWindow]; [window setFrame:NSOffsetRect(window.frame, -self.nudgeGranularity, 0) display:YES animate:YES]; }

#pragma mark - Resize

- (void)resizeWindowToScreenSize {
	NSWindow *window = [NSApp keyWindow];
	NSScreen *screen = window.screen;
	
	[window setFrame:NSInsetRect(screen.visibleFrame, self.edgeMargin, self.edgeMargin) display:YES animate:YES];
}

- (void)resizeWindowToScreenWidth {
//	NSWindow *window = [NSApp keyWindow];
//	NSScreen *screen = window.screen;
//	
//	[window setFrame:NSMakeRect(NSWidth(screen.visibleFrame) - NSWidth(window.frame) - self.edgeMargin,
//	                            NSHeight(screen.visibleFrame) - self.edgeMargin - self.statusBarHeight - NSHeight(window.frame),
//	                            NSWidth(window.frame), NSHeight(window.frame)) display:YES animate:YES];
}

- (void)resizeWindowToScreenHeight {
	NSWindow *window = [NSApp keyWindow];
	NSScreen *screen = window.screen;
	
	[window setFrame:NSMakeRect(NSMinX(window.frame), NSMinY(screen.visibleFrame) + self.edgeMargin,
	                            NSWidth(window.frame), NSHeight(screen.visibleFrame) - self.edgeMargin * 2) display:YES animate:YES];
}

- (void)resizeWindowToFractionOfScreenWidth:(CGFloat)fraction {
	NSWindow *window = [NSApp keyWindow];
	NSScreen *screen = window.screen;
	
	CGFloat width = NSWidth(screen.visibleFrame) / fraction - self.edgeMargin * 1.5;
	CGFloat x = NSMinX(window.frame);
	
	if (NSMidX(window.frame) > NSWidth(screen.visibleFrame) / 2)
		x -= width - NSWidth(window.frame); // Rezize to the left if on the right side of the screen.
	
	[window setFrame:NSMakeRect(x, NSMinY(window.frame), width, NSHeight(window.frame)) display:YES animate:YES];
}

- (void)resizeWindowToTwoThirdsOfScreenWidth   { [self resizeWindowToFractionOfScreenWidth:1.50]; }
- (void)resizeWindowToOneHalfOfScreenWidth     { [self resizeWindowToFractionOfScreenWidth:2.00]; }
- (void)resizeWindowToOneThirdOfScreenWidth    { [self resizeWindowToFractionOfScreenWidth:3.00]; }
- (void)resizeWindowToOneQuarterOfScreenWidth  { [self resizeWindowToFractionOfScreenWidth:4.00]; }
- (void)resizeWindowToOneFifthOfScreenWidth    { [self resizeWindowToFractionOfScreenWidth:5.00]; }
- (void)resizeWindowToOneSixthOfScreenWidth    { [self resizeWindowToFractionOfScreenWidth:6.00]; }
- (void)resizeWindowToThreeEightsOfScreenWidth { [self resizeWindowToFractionOfScreenWidth:.375]; }
- (void)resizeWindowToOneEightOfScreenWidth    { [self resizeWindowToFractionOfScreenWidth:8.00]; }
- (void)resizeWindowToFiveEightsOfScreenWidth  { [self resizeWindowToFractionOfScreenWidth:.625]; }

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
