#import "OCDPreferences.h"

@interface OCDPreferencePane ()

@property (nonatomic, strong) NSMutableDictionary *actions;
@property (nonatomic, strong) NSMutableDictionary *behaviors;

@end

@implementation OCDPreferencePane

+ (NSImage *)imageNamed:(NSString *)name {
	return [[NSImage alloc] initWithContentsOfFile:[[NSBundle bundleWithIdentifier:@"local.preferences.Compulsion"] pathForImageResource:name]];
}

- (instancetype)initWithBundle:(NSBundle *)bundle {
	self = [super initWithBundle:bundle];
	
	self.behaviors = @{
			@"Messages": @[
				@{
					    @"enabled": @YES,
					      @"title": @"Tile conversation windows",
					@"elaboration": @"Arranges the current chat windows horizontally across the screne like a collection."
				}
			],
			
			@"Safari": @[
				@{
					    @"enabled": @YES,
					      @"title": @"Resize after changing bars",
					@"elaboration": @"Resets the height after tab, bookmark or status bar visibility have changed."
				}
			],
			
			@"Terminal": @[
				@{
					    @"enabled": @YES,
					      @"title": @"Resize in increments of character size",
					@"elaboration": @"Always uses increments of the size of a terminal character when resizing windows."
				}
			]
		}.mutableCopy;
	
	return self;
}

- (void)mainViewDidLoad {
	
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
	return 3;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	if ([tableColumn.identifier isEqualToString:@"Icon"])
		if (row == 0) {
			return [self.class imageNamed:@"CompulsionPreferences"];
		} else if (row == 2) {
			return [NSImage imageNamed:@"NSFolderSmart"];
		} else {
			return [NSImage imageNamed:@"NSFolder"];
		}
	else if ([tableColumn.identifier isEqualToString:@"Title"])
		if (row == 0) {
			return @"Defaults";
		} else {
			return @"Untitled";
		}
	else
		return nil;
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row {
	NSLog(@"Selecting %li", (long)row);
	return YES;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
	// TODO: Use this instead of the above, I guess.
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
	if (outlineView == self.actionsOutlineView)
		return 5;
	else if (outlineView == self.behaviorsOutlineView)
		return item ? [self.behaviors[item] count] : self.behaviors.count;
	else
		return 0;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
	if (outlineView == self.actionsOutlineView) {
		return @"durp";
	} else {
		NSLog(@"behaviors = %@", self.behaviors);
		NSLog(@"index = %li", (long)index);
		NSLog(@"item = %@", item);
		return item ? self.behaviors[item][index - 1] : self.behaviors.allKeys[index - 1];
	}
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
	if (outlineView == self.actionsOutlineView)
		return NO;
	else if (outlineView == self.behaviorsOutlineView)
		return ![item isKindOfClass:NSDictionary.class];
	else
		return NO;
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
	if (outlineView == self.actionsOutlineView) {
		if ([tableColumn.identifier isEqualToString:@"Enabled"])
			return @0;
		else if ([tableColumn.identifier isEqualToString:@"Title"])
			return @"Joins All Spaces";
		else if ([tableColumn.identifier isEqualToString:@"KeyShortcut"])
			return @"⌃⌥⌘J";
		else {
			NSLog(@"AAAAA %@ %@ %@", outlineView, tableColumn, item);
			return nil;
		}
	} else if (outlineView == self.behaviorsOutlineView) {
		if ([tableColumn.identifier isEqualToString:@"Enabled"])
			return @0;
		else if ([tableColumn.identifier isEqualToString:@"Icon"])
			return [[NSWorkspace sharedWorkspace] iconForFile:@"/Applications/Safari.app"];
		else if ([tableColumn.identifier isEqualToString:@"Title"])
			return ![item isKindOfClass:NSDictionary.class] ? item : item[@"title"];
	}
	
	return nil;
}

- (void)outlineViewSelectionDidChange:(NSNotification *)notification {
	NSLog(@"%@", notification.userInfo);
	
	if (notification.object == self.actionsOutlineView) {
		self.removeActionButton.enabled = !![notification.object selectedRowIndexes].count;
	}
}

- (IBAction)addAction:(id)sender {
	
}

- (IBAction)removeAction:(id)sender {
	
}

@end
