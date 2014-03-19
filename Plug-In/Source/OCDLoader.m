#import "OCDController.h"
#import "OCDLoader.h"

@implementation OCDLoader

+ (void)load {
//	OCDApp = NSApp;
	
	[OCDController.sharedController addMenusToWindowMenu];
}

@end
