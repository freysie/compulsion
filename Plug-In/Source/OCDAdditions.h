@import Cocoa;

extern const NSUInteger OCDKeyEquivalentMask;

@interface NSApplication (OCDAdditions)

@property (readonly) NSMenu *ocd_windowMenu;

@end

@interface NSMenu (OCDAdditions)

- (NSMenuItem *)ocd_addSeparatorItem;

- (NSMenuItem *)ocd_addItemWithTitle:(NSString *)title submenu:(NSMenu *)submenu;

- (NSMenuItem *)ocd_addItemWithTitle:(NSString *)title target:(id)target action:(SEL)action keyEquivalent:(NSString *)keyEquivalent;

@end
