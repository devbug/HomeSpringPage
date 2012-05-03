#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


@class SBIconListPageControl, SBDockIconListModel, SBFolder, SBIconListModel, SBIconListView;

@interface SBIconListPageControl : UIPageControl
@end

@interface SBRootFolder : /*SBFolder*/NSObject {
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

@interface SBIconController : NSObject {
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
- (id)rootIconListAtIndex:(int)fp8;
- (void)prepareToResetRootIconLists;
- (void)resetRootIconLists;

- (void)scrollViewWillBeginDragging:(id)fp8;
- (void)scrollViewDidScroll:(id)fp8;
- (void)_scrollingDidFinish;
- (void)scrollViewDidEndDragging:(id)fp8 willDecelerate:(BOOL)fp12;
- (void)scrollViewWillBeginDecelerating:(id)fp8;
- (void)scrollViewDidEndDecelerating:(id)fp8;
- (void)scrollViewDidEndScrollingAnimation:(id)fp8;
@end

@interface SBIconController (NEW)
- (SBIconListPageControl *)pageControl;
- (NSMutableArray *)rootIconLists;
- (NSMutableArray *)folderIconLists;
@end


%hook SBIconController

%new
- (SBIconListPageControl *)pageControl {
	return MSHookIvar<SBIconListPageControl *>(self, "_pageControl");
}

%new
- (NSMutableArray *)rootIconLists {
	return MSHookIvar<NSMutableArray *>(self, "_rootIconLists");
}

%new
- (NSMutableArray *)folderIconLists {
	return MSHookIvar<NSMutableArray *>(self, "_folderIconLists");
}

- (void)resetRootIconLists {
	%orig;
	
	// self.currentRootIconList.superview = self.scrollView
	SBRootFolder *rootF = [[%c(SBRootFolder) alloc] init];
	SBIconListModel *model = [[%c(SBIconListModel) alloc] initWithFolder:rootF];
	SBIconListView *listView = [[%c(SBIconListView) alloc] initWithFrame:[[self.rootIconLists objectAtIndex:0] frame]];
	[listView setModel:model];
	[model release];
	[rootF release];
	[self.rootIconLists insertObject:listView atIndex:0];
	
	float x = self.currentRootIconList.frame.size.width;
	int i = 1;
	CGRect frame = self.currentRootIconList.frame;
	for (SBIconListView *view in self.rootIconLists) {
		NSLog(@"deVbugTest 1 %@", view.model);
		frame.origin.x = x * i;
		view.frame = frame;
		i++;
	}
	[self.scrollView setContentSize:CGSizeMake(x*i, frame.size.height)];
	self.pageControl.numberOfPages = i;
}

%end