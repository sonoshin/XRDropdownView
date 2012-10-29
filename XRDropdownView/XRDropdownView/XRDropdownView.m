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

@implementation XRDropdownView

- (void)awakeFromNib {
  
  [super awakeFromNib];
  NSLog(@"###Awake from nib###");
  [self initialization];
  NSLog(@"Self.frame:  %f, %f, %f, %f", self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (void)initialization {
  NSLog(@"###Initialization started###");
  self.backgroundColor = [UIColor colorWithRed:82.0/255.0 green:68.0/255.0 blue:59.0/255.0 alpha:0.9];
}

- (void)setData:(NSArray *)data withTitle:(NSString *)title needUpdateDropdownTitle:(BOOL)update {
  dataArray = [NSMutableArray arrayWithArray:data];
  if (update) {
    [self setButtonWithTitle:title];
  }
  NSInteger numberOfCellsToShow = _containerSize.height > 0 ? (_containerSize.height-(_needFooterButtons?kFooterButtonHeight:5.0)-kArrowsPadding-self.frame.origin.y)/kDropdownCellHeight-1 : 8;
  [self setDropdownTableWithDataSource:self andDelegate:self andTableHeight:kDropdownCellHeight*MIN(data.count, numberOfCellsToShow)];
}

- (void)updateFrame {
  self.dropdownScrollView.contentOffset = CGPointZero;
  [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.dropdownButton.frame.size.height)];
  
  CGFloat newHeight = kDropdownCellHeight*MIN(dataArray.count, 8);
  [self.dropdownTableView  setFrame:CGRectMake(0, -newHeight-(_needFooterButtons?kFooterButtonHeight:5.0)-kArrowsPadding, self.frame.size.width, newHeight)];
  [self.dropdownScrollView setFrame:CGRectMake(0,
                                               0+self.frame.size.height,
                                               self.frame.size.width,
                                               self.dropdownTableView.frame.size.height+kArrowsPadding*2+(_needFooterButtons?kFooterButtonHeight:5.0))];
  [arrowUp setFrame:CGRectMake((self.frame.size.width-arrowUp.frame.size.width)/2,
                               -newHeight-(_needFooterButtons?kFooterButtonHeight:5.0)-(3*kArrowsPadding+arrowUp.frame.size.height)/2,
                               arrowUp.frame.size.width, arrowUp.frame.size.height)];
  [self setFrame:CGRectMake(self.frame.origin.x,
                            self.frame.origin.y,
                            self.frame.size.width,
                            self.dropdownScrollView.frame.size.height+self.frame.size.height)];
  self.dropdownScrollView.contentOffset = CGPointMake(0.0, -self.dropdownScrollView.frame.size.height);
  
  [arrowDown setFrame:CGRectMake((self.frame.size.width-arrowDown.frame.size.width)/2,
                                 -(_needFooterButtons?kFooterButtonHeight:5.0)-arrowDown.frame.size.height,
                                 arrowDown.frame.size.width, arrowDown.frame.size.height)];
  
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

- (void)setButtonWithTitle:(NSString *)title
{
  NSLog(@"###Dropdown button setup###");
  if (!self.dropdownButton) {
    self.dropdownButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)];
    [self.dropdownButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0]];
    [self.dropdownButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.dropdownButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.dropdownButton addTarget:self action:@selector(openDropdownList:) forControlEvents:UIControlEventTouchUpInside];
  }
  [self.dropdownButton setTitle:title forState:UIControlStateNormal];
  [self addSubview:self.dropdownButton];
}

