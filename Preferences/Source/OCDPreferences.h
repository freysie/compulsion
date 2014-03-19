@import PreferencePanes;

@interface OCDPreferencePane : NSPreferencePane <NSTableViewDataSource, NSTableViewDelegate, NSOutlineViewDataSource, NSOutlineViewDelegate>

@property (weak) IBOutlet NSTextField *paddingField;

@property (weak) IBOutlet NSTableView *actionsTableView;
@property (weak) IBOutlet NSOutlineView *actionsOutlineView;
@property (weak) IBOutlet NSButton *removeActionButton;

@property (weak) IBOutlet NSOutlineView *behaviorsOutlineView;

- (IBAction)addAction:(id)sender;
- (IBAction)removeAction:(id)sender;

@end
