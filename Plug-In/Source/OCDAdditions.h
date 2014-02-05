@import Cocoa;

extern const NSUInteger OCDKeyEquivalentMask;

@interface NSApplication (OCDAdditions)

+ (instancetype)windowMenu;

@end

@interface NSMenuItem (OCDAdditions)

+ (instancetype)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action keyEquivalent:(NSString *)keyEquivalent;

@end
