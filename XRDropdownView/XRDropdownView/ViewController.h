//
//  ViewController.h
//  XRDropdownView
//
//  Created by Xinrui Gao on 22/08/12.
//  Copyright (c) 2012 Xinrui Gao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XRDropdownView.h"
#import "XRDropdownViewCell.h"
#import "XRDropdownViewImageCell.h"

@interface ViewController : UIViewController <XRDropdownViewDelegate, XRDropdownViewDataSource, UIGestureRecognizerDelegate>

@property (strong, nonatomic) XRDropdownView *testDropdownView;

@property (strong, nonatomic) IBOutlet XRDropdownViewCell *dropdownCell;
@property (strong, nonatomic) IBOutlet XRDropdownViewImageCell *dropdownImageCell;

@end
