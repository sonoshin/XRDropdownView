//
//  XRDropdownView.m
//  XRDropdownView
//
//  Created by Xinrui Gao on 20/08/12.
//  Copyright (c) 2012 Jusan Network. All rights reserved.
//

#import "XRDropdownView.h"

@implementation XRDropdownView

- (void)awakeFromNib {
  
  [super awakeFromNib];
  NSLog(@"###Awake from nib###");
  [self initialization];
  NSLog(@"Self.frame:  %f, %f, %f, %f", self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (void)initialization {
  NSLog(@"###Initialization started###");
  self.backgroundColor = [UIColor clearColor];
  
//  self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToDismiss:)];
//  self.tapGestureRecognizer.delegate = self;
//
//  [self.superview addGestureRecognizer:self.tapGestureRecognizer];
}

- (void)setData:(NSArray *)data withTitle:(NSString *)title {
  dataArray = data;
  [self setButtonWithTitle:title];
  [self setDropdownTableWithDataSource:self andDelegate:self andTableHeight:44.0*data.count];
}

- (void)setButtonWithTitle:(NSString *)title
{
  NSLog(@"###Dropdown button setup###");
  
  self.dropdownButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)];
  self.dropdownButton.backgroundColor = [UIColor greenColor];
  [self.dropdownButton setTitle:title forState:UIControlStateNormal];
  [self.dropdownButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [self.dropdownButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
  [self addSubview:self.dropdownButton];
  [self.dropdownButton addTarget:self action:@selector(openDropdownList:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setDropdownTableWithDataSource:(id)dataSource andDelegate:(id)delegate andTableHeight:(CGFloat)height
{
  NSLog(@"###Dropdown table setup###");
   
  self.dropdownTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -height, self.frame.size.width, height)];
  self.dropdownScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0+self.frame.size.height, self.frame.size.width, self.dropdownTableView.frame.size.height)];
  self.dropdownScrollView.backgroundColor = [UIColor clearColor];
  
  self.dropdownTableView.delegate = delegate;
  self.dropdownTableView.dataSource = dataSource;
  
  [self.dropdownScrollView addSubview:self.dropdownTableView];
  [self addSubview:self.dropdownScrollView];

}
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
//  CGPoint pointInView = [touch locationInView:gestureRecognizer.view];
//  NSLog(@"Point in view: %f, %f\nself.frame: %f, %f, %f, %f", pointInView.x, pointInView.y, self.frame.origin.x, self.frame.origin.y, self.frame.size.height, self.frame.size.width);
//  if (CGRectContainsPoint(self.frame, pointInView)) {
//    NSLog(@"In view");
//    return NO;
//  }else {
//    return YES;
//  }
//}
//
//- (void)tapToDismiss:(UITapGestureRecognizer *)recognizer {
//  NSLog(@"##Tap received##");
//  [self.dropdownButton setSelected:NO];
//  [UIView animateWithDuration:0.3 animations:^{
//    self.dropdownScrollView.contentOffset = CGPointMake(0.0, 0.0);
//    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.dropdownButton.frame.size.height)];
//  }];
//}

- (void)openDropdownList:(UIButton *)sender {
  if (sender.isSelected) {
    [sender setSelected:NO];
    [UIView animateWithDuration:0.2 animations:^{
      self.dropdownScrollView.contentOffset = CGPointZero;
      [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.dropdownButton.frame.size.height)];
    }];
  }else {
    for (UIView *aView in self.superview.subviews) {
      if ([aView isKindOfClass:[XRDropdownView class]]) {
        [((XRDropdownView *)aView).dropdownButton setSelected:NO];
        [UIView animateWithDuration:0.2 animations:^{
          ((XRDropdownView *)aView).dropdownScrollView.contentOffset = CGPointZero;
          [((XRDropdownView *)aView) setFrame:CGRectMake(((XRDropdownView *)aView).frame.origin.x, ((XRDropdownView *)aView).frame.origin.y, ((XRDropdownView *)aView).frame.size.width, ((XRDropdownView *)aView).dropdownButton.frame.size.height)];
        }];
      }
    }
    [self.superview bringSubviewToFront:self];
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.dropdownTableView.frame.size.height+self.frame.size.height)];
    [sender setSelected:YES];
    [UIView animateWithDuration:0.2 animations:^{
      self.dropdownScrollView.contentOffset = CGPointMake(0.0, -self.dropdownTableView.frame.size.height);
    }];
  }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
  cell.textLabel.text = [dataArray objectAtIndex:indexPath.row];
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSLog(@"###Cell selected###");
  [self.delegate setSelectedValue:[dataArray objectAtIndex:indexPath.row]];
  [self.dropdownButton setSelected:NO];
  [UIView animateWithDuration:0.2 animations:^{
    self.dropdownScrollView.contentOffset = CGPointMake(0.0, 0.0);
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.dropdownButton.frame.size.height)];
  }];
}

@end
