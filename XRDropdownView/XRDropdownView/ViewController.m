//
//  ViewController.m
//  XRDropdownView
//
//  Created by Xinrui Gao on 22/08/12.
//  Copyright (c) 2012 Xinrui Gao. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () 
{
  UIView *dropdownOverlayView;
  NSArray *dataArray, *sampleImages;
  BOOL needSampleImage;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  needSampleImage = NO;
  sampleImages = @[]; //add images in case of needSampleImage = YES
  
  dataArray = @[@"test01", @"test02", @"test03", @"test04", @"test05", @"test06", @"test07", @"test08", @"test09"];
  
  CGFloat cellHeight = [XRDropdownView cellHeight];
  CGFloat footerHeight = [XRDropdownView footerHeight];
  CGFloat arrowPadding = [XRDropdownView arrowsPadding];
  BOOL needFooterButtons = YES;
  CGSize containerSize = self.view.frame.size;
  NSInteger numberOfCellsToShow = containerSize.height > 0 ? (containerSize.height-(needFooterButtons ? footerHeight : 5.0)-arrowPadding-self.view.frame.origin.y)/cellHeight-1 : 8;
  _normalDropdownView1 = [[XRDropdownView alloc] initWithDelegate:self
                                                       dataSource:self
                                                            title:@"one"
                                                           height:cellHeight*MIN(dataArray.count, numberOfCellsToShow)];
  
  dropdownOverlayView = [[UIView alloc] initWithFrame:self.view.frame];
  dropdownOverlayView.backgroundColor = [UIColor clearColor];
  dropdownOverlayView.userInteractionEnabled = YES;
  dropdownOverlayView.hidden = YES;
  UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToDismissDropdownViews:)];
  tapGesture2.delegate = self;
  [dropdownOverlayView addGestureRecognizer:tapGesture2];

}

- (void)viewDidUnload
{
  [self setNormalDropdownView1:nil];
  [self setNormalDropdownView2:nil];
  [self setImageDropdownView1:nil];
  [self setImageDropdownView2:nil];
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
      return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
  } else {
      return YES;
  }
}

- (void)tapToDismissDropdownViews:(UITapGestureRecognizer *)sender {
  [dropdownOverlayView removeFromSuperview];
  dropdownOverlayView.hidden = YES;
  
  [self resetLocalDropdownViews];
}

- (void)resetLocalDropdownViews
{
  [_normalDropdownView1 resetDropdownView];
  [_normalDropdownView2 resetDropdownView];
  [_imageDropdownView1 resetDropdownView];
  [_imageDropdownView2 resetDropdownView];
}

#pragma mark - DropdownViewDelegate

- (void)dropdownViewDidExpand:(XRDropdownView *)dropdownView
{
  NSArray *dropdownViews = @[_normalDropdownView1, _normalDropdownView2, _imageDropdownView1, _imageDropdownView2];
  for (XRDropdownView *aDropdownView in dropdownViews) {
    if (![aDropdownView isEqual:dropdownView]) {
      [aDropdownView resetDropdownView];
    }
  }
  
  dropdownOverlayView.hidden = NO;
  [self.view addSubview:dropdownOverlayView];
  [self.view bringSubviewToFront:dropdownView];
}

- (void)dropdownViewDidCollapse:(XRDropdownView *)dropdownView
{
  [dropdownView updateSelectedValues]; //currently only works for Multiple Selection case
  [dropdownOverlayView removeFromSuperview];
  dropdownOverlayView.hidden = YES;
}

- (void)dropdownView:(NSInteger)tag didRemoveItem:(id)item atIndex:(NSInteger)index {
  //remove operations
}

- (void)needAddItemToDropdownView:(NSInteger)tag andShow:(BOOL)shouldShow asCopy:(BOOL)copy {
  //add operations
}

- (NSInteger)dropdownView:(XRDropdownView *)dropdownView numberOfRowsInSection:(NSInteger)section
{
  return dataArray.count;
}

- (id)dropdownView:(XRDropdownView *)dropdownView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *CellIdentifier = needSampleImage ? @"XRDropdownViewImageCell" : @"XRDropdownViewCell";
  id cell = [dropdownView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  if (!needSampleImage) {
    
    [[NSBundle mainBundle] loadNibNamed:@"XRDropdownViewCell" owner:self options:nil];
    
    _dropdownCell.label.text = [dataArray objectAtIndex:indexPath.row];
    _dropdownCell.label.font = [UIFont fontWithName:@"Lato-Regular" size:13.0];
    _dropdownCell.label.textColor = [UIColor whiteColor];
    _dropdownCell.checkImage.hidden = YES;
    
    cell = _dropdownCell;
    _dropdownCell = nil;
    
  }else{
    [[NSBundle mainBundle] loadNibNamed:@"XRDropdownViewImageCell" owner:self options:nil];
    
    _dropdownImageCell.label.text = [dataArray objectAtIndex:indexPath.row];
    _dropdownImageCell.label.font = [UIFont fontWithName:@"Lato-Regular" size:13.0];
    _dropdownImageCell.label.textColor = [UIColor whiteColor];
    _dropdownImageCell.checkImage.hidden = YES;
    _dropdownImageCell.cellImage.image = sampleImages[indexPath.row] ? sampleImages[indexPath.row] : nil;
    
    cell = _dropdownImageCell;
    _dropdownImageCell = nil;
  }
  
  return cell;
}

- (void)dropdownView:(XRDropdownView *)dropdownView didSelectCellAtIndexPath:(NSIndexPath *)indexPath
{
  if (!_needMultipleSelection) {
    //    NSLog(@"###Cell selected###");
    _currentSelectedIndexPath = indexPath;
    [self setSelectedValue:[dataArray objectAtIndex:indexPath.row] atIndex:indexPath.row forDropdownView:self.tag];
  }else{
    //    NSLog(@"###Multiple cells selected##");
    NSArray *selectedIndexpaths = [dropdownView indexPathsForSelectedRows];
    NSMutableArray *selectedValues = [NSMutableArray array];
    NSMutableArray *selectedRows = [NSMutableArray array];
    for (int i = 0; i < selectedIndexpaths.count; i++) {
      NSString *aValue = [dataArray objectAtIndex:[selectedIndexpaths[i] row]];
      [selectedValues addObject:aValue];
      [selectedRows addObject:@([selectedIndexpaths[i] row])];
    }
    [self setSelectedValues:selectedValues atIndexes:selectedRows forDropdownView:self.tag];
  }
}

@end
