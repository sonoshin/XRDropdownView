//
//  ViewController.m
//  XRDropdownView
//
//  Created by Xinrui Gao on 22/08/12.
//  Copyright (c) 2012 Xinrui Gao. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
  UIView *dropdownOverlayView;
  NSArray *dataArray;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  dataArray = [[NSArray alloc] initWithObjects:
                        [[NSArray alloc] initWithObjects:@"test01", @"test02", @"test03", @"test04", @"test05", @"test06", @"test07", @"test08", @"test09", nil],
                        [[NSArray alloc] initWithObjects:@"test11", @"test12", @"test13", @"test14", @"test15", @"test16", @"test17", nil],
                        [[NSArray alloc] initWithObjects:@"test21", @"test22", @"test23", @"test24", @"test25", nil],
                        [[NSArray alloc] initWithObjects:@"test31", @"test32", @"test33", @"test34", nil],
                        [[NSArray alloc] initWithObjects:@"test41", @"test42", @"test43", @"test44", @"test45", @"test46", @"test47", @"test48", nil],
                        [[NSArray alloc] initWithObjects:@"test51", @"test52", @"test53", nil]                        
                        , nil];
  
  _normalDropdownView1.needFooterButtons = NO;
  _normalDropdownView1.containerSize = self.view.frame.size;
  [_normalDropdownView1 setTag:0];
  [_normalDropdownView1 setNeedMultipleSelection:YES];
  [_normalDropdownView1 setData:dataArray[0] withTitle:@"one" needUpdateDropdownTitle:YES];
  
  _normalDropdownView2.needFooterButtons = YES;
  _normalDropdownView2.containerSize = self.view.frame.size;
  [_normalDropdownView2 setTag:1];
  [_normalDropdownView2 setNeedMultipleSelection:NO];
  [_normalDropdownView2 setData:dataArray[1] withTitle:@"two" needUpdateDropdownTitle:YES];
  
  _imageDropdownView1.needFooterButtons = NO;
  _imageDropdownView1.containerSize = self.view.frame.size;
  [_imageDropdownView1 setTag:2];
  [_imageDropdownView1 setNeedMultipleSelection:YES];
  [_imageDropdownView1 setNeedSampleImage:YES];
  [_imageDropdownView1 setSampleImages:nil];
  [_imageDropdownView1 setData:dataArray[2] withTitle:@"three" needUpdateDropdownTitle:YES];
  
  _imageDropdownView2.needFooterButtons = YES;
  _imageDropdownView2.containerSize = self.view.frame.size;
  [_imageDropdownView2 setTag:2];
  [_imageDropdownView2 setNeedMultipleSelection:NO];
  [_imageDropdownView2 setNeedSampleImage:YES];
  [_imageDropdownView2 setSampleImages:nil];
  [_imageDropdownView2 setData:dataArray[3] withTitle:@"four" needUpdateDropdownTitle:YES];

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

- (void)setSelectedValue:(NSString *)value atIndex:(NSInteger)index forDropdownView:(NSInteger)viewTag {
  NSLog(@"Dropdown view %d - item %@ is selected", viewTag, value);
  switch (viewTag) {
    case 0:
      break;
    case 1:
      break;
    case 2:
      break;
    case 3:
      break;
  }
}

//For multiple selection case
- (void)setSelectedValues:(NSArray *)values atIndexes:(NSArray *)indexes forDropdownView:(NSInteger)viewTag {
  if (dataArray[viewTag] != [NSNull null]) {
    for (int i = 0 ; i < indexes.count ; i++) {
      NSLog(@"Dropdown view %d - item %@ - %@ is selected", viewTag, indexes[i], values[i]);
    }
  }
  switch (viewTag) {
    case 0:
      break;
    case 1:
      break;
    case 2:
      break;
    case 3:
      break;
  }
}

- (void)dropdownViewDidOpen:(XRDropdownView *)dropdownView
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

- (void)dropdownViewDidClose:(XRDropdownView *)dropdownView
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

@end
