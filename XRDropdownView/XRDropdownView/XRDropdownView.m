//
//  XRDropdownView.m
//  XRDropdownView
//
//  Created by Xinrui Gao on 20/08/12.
//  Copyright (c) 2012 Jusan Network. All rights reserved.
//

#import "XRDropdownView.h"

#define kDropdownCellHeight 36.0
#define kFooterButtonHeight 38.0
#define kArrowsPadding 20.0
#define kBackgroundColor [UIColor colorWithRed:82.0/255.0 green:68.0/255.0 blue:59.0/255.0 alpha:0.9]

@interface XRDropdownView () <UITableViewDataSource, UITableViewDelegate>
{
  UIImageView *upArrow, *downArrow, *separator;
  NSMutableArray  *dropdownData;
}

@property (strong, nonatomic) NSString        *defaultTitle;
@property (strong, nonatomic) UIButton        *dropdownTitleButton;
@property (strong, nonatomic) UITableView     *dropdownTableView;
@property (strong, nonatomic) UIScrollView    *dropdownScrollView;
@property (strong, nonatomic) UIButton        *addButton, *deleteButton;

@end

@implementation XRDropdownView

+ (CGFloat)cellHeight
{
  return kDropdownCellHeight;
}

+ (CGFloat)footerHeight
{
  return kFooterButtonHeight;
}

+ (CGFloat)arrowsPadding
{
  return kArrowsPadding;
}

- (id)initWithFrame:(CGRect)frame
           delegate:(id<XRDropdownViewDelegate>)delegate
         dataSource:(id<XRDropdownViewDataSource>)dataSource
             params:(NSDictionary *)params
{  
  if (self = [super initWithFrame:frame]) {
    self.backgroundColor = kBackgroundColor;

    //Initialize the data source and delegate variables
    self.dataSource = dataSource;
    self.delegate = delegate;
    self.tableHeight = [[params valueForKey:@"Height"] floatValue];
    self.defaultTitle = [params valueForKey:@"Title"];
    _needFooterButtons = [[params valueForKey:@"Footer"] boolValue];
    _needMultipleSelection = [[params valueForKey:@"MultiSelection"] boolValue];
    
    [self setButtonWithTitle:self.defaultTitle];
    
    self.dropdownTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -self.tableHeight-(_needFooterButtons?kFooterButtonHeight:5.0)-kArrowsPadding, self.frame.size.width, self.tableHeight)];
    self.dropdownScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                             0+self.frame.size.height,
                                                                             self.frame.size.width,
                                                                             self.dropdownTableView.frame.size.height+kArrowsPadding*2+(_needFooterButtons?kFooterButtonHeight:5.0))];
    self.clipsToBounds = YES;
    self.dropdownScrollView.clipsToBounds = YES;
    
    self.dropdownScrollView.backgroundColor = [UIColor clearColor];
    self.dropdownTableView.backgroundColor = [UIColor clearColor];
    self.dropdownTableView.separatorColor = [UIColor colorWithRed:111.0/255.0 green:91.0/255.0 blue:79.0/255.0 alpha:0.6];
    
    self.dropdownTableView.delegate = self;
    self.dropdownTableView.dataSource = self;
    
    //Set single/multiple selection for tableView
    self.dropdownTableView.allowsMultipleSelection = _needMultipleSelection;
    
    [self.dropdownScrollView addSubview:self.dropdownTableView];
    
    upArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WishlistDropdownArrowUp"]];
    [upArrow sizeToFit];
    [upArrow setFrame:CGRectMake((self.frame.size.width-upArrow.frame.size.width)/2,
                                 -self.tableHeight-(_needFooterButtons?kFooterButtonHeight:5.0)-(3*kArrowsPadding+upArrow.frame.size.height)/2,
                                 upArrow.frame.size.width, upArrow.frame.size.height)];
    [self.dropdownScrollView addSubview:upArrow];
    downArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WishlistDropdownArrowDown"]];
    [downArrow sizeToFit];
    [downArrow setFrame:CGRectMake((self.frame.size.width-downArrow.frame.size.width)/2,
                                   -(_needFooterButtons?kFooterButtonHeight:5.0)-downArrow.frame.size.height,
                                   downArrow.frame.size.width, downArrow.frame.size.height)];
    [self.dropdownScrollView addSubview:downArrow];
    
    if (_needFooterButtons) {
      _addButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, -kFooterButtonHeight, self.frame.size.width/2, kFooterButtonHeight)];
      [_addButton setImage:[UIImage imageNamed:@"WishlistDropdownAddIcon"] forState:UIControlStateNormal];
      [_addButton setTitle:@"add" forState:UIControlStateNormal];
      _addButton.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:14.0];
      [_addButton addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
      [self.dropdownScrollView addSubview:_addButton];
      
      _deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2, -kFooterButtonHeight, self.frame.size.width/2, kFooterButtonHeight)];
      [_deleteButton setImage:[UIImage imageNamed:@"WishlistDropdownDeleteIcon"] forState:UIControlStateNormal];
      [_deleteButton setTitle:@"delete" forState:UIControlStateNormal];
      _deleteButton.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:14.0];
      [_deleteButton addTarget:self action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
      [self.dropdownScrollView addSubview:_deleteButton];
      
      separator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WishlistTopButtonsSeparator"]];
      [separator sizeToFit];
      [separator setFrame:CGRectMake(self.frame.size.width/2, -(kFooterButtonHeight+separator.frame.size.height)/2, separator.frame.size.width, separator.frame.size.height)];
      [self.dropdownScrollView addSubview:separator];
    }
    
    [self addSubview:self.dropdownScrollView];
  }
  return self;
}

