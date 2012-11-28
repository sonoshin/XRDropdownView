//
//  XRDropdownView.h
//  XRDropdownView
//
//  Created by Xinrui Gao on 20/08/12.
//  Copyright (c) 2012 Jusan Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XRDropdownViewCell.h"

@protocol XRDropdownViewDelegate;
@protocol XRDropdownViewDataSource;

@interface XRDropdownView : UIView //<UIGestureRecognizerDelegate>

@property (nonatomic) IBOutlet id <XRDropdownViewDelegate> delegate;
@property (nonatomic) IBOutlet id <XRDropdownViewDataSource> dataSource;

//Options
@property (nonatomic) BOOL needMultipleSelection;
@property (nonatomic) BOOL needFooterButtons;

@property (strong, nonatomic) NSArray *sampleImages;

//Required Settings
@property (nonatomic) CGSize containerSize;
@property (nonatomic) CGFloat tableHeight;

@property (strong, nonatomic) NSIndexPath *currentSelectedIndexPath;

- (id)initWithFrame:(CGRect)frame delegate:(id<XRDropdownViewDelegate>)delegate dataSource:(id<XRDropdownViewDataSource>)dataSource title:(NSString *)title height:(CGFloat)height;

+ (CGFloat)cellHeight;
+ (CGFloat)footerHeight;
+ (CGFloat)arrowsPadding;

//Actions
- (void)openDropdownView;
- (void)resetDropdownView;
- (void)deselectCell;
- (void)deselectCells;
- (void)updateSelectedValues;

//Table View Passed Selection
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier;
- (NSArray *)indexPathsForSelectedRows;

@end

@protocol XRDropdownViewDataSource <NSObject>

- (NSInteger)dropdownView:(XRDropdownView *)dropdownView numberOfRowsInSection:(NSInteger)section;
- (XRDropdownViewCell *)dropdownView:(XRDropdownView *)dropdownView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol XRDropdownViewDelegate <NSObject>

@optional
- (void)dropdownViewDidExpand:(XRDropdownView *)dropdownView;
- (void)dropdownViewDidCollapse:(XRDropdownView *)dropdownView;

- (void)dropdownView:(XRDropdownView *)dropdownView didSelectCellAtIndexPath:(NSIndexPath *)indexPath;
- (void)dropdownView:(XRDropdownView *)dropdownView didSelectCellAtIndexPaths:(NSArray *)indexPaths;

- (void)dropdownViewWillAddCell:(XRDropdownView *)dropdownView;

- (void)dropdownView:(XRDropdownView *)dropdownView didRemoveCellAtIndexPath:(NSIndexPath *)indexPath;
- (void)dropdownView:(XRDropdownView *)dropdownView selectCellsAtIndexPaths:(NSArray *)indexPaths;

@end

