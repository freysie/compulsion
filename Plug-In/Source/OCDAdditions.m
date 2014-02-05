#import "OCDAdditions.h"

const NSUInteger OCDKeyEquivalentMask = NSControlKeyMask | NSAlternateKeyMask | NSCommandKeyMask;

@implementation NSMenu (OCDAdditions)

+ (instancetype)windowMenu {
	for (NSMenuItem *item in [NSApp mainMenu].itemArray)
		if ([[item.submenu valueForKey:@"_menuName"] isEqualToString:@"NSWindowsMenu"])
			return item.submenu;
	
	return [[NSApp mainMenu] itemWithTitle:@"Window"].submenu;
}

@end

@implementation NSMenuItem (OCDAdditions)

+ (instancetype)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action keyEquivalent:(NSString *)keyEquivalent {
	NSMenuItem *item = [NSMenuItem new];
	item.title = title;
	item.target = target;
	item.action = action;
	item.keyEquivalent = keyEquivalent;
	item.keyEquivalentModifierMask = OCDKeyEquivalentMask;
	return item;
}

@end