- (void)setButtonWithTitle:(NSString *)title
{
  if (!self.dropdownTitleButton) {
    self.dropdownTitleButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)];
    [self.dropdownTitleButton setBackgroundImage:[UIImage imageNamed:@"WishlistButtonStyle1"] forState:UIControlStateNormal];
    [self.dropdownTitleButton setBackgroundImage:[UIImage imageNamed:@"WishlistButtonStyle2"] forState:UIControlStateSelected];
    [self.dropdownTitleButton.titleLabel setFont:[UIFont fontWithName:@"Lato-Regular" size:14.0]];
    [self.dropdownTitleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.dropdownTitleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.dropdownTitleButton addTarget:self action:@selector(openDropdownList:) forControlEvents:UIControlEventTouchUpInside];
  }
  [self.dropdownTitleButton setTitle:title forState:UIControlStateNormal];
  [self addSubview:self.dropdownTitleButton];
}

- (NSArray *)indexPathsForSelectedRows {
  return [self.dropdownTableView indexPathsForSelectedRows];
}

- (void)updateFrame {
  self.dropdownScrollView.contentOffset = CGPointZero;
  [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.dropdownTitleButton.frame.size.height)];
  
  CGFloat newHeight = kDropdownCellHeight*MIN(dropdownData.count, 8);
  [self.dropdownTableView  setFrame:CGRectMake(0, -newHeight-(_needFooterButtons?kFooterButtonHeight:5.0)-kArrowsPadding, self.frame.size.width, newHeight)];
  [self.dropdownScrollView setFrame:CGRectMake(0,
                                               0+self.frame.size.height,
                                               self.frame.size.width,
                                               self.dropdownTableView.frame.size.height+kArrowsPadding*2+(_needFooterButtons?kFooterButtonHeight:5.0))];
  [upArrow setFrame:CGRectMake((self.frame.size.width-upArrow.frame.size.width)/2,
                               -newHeight-(_needFooterButtons?kFooterButtonHeight:5.0)-(3*kArrowsPadding+upArrow.frame.size.height)/2,
                               upArrow.frame.size.width, upArrow.frame.size.height)];
  [self setFrame:CGRectMake(self.frame.origin.x,
                            self.frame.origin.y,
                            self.frame.size.width,
                            self.dropdownScrollView.frame.size.height+self.frame.size.height)];
  self.dropdownScrollView.contentOffset = CGPointMake(0.0, -self.dropdownScrollView.frame.size.height);
  
  [downArrow setFrame:CGRectMake((self.frame.size.width-downArrow.frame.size.width)/2,
                                 -(_needFooterButtons?kFooterButtonHeight:5.0)-downArrow.frame.size.height,
                                 downArrow.frame.size.width, downArrow.frame.size.height)];
  
  if (_needFooterButtons) {
    [_addButton setFrame:CGRectMake(0.0, -kFooterButtonHeight, self.frame.size.width/2, kFooterButtonHeight)];
    [_deleteButton setFrame:CGRectMake(self.frame.size.width/2, -kFooterButtonHeight, self.frame.size.width/2, kFooterButtonHeight)];
    [separator setFrame:CGRectMake(self.frame.size.width/2, -(kFooterButtonHeight+separator.frame.size.height)/2, separator.frame.size.width, separator.frame.size.height)];
  }
  
}

- (void)deselectCell
{
  [self.dropdownTableView deselectRowAtIndexPath:[self.dropdownTableView indexPathForSelectedRow] animated:NO];
  _currentSelectedIndexPath = nil;
}

- (void)deselectCells
{
  if (!_needMultipleSelection) {
    return;
  }
  NSArray *selectedRows = [self.dropdownTableView indexPathsForSelectedRows];
  for (NSIndexPath *aIndexPath in selectedRows) {
    [self.dropdownTableView deselectRowAtIndexPath:aIndexPath animated:NO];
  }
}

