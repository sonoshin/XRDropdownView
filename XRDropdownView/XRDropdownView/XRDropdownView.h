//
//  XRDropdownView.h
//  XRDropdownView
//
//  Created by Xinrui Gao on 20/08/12.
//  Copyright (c) 2012 Jusan Network. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XRDropdownViewDelegate <NSObject>

- (void)setSelectedValue:(NSString *)value;

@end

@interface XRDropdownView : UIView //<UIGestureRecognizerDelegate>
{
  NSArray *dataArray;
}

@property (nonatomic) IBOutlet id <XRDropdownViewDelegate> delegate;

@property (strong, nonatomic) UIButton *dropdownButton;
@property (strong, nonatomic) UITableView *dropdownTableView;
@property (strong, nonatomic) UIScrollView *dropdownScrollView;
//@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;

- (void)setData:(NSArray *)data withTitle:(NSString *)title;
- (void)setDropdownTableWithDataSource:(id)dataSource andDelegate:(id)delegate andTableHeight:(CGFloat)height;

@end