- (void)setDropdownTableWithDataSource:(id)dataSource andDelegate:(id)delegate andTableHeight:(CGFloat)height
{
  NSLog(@"###Dropdown table setup###");
  
  self.dropdownTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -height-(_needFooterButtons?kFooterButtonHeight:5.0)-kArrowsPadding, self.frame.size.width, height)];
  self.dropdownScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                           0+self.frame.size.height,
                                                                           self.frame.size.width,
                                                                           self.dropdownTableView.frame.size.height+kArrowsPadding*2+(_needFooterButtons?kFooterButtonHeight:5.0))];
  self.clipsToBounds = YES;
  self.dropdownScrollView.clipsToBounds = YES;
  
  self.dropdownScrollView.backgroundColor = [UIColor clearColor];
  self.dropdownTableView.backgroundColor = [UIColor clearColor];
  self.dropdownTableView.separatorColor = [UIColor colorWithRed:111.0/255.0 green:91.0/255.0 blue:79.0/255.0 alpha:0.6];
  
  self.dropdownTableView.delegate = delegate;
  self.dropdownTableView.dataSource = dataSource;
  
  //Set single/multiple selection for tableView
  self.dropdownTableView.allowsMultipleSelection = _needMultipleSelection;
  
  [self.dropdownScrollView addSubview:self.dropdownTableView];
    
  if (_needFooterButtons) {
    _addButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, -kFooterButtonHeight, self.frame.size.width/2, kFooterButtonHeight)];
    [_addButton setTitle:@"add" forState:UIControlStateNormal];
    _addButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
    [_addButton addTarget:self action:@selector(addItemToDropdownTable:) forControlEvents:UIControlEventTouchUpInside];
    [self.dropdownScrollView addSubview:_addButton];
    
    _deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2, -kFooterButtonHeight, self.frame.size.width/2, kFooterButtonHeight)];
    [_deleteButton setTitle:@"delete" forState:UIControlStateNormal];
    _deleteButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
    [_deleteButton addTarget:self action:@selector(deleteItemFromDropdownTable:) forControlEvents:UIControlEventTouchUpInside];
    [self.dropdownScrollView addSubview:_deleteButton];
  }
  
  [self addSubview:self.dropdownScrollView];
  
}

- (void)openDropdownView {
  [self.delegate dropdownViewDidOpen:self]; //here need to close all other opened dropdownViews and bring this dropdownView to front

  if (_currentSelectedIndexPath) {
    [self.dropdownTableView selectRowAtIndexPath:_currentSelectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
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
      [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.dropdownButton.frame.size.height)];
    }];
    [self.delegate dropdownViewDidClose:self];
  }else {
    [sender setSelected:YES];
    [self openDropdownView];
  }
}

- (void)resetDropdownView {//only reset frames and buttons, doesn't reset the data
  [self.dropdownButton setSelected:NO];
  [self.deleteButton setSelected:NO];
  [self.dropdownTableView setEditing:NO animated:NO];
  [UIView animateWithDuration:0.2 animations:^{
    self.dropdownScrollView.contentOffset = CGPointZero;
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.dropdownButton.frame.size.height)];
  }];
  [self.delegate dropdownViewDidClose:self];
}

- (void)updateSelectedValues {
  if (_needMultipleSelection) {
    //NSLog(@"###Multiple selected cells updated##");
    NSArray *selectedIndexpaths = [self.dropdownTableView indexPathsForSelectedRows];
    NSMutableArray *selectedValues = [NSMutableArray array];
    NSMutableArray *selectedRows = [NSMutableArray array];
    for (int i = 0; i < selectedIndexpaths.count; i++) {
      NSString *aValue = [dataArray objectAtIndex:[selectedIndexpaths[i] row]];
      [selectedValues addObject:aValue];
      [selectedRows addObject:@([selectedIndexpaths[i] row])];
    }
    [self.delegate setSelectedValues:selectedValues atIndexes:selectedRows forDropdownView:self.tag];
  }
}

