#import "OCDController.h"
#import "OCDLoader.h"

@implementation OCDLoader

+ (void)load {
	[OCDController.sharedController addMenusToWindowMenu];
}

@end
