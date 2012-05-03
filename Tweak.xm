#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


@class SBIconListPageControl, SBDockIconListModel, SBFolder, SBIconListModel, SBIconListView;


@interface SBIconModel : NSObject {
	NSDictionary *_lastKnownUserGeneratedIconState;
	NSSet *_lastKnownUserGeneratedIconStateFlattened;
}
+ (id)sharedInstance;
- (id)init;
- (void)loadAllIcons;
- (id)iconState;
- (id)iconStatePath;
- (id)_cachedIconStatePath;
- (id)_iconState:(BOOL)fp8;
- (BOOL)_writeIconState:(id)fp8 toPath:(id)fp12;
- (BOOL)_writeIconState:(id)fp8 toPath:(id)fp12 withFormat:(unsigned int)fp16;
- (void)_writeCurrentIconStateWithNotification:(BOOL)fp8;
- (void)_writeCachedIconState;
- (void)saveIconState;
- (void)relayout;
- (id)_deepCopyIconState:(id)fp8;
- (id)_deepCopyListForIconState:(id)fp8;
- (id)exportState:(BOOL)fp8;
- (id)exportPendingState:(BOOL)fp8;
- (id)exportFlattenedState:(BOOL)fp8;
- (BOOL)importState:(id)fp8;
@end

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
- (struct CGPoint)originForIconAtIndex:(int)fp8;
- (struct CGPoint)originForIcon:(id)fp8;
- (id)iconAtPoint:(struct CGPoint)fp8 index:(unsigned int *)fp16;
- (id)iconAtPoint:(struct CGPoint)fp8 index:(unsigned int *)fp16 proposedOrder:(int *)fp20 grabbedIcon:(id)fp24;
- (struct CGPoint)originForIconAtX:(unsigned int)fp8 Y:(unsigned int)fp12;
- (unsigned int)columnAtPoint:(struct CGPoint)fp8;
- (unsigned int)rowAtPoint:(struct CGPoint)fp8;
@end

@interface SBSearchView : UIView
@end

@interface SBSearchController : NSObject
- (SBSearchView *)searchView;
@end

