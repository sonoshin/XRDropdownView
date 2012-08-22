//
//  ViewController.m
//  XRDropdownView
//
//  Created by Xinrui Gao on 22/08/12.
//  Copyright (c) 2012 Xinrui Gao. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize dropdownViews;

- (void)viewDidLoad
{
  [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  NSArray *dataArray = [[NSArray alloc] initWithObjects:
                        [[NSArray alloc] initWithObjects:@"test11", @"test12", @"test13", @"test14", @"test15", @"test16", @"test17", nil],
                        [[NSArray alloc] initWithObjects:@"test21", @"test22", @"test23", @"test24", @"test25", nil],
                        [[NSArray alloc] initWithObjects:@"test31", @"test32", @"test33", @"test34", nil],
                        [[NSArray alloc] initWithObjects:@"test41", @"test42", @"test43", @"test44", @"test45", @"test46", @"test47", @"test48", nil],
                        [[NSArray alloc] initWithObjects:@"test51", @"test52", @"test53", nil],
                        [[NSArray alloc] initWithObjects:@"test61", @"test62", @"test63", @"test64", @"test65", @"test66", @"test67", @"test68", @"test69", nil]
                        , nil];
  NSArray *titleArray = [[NSArray alloc] initWithObjects:@"test1", @"test2", @"test3", @"test4", @"test5", @"test6", nil];
  
  for (int i = 0; i < dropdownViews.count; i++) {
    [[dropdownViews objectAtIndex:i] setData:[dataArray objectAtIndex:i] withTitle:[titleArray objectAtIndex:i]];
  }

}

- (void)viewDidUnload
{
  [self setDropdownViews:nil];
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

#pragma mark - DropdownViewDelegate

- (void)setSelectedValue:(NSString *)value {
  NSLog(@"%@ is selected", value);
}

@end