- (void)openDropdownView {
  if ([self.delegate respondsToSelector:@selector(dropdownViewDidExpand:)]) {
    [self.delegate dropdownViewDidExpand:self]; //here need to close all other opened dropdownViews and bring this dropdownView to front
  }
  if (_currentSelectedIndexPath) {
    //Here set to UITableViewScrollPositionBottom to show the latest added item (in case of the latest is added as the last one)
    [self.dropdownTableView selectRowAtIndexPath:_currentSelectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
  }
  [UIView animateWithDuration:0.2 animations:^{
    [self setFrame:CGRectMake(self.frame.origin.x,
                              self.frame.origin.y,
                              self.frame.size.width,
                              self.dropdownScrollView.frame.size.height+self.frame.size.height)];
    self.dropdownScrollView.contentOffset = CGPointMake(0.0, -self.dropdownScrollView.frame.size.height);
  }];
}

- (void)openDropdownList:(UIButton *)sender {
  if (sender.isSelected) {
    [sender setSelected:NO];
    [UIView animateWithDuration:0.2 animations:^{
      self.dropdownScrollView.contentOffset = CGPointZero;
      [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.dropdownTitleButton.frame.size.height)];
    }];
    if ([self.delegate respondsToSelector:@selector(dropdownViewDidCollapse:)]) {
      [self.delegate dropdownViewDidCollapse:self];
    }
  }else {
    [sender setSelected:YES];
    [self openDropdownView];
  }
}

- (void)resetDropdownView {//only reset frames and buttons, doesn't reset the data
  [self.dropdownTitleButton setSelected:NO];
  [self.dropdownTableView setEditing:NO animated:NO];
  [self.deleteButton setSelected:NO];
  [UIView animateWithDuration:0.2 animations:^{
    self.dropdownScrollView.contentOffset = CGPointZero;
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.dropdownTitleButton.frame.size.height)];
  }];
  if ([self.delegate respondsToSelector:@selector(dropdownViewDidCollapse:)]) {
    [self.delegate dropdownViewDidCollapse:self];
  }
}

- (void)updateSelectedValues {
  if (_needMultipleSelection && [self.delegate respondsToSelector:@selector(dropdownView:selectCellsAtIndexPaths:)]) {
    [self.delegate dropdownView:self selectCellsAtIndexPaths:[self.dropdownTableView indexPathsForSelectedRows]];
  }
}

#pragma mark - Dropdown Table View Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if ([self.dataSource respondsToSelector:@selector(dropdownView:numberOfRowsInSection:)]) {
    return [self.dataSource dropdownView:self numberOfRowsInSection:section];
  }
  return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return kDropdownCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([self.dataSource respondsToSelector:@selector(dropdownView:cellForRowAtIndexPath:)]) {
    return [self.dataSource dropdownView:self cellForRowAtIndexPath:indexPath];
  }
  return nil;
}

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier {
  return [self.dropdownTableView dequeueReusableCellWithIdentifier:identifier];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [self.dropdownTitleButton setSelected:NO];
  XRDropdownViewCell *cell = (XRDropdownViewCell *)[tableView cellForRowAtIndexPath:indexPath];
  [self.dropdownTitleButton setTitle:cell.label.text forState:UIControlStateNormal];
//  [UIView animateWithDuration:0.3 animations:^{
//    self.dropdownScrollView.contentOffset = CGPointMake(0.0, 0.0);
//    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.dropdownTitleButton.frame.size.height)];
//  }];
  if ([self.delegate respondsToSelector:@selector(dropdownView:didSelectCellAtIndexPath:)]) {
    [self.delegate dropdownView:self didSelectCellAtIndexPath:indexPath];
  }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [self tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (!_needFooterButtons) {
    return UITableViewCellEditingStyleNone;
  }
  return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (editingStyle == UITableViewCellEditingStyleDelete)
  {
    // TODO: Delete doesn't work
    if ([indexPath isEqual:[tableView indexPathForSelectedRow]]) { //only for single selection control
      if (indexPath.row > 0) {
        NSInteger newRow = 0;
        if (indexPath.row + 1 < [tableView numberOfRowsInSection:indexPath.section]) {
          newRow = indexPath.row + 1;
        }else{ //remove last object in array
          newRow = indexPath.row - 1;
        }
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:newRow inSection:indexPath.section];
        XRDropdownViewCell *cell = (XRDropdownViewCell *)[tableView cellForRowAtIndexPath:newIndexPath];
        [self setButtonWithTitle:cell.label.text];
      }else{
        [self setButtonWithTitle:self.defaultTitle];
      }
    }
    
    [self.dropdownTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    //remote update
    if ([self.delegate respondsToSelector:@selector(dropdownView:didRemoveCellAtIndexPath:)]) {
      [self.delegate dropdownView:self didRemoveCellAtIndexPath:indexPath];
    }
    
  }
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC);
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    [self.dropdownTableView reloadData];
    [self updateFrame];
  });
}

#pragma mark - Footer button actions

- (void)addButtonAction:(UIButton *)sender
{
  if ([self.delegate respondsToSelector:@selector(dropdownViewWillAddCell:)]) {
    [self.delegate dropdownViewWillAddCell:self];
  }
  [self resetDropdownView];
}

- (void)deleteButtonAction:(UIButton *)sender
{
  if (sender.isSelected) {
    [self.dropdownTableView setEditing:NO animated:YES];
    [self.dropdownTableView selectRowAtIndexPath:_currentSelectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [sender setSelected:NO];
  }else{
    [self.dropdownTableView setEditing:YES animated:YES];
    [sender setSelected:YES];
  }
}

@end
