#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


@interface SBFolder : NSObject
- (NSMutableArray *)lists;			// if iOS 6, return NSArray *
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


// iOS 6
@interface SBIconIndexMutableList : NSObject
- (void)insertNode:(id)node atIndex:(unsigned int)index;
@end

@interface SBFolder (OS6_NEW)
- (SBIconIndexMutableList *)mutableLists;
@end

%hook SBFolder

%new(@@:)
- (SBIconIndexMutableList *)mutableLists {
	return MSHookIvar<SBIconIndexMutableList *>(self, "_lists");
}

%end


%hook SBIconController

%new(@@:)
- (SBRootFolder *)rootFolder {
	return MSHookIvar<SBRootFolder *>(self, "_rootFolder");
}

// iOS 5
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

// iOS 6
- (void)_resetRootIconLists {
	if (self.rootFolder.listCount > 0) {
		SBIconListModel *temp = [self.rootFolder.lists objectAtIndex:0];
		if (![temp isEmpty]) {
			SBIconListModel *model = [[%c(SBIconListModel) alloc] initWithFolder:self.rootFolder];
			[self.rootFolder.mutableLists insertNode:model atIndex:0];
			[model release];
		}
	}
	
	%orig;
}

%end

