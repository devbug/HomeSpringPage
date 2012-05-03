#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


@interface SBFolder : NSObject
- (NSMutableArray *)lists;
- (unsigned int)listCount;
@end

@interface SBRootFolder : SBFolder
@end

@interface SBIconListModel : NSObject
- (id)initWithFolder:(id)fp8;
@end

@interface SBIconListView : UIView
- (void)setModel:(id)fp8;
- (id)model;
@end

@interface SBSearchView : UIView
@end

@interface SBSearchController : NSObject
- (SBSearchView *)searchView;
@end

@interface SBIconController : NSObject {
	SBRootFolder *_rootFolder;
}
- (SBSearchController *)searchController;
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
	SBIconListModel *model = [[%c(SBIconListModel) alloc] initWithFolder:self.rootFolder];
	[self.rootFolder.lists insertObject:model atIndex:0];
	SBIconListView *listView = [[%c(SBIconListView) alloc] initWithFrame:self.searchController.searchView.frame];
	[listView setModel:model];
	[model release];
	
	%orig;
}

%end

