//
//  XRDropdownView.h
//  XRDropdownView
//
//  Created by Xinrui Gao on 20/08/12.
//  Copyright (c) 2012 Jusan Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XRDropdownViewCell.h"
#import "XRDropdownViewImageCell.h"

@protocol XRDropdownViewDelegate;

@interface XRDropdownView : UIView //<UIGestureRecognizerDelegate>
{
  NSMutableArray *dataArray;
  UIImageView *arrowUp, *arrowDown;
  UIImageView *separator;
}

@property (nonatomic) IBOutlet id <XRDropdownViewDelegate> delegate;

@property (nonatomic) BOOL needSampleImage;
@property (strong, nonatomic) NSArray *sampleImages;

@property (nonatomic) BOOL needMultipleSelection;

@property (strong, nonatomic) IBOutlet XRDropdownViewCell *dropdownCell;
@property (strong, nonatomic) IBOutlet XRDropdownViewImageCell *dropdownImageCell;

@property (nonatomic) CGSize containerSize;

@property (nonatomic) BOOL needFooterButtons;
@property (strong, nonatomic) NSIndexPath *currentSelectedIndexPath;

@property (strong, nonatomic) UIButton *dropdownButton, *addButton, *deleteButton;
@property (strong, nonatomic) UITableView *dropdownTableView;
@property (strong, nonatomic) UIScrollView *dropdownScrollView;

- (void)setData:(NSArray *)data withTitle:(NSString *)title needUpdateDropdownTitle:(BOOL)update;
- (void)setDropdownTableWithDataSource:(id)dataSource andDelegate:(id)delegate andTableHeight:(CGFloat)height;
- (void)openDropdownView;
- (void)resetDropdownView;
- (void)deselectCell;
- (void)deselectCells;
- (void)updateSelectedValues;

@end

@protocol XRDropdownViewDelegate <NSObject>

- (void)setSelectedValue:(NSString *)value atIndex:(NSInteger)index forDropdownView:(NSInteger)viewTag;
- (void)dropdownViewDidOpen:(XRDropdownView *)dropdownView;
- (void)dropdownViewDidClose:(XRDropdownView *)dropdownView;

@optional
- (void)needAddItemToDropdownView:(NSInteger)tag andShow:(BOOL)shouldShow asCopy:(BOOL)copy;
- (void)dropdownView:(NSInteger)tag didRemoveItem:(id)item atIndex:(NSInteger)index;
- (void)setSelectedValues:(NSArray *)values atIndexes:(NSArray *)indexes forDropdownView:(NSInteger)viewTag;

@end
