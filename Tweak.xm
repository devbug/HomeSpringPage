#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


@class SBIconListPageControl, SBDockIconListModel, SBFolder, SBIconListModel, SBIconListView;


@interface SBIconListPageControl : UIPageControl
@end

@interface SBFolder : NSObject {
	NSMutableArray *_lists;
}
- (NSMutableArray *)lists;
- (unsigned int)listCount;
@end

@interface SBRootFolder : SBFolder {
	SBDockIconListModel *_dock;
}
+ (int)maxListCount;
- (Class)listModelClass;
- (Class)listViewClass;
- (id)init;
- (void)dealloc;
- (id)dockModel;
- (id)listAtIndex:(unsigned int)fp8;
- (unsigned int)indexOfIconList:(id)fp8;
- (id)listContainingIcon:(id)fp8;
- (id)listContainingLeafIconWithIdentifier:(id)fp8;
- (void)removeEmptyList:(id)fp8;
- (BOOL)isIconStateDirty;
- (void)markIconStateClean;
- (id)iconsOfClass:(Class)fp8;
- (id)indexPathForEntity:(id)fp8;
- (id)folderType;
- (BOOL)resetWithRepresentation:(id)fp8 leafIdentifiersAdded:(id)fp12;
- (id)representation;
- (void)placeIconsOnFirstPage:(id)fp8;
@end

@interface SBIconListModel : NSObject {
	NSMutableArray *_icons;
}
- (id)initWithFolder:(id)fp8;
- (void)dealloc;
- (id)folder;
- (id)icons;
- (id)iconAtIndex:(unsigned int)fp8;
- (unsigned int)indexForIcon:(id)fp8;
- (unsigned int)indexForLeafIconWithIdentifier:(id)fp8;
- (BOOL)containsIcon:(id)fp8;
- (BOOL)containsLeafIconWithIdentifier:(id)fp8;
- (unsigned int)firstFreeSlotIndex;
- (unsigned int)firstFreeSlotIndexForType:(int)fp8;
- (BOOL)isEmpty;
- (BOOL)isFull;
- (id)indexPathForFirstFreeSlot;
@end

@interface SBIconListView : UIView {
	SBIconListModel *_model;
}
- (void)setModel:(id)fp8;
- (id)model;
- (id)icons;
- (id)visibleIcons;
- (BOOL)isEmpty;
- (BOOL)isFull;
@end

@interface SBSearchView : UIView
@end

@interface SBSearchController : NSObject
- (SBSearchView *)searchView;
@end

@interface SBIconController : NSObject {
	SBRootFolder *_rootFolder;
	SBIconListPageControl *_pageControl;
	NSMutableArray *_rootIconLists;
	NSMutableArray *_folderIconLists;
}
+ (id)sharedInstance;
- (id)init;
- (UIScrollView *)scrollView;
- (UIView *)contentView;
- (UIView *)dockContainerView;
- (SBIconListView *)currentRootIconList;
- (id)dock;
- (id)currentFolderIconList;
- (int)currentIconListIndex;
- (id)rootIconListAtIndex:(int)fp8;
- (void)prepareToResetRootIconLists;
- (void)resetRootIconLists;
- (SBSearchController *)searchController;
@end

@interface SBIconController (NEW)
- (SBRootFolder *)rootFolder;
- (SBIconListPageControl *)pageControl;
- (NSMutableArray *)rootIconLists;
@end



%hook SBIconController

%new
- (SBRootFolder *)rootFolder {
	return MSHookIvar<SBRootFolder *>(self, "_rootFolder");
}

%new
- (SBIconListPageControl *)pageControl {
	return MSHookIvar<SBIconListPageControl *>(self, "_pageControl");
}

%new
- (NSMutableArray *)rootIconLists {
	return MSHookIvar<NSMutableArray *>(self, "_rootIconLists");
}

- (void)resetRootIconLists {
	%orig;
	
	// self.currentRootIconList.superview = self.scrollView
	SBIconListModel *model = [[%c(SBIconListModel) alloc] initWithFolder:self.rootFolder];
	[self.rootFolder.lists insertObject:model atIndex:0];
	SBIconListView *listView = [[%c(SBIconListView) alloc] initWithFrame:self.searchController.searchView.frame];
	[listView setModel:model];
	[model release];
	[self.rootIconLists insertObject:listView atIndex:0];
	
	[self.scrollView addSubview:listView];
	[listView release];
	
	CGRect frame = listView.frame;
	float x = frame.size.width;
	int i = 1;
	for (SBIconListView *view in self.rootIconLists) {
		frame.origin.x = x * i;
		view.frame = frame;
		i++;
	}
	[self.scrollView setContentSize:CGSizeMake(x*i, frame.size.height)];
	self.pageControl.numberOfPages = i;
}

%end

