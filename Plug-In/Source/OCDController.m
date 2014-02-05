#import "OCDController.h"

@implementation OCDController

+ (instancetype)sharedController {
	static id sharedController;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{ sharedController = [self new]; });
	return sharedController;
}

- (instancetype)init {
	self = [super init];
	
	
	
	return self;
}

- (BOOL)validateMenuItem:(NSMenuItem *)item {
	return YES;
}

@end