@interface SBIconController : NSObject {
	SBIconModel *_iconModel;
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

- (void)updateContentSize;
- (void)updateRootIconListFrames;
- (void)updateIconListWallpaperState;
- (void)updateNumberOfRootIconLists;

- (void)scrollViewWillBeginDragging:(id)fp8;
- (void)scrollViewDidScroll:(id)fp8;
- (void)_scrollingDidFinish;
- (void)scrollViewDidEndDragging:(id)fp8 willDecelerate:(BOOL)fp12;
- (void)scrollViewWillBeginDecelerating:(id)fp8;
- (void)scrollViewDidEndDecelerating:(id)fp8;
- (void)scrollViewDidEndScrollingAnimation:(id)fp8;
@end

@interface SBIconController (NEW)
- (SBRootFolder *)rootFolder;
- (SBIconListPageControl *)pageControl;
- (NSMutableArray *)rootIconLists;
- (void)setRootIconLists:(NSMutableArray *)list;
- (NSMutableArray *)folderIconLists;
- (SBIconModel *)iconModel;
@end



/*@interface NSDictionary (MutableDeepCopy)
- (NSMutableDictionary *)mutableDeepCopy;
@end

@implementation NSDictionary(MutableDeepCopy)
- (NSMutableDictionary *)mutableDeepCopy {
	NSMutableDictionary *ret = [[NSMutableDictionary alloc] initWithCapacity:[self count]];
	NSArray *keys = [self allKeys];
	for(id key in keys) {
		id oneValue = [self valueForKey:key];
		id oneCopy = nil;
		
		if([oneValue respondsToSelector:@selector(mutableDeepCopy)])
			oneCopy = [oneValue mutableDeepCopy];
		if([oneValue respondsToSelector:@selector(mutableCopy)])
			oneCopy = [oneValue mutableCopy];
		if(oneCopy == nil)
			oneCopy = [oneValue copy];

		[ret setValue:oneCopy forKey:key];
	}
	
	return ret;
}
@end*/


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

%new
- (void)setRootIconLists:(NSMutableArray *)list {
	NSMutableArray *&rootIconLists = MSHookIvar<NSMutableArray *>(self, "_rootIconLists");
	[rootIconLists release];
	rootIconLists = list;
}

%new
- (NSMutableArray *)folderIconLists {
	return MSHookIvar<NSMutableArray *>(self, "_folderIconLists");
}

%new
- (SBIconModel *)iconModel {
	return MSHookIvar<SBIconModel *>(self, "_iconModel");
}

- (void)resetRootIconLists {
	%log;
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

/*
%hook SBIconListView

- (CGPoint)originForIconAtIndex:(int)fp8 {
	CGPoint pt = %orig;
	NSLog(@"deVbugTest 1 %@", NSStringFromCGPoint(pt));
	return pt;
}

- (CGPoint)originForIcon:(id)fp8 {
	CGPoint pt = %orig;
	NSLog(@"deVbugTest 2 %@", NSStringFromCGPoint(pt));
	return pt;
}

- (id)iconAtPoint:(struct CGPoint)fp8 index:(unsigned int *)fp16 {
	NSLog(@"deVbugTest iconAtPoint 1 %@ %f", NSStringFromCGPoint(fp8), fp16);
	return %orig;
}
- (id)iconAtPoint:(struct CGPoint)fp8 index:(unsigned int *)fp16 proposedOrder:(int *)fp20 grabbedIcon:(id)fp24 {
	NSLog(@"deVbugTest iconAtPoint 2 %@ %f", NSStringFromCGPoint(fp8), fp16);
	return %orig;
}
- (struct CGPoint)originForIconAtX:(unsigned int)fp8 Y:(unsigned int)fp12 {
	CGPoint pt = %orig;
	NSLog(@"deVbugTest %@ originForIconAtX %ld %ld", NSStringFromCGPoint(pt), fp8, fp12);
	return pt;
}
- (unsigned int)columnAtPoint:(struct CGPoint)fp8 {
	unsigned int rtn = %orig;
	NSLog(@"deVbugTest %ld columnAtPoint %@", rtn, NSStringFromCGPoint(fp8));
	return rtn;
}
- (unsigned int)rowAtPoint:(struct CGPoint)fp8 {
	unsigned int rtn = %orig;
	NSLog(@"deVbugTest %ld rowAtPoint %@", rtn, NSStringFromCGPoint(fp8));
	return rtn;
}

%end


%hook SBIconModel

- (void)loadAllIcons {
	%log;
	%orig;
	
	NSDictionary *dict = MSHookIvar<NSDictionary *>(self, "_lastKnownUserGeneratedIconState");
	NSLog(@"deVbugTest %@", dict);
}

- (id)iconState {
	%log;
	NSDictionary *iconState = %orig;
	NSMutableDictionary *dest = [iconState mutableDeepCopy];
	
	NSArray *iconLists = [dest objectForKey:@"iconLists"];
	NSMutableArray *destLists = [iconLists mutableCopy];
	NSMutableArray *nullArray = [[NSMutableArray alloc] init];
	[destLists insertObject:nullArray atIndex:0];
	[nullArray release];
	
	[dest setObject:destLists forKey:@"iconLists"];
	[destLists release];
	
	return [dest autorelease];
}

- (id)_iconState:(BOOL)fp8 {
	%log;
	NSDictionary *iconState = %orig;
	NSMutableDictionary *dest = [iconState mutableDeepCopy];
	
	NSArray *iconLists = [dest objectForKey:@"iconLists"];
	NSMutableArray *destLists = [iconLists mutableCopy];
	NSMutableArray *nullArray = [[NSMutableArray alloc] init];
	[destLists insertObject:nullArray atIndex:0];
	[nullArray release];
	
	[dest setObject:destLists forKey:@"iconLists"];
	[destLists release];
	
	return [dest autorelease];
}
- (void)relayout {
	%log;
	NSDictionary *dict = MSHookIvar<NSDictionary *>(self, "_lastKnownUserGeneratedIconState");
	NSLog(@"deVbugTest %@", dict);
	%orig;
	NSLog(@"deVbugTest end of relayout");
}

%end

*/