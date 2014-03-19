#import "OCDTesterWindow.h"

@implementation OCDTesterWindow

+ (BOOL)autosavesInPlace {
	return YES;
}

- (void)windowControllerDidLoadNib:(NSWindowController *)windowController {
	[super windowControllerDidLoadNib:windowController];
	[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(windowDidResize:) name:NSWindowDidResizeNotification object:windowController.window];
}

- (void)dealloc {
	[NSNotificationCenter.defaultCenter removeObserver:self name:NSWindowDidResizeNotification object:nil];
}

- (void)windowDidResize:(NSNotification *)notification {
	self.frameTextField.stringValue = [NSString stringWithFormat:@"%.0f x %.0f", NSWidth([notification.object frame]), NSHeight([notification.object frame])];
}

- (NSString *)windowNibName {
	return @"OCDTesterWindow";
}

- (NSString *)displayName {
	return @"Compulsion Tester";
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
	if (outError)
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:nil];
	
	return YES;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
	if (outError)
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:nil];
	
	return nil;
}

@end