#pragma mark - Dropdown Table View Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return kDropdownCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  NSString *CellIdentifier = _needSampleImage ? @"XRDropdownViewImageCell" : @"XRDropdownViewCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  if (!_needSampleImage) {
    
    [[NSBundle mainBundle] loadNibNamed:@"XRDropdownViewCell" owner:self options:nil];
    
    _dropdownCell.label.text = [dataArray objectAtIndex:indexPath.row];
    _dropdownCell.label.font = [UIFont fontWithName:@"HelveticaNeue" size:13.0];
    _dropdownCell.label.textColor = [UIColor whiteColor];
    _dropdownCell.checkImage.hidden = YES;
    
    cell = _dropdownCell;
    _dropdownCell = nil;
    
  }else{    
    [[NSBundle mainBundle] loadNibNamed:@"XRDropdownViewImageCell" owner:self options:nil];
    
    _dropdownImageCell.label.text = [dataArray objectAtIndex:indexPath.row];
    _dropdownImageCell.label.font = [UIFont fontWithName:@"HelveticaNeue" size:13.0];
    _dropdownImageCell.label.textColor = [UIColor whiteColor];
    _dropdownImageCell.checkImage.hidden = YES;
    _dropdownImageCell.cellImage.image = _sampleImages[indexPath.row] ? _sampleImages[indexPath.row] : nil;
    
    cell = _dropdownImageCell;
    _dropdownImageCell = nil;
  }

  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  if (!_needMultipleSelection) {
    NSLog(@"###Cell selected###");
    [self.dropdownButton setSelected:NO];
    [self.dropdownButton setTitle:[dataArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3 animations:^{
      self.dropdownScrollView.contentOffset = CGPointMake(0.0, 0.0);
      [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.dropdownButton.frame.size.height)];
    }];
    _currentSelectedIndexPath = indexPath;
    [self.delegate setSelectedValue:[dataArray objectAtIndex:indexPath.row] atIndex:indexPath.row forDropdownView:self.tag];
  }else{
    NSLog(@"###Multiple cells selected##");
    NSArray *selectedIndexpaths = [tableView indexPathsForSelectedRows];
    NSMutableArray *selectedValues = [NSMutableArray array];
    NSMutableArray *selectedRows = [NSMutableArray array];
    for (int i = 0; i < selectedIndexpaths.count; i++) {
      NSString *aValue = [dataArray objectAtIndex:[selectedIndexpaths[i] row]];
      [selectedValues addObject:aValue];
      [selectedRows addObject:@([selectedIndexpaths[i] row])];
    }
    [self.delegate setSelectedValues:selectedValues atIndexes:selectedRows forDropdownView:self.tag];
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
    //update DropdownButton title
    if (indexPath.row == _currentSelectedIndexPath.row) {
      if (dataArray.count > 1) {
        if (indexPath.row+1 < dataArray.count) {
          [self setButtonWithTitle:[dataArray objectAtIndex:indexPath.row+1]];
        }else{ //remove last object in array
          [self setButtonWithTitle:[dataArray objectAtIndex:indexPath.row-1]];
          _currentSelectedIndexPath = [NSIndexPath indexPathForRow:_currentSelectedIndexPath.row-1 inSection:_currentSelectedIndexPath.section];
        }
      }else{
        [self setButtonWithTitle:@"wishlist"];
        _currentSelectedIndexPath = nil;
      }
    }else{
      if (indexPath.row < _currentSelectedIndexPath.row) {
        _currentSelectedIndexPath = [NSIndexPath indexPathForRow:_currentSelectedIndexPath.row-1 inSection:_currentSelectedIndexPath.section];
      }
    }
    
    id itemToRemove = dataArray[indexPath.row];
    
    //local update
    [dataArray removeObjectAtIndex:indexPath.row]; 
    [self.dropdownTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    //remote update
    [self.delegate dropdownView:(NSInteger)self.tag didRemoveItem:itemToRemove atIndex:indexPath.row];

  }
  [self.dropdownTableView reloadData];
  [self updateFrame];

}

#pragma mark - Footer button actions

- (void)addItemToDropdownTable:(UIButton *)sender
{
  //call out AddView to add
  [self.delegate needAddItemToDropdownView:self.tag andShow:NO asCopy:NO];
  [self resetDropdownView];
}

- (void)deleteItemFromDropdownTable:(UIButton *)sender
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
