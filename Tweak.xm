#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


@interface SBFolder : NSObject
- (NSMutableArray *)lists;
- (unsigned int)listCount;
@end

@interface SBRootFolder : SBFolder
@end

@interface SBIconListModel : NSObject
- (id)initWithFolder:(id)folder;
- (BOOL)isEmpty;
@end

@interface SBIconController : NSObject {
	SBRootFolder *_rootFolder;
}
@end

@interface SBIconController (NEW)
- (SBRootFolder *)rootFolder;
@end



%hook SBIconController

%new
- (SBRootFolder *)rootFolder {
	return MSHookIvar<SBRootFolder *>(self, "_rootFolder");
}

- (void)resetRootIconLists {
	if (self.rootFolder.listCount > 0) {
		SBIconListModel *temp = [self.rootFolder.lists objectAtIndex:0];
		if (![temp isEmpty]) {
			SBIconListModel *model = [[%c(SBIconListModel) alloc] initWithFolder:self.rootFolder];
			[self.rootFolder.lists insertObject:model atIndex:0];
			[model release];
		}
	}
	
	%orig;
}

%end

