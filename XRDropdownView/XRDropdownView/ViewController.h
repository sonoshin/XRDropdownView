//
//  ViewController.h
//  XRDropdownView
//
//  Created by Xinrui Gao on 22/08/12.
//  Copyright (c) 2012 Xinrui Gao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XRDropdownView.h"

@interface ViewController : UIViewController <XRDropdownViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet XRDropdownView *normalDropdownView1;
@property (weak, nonatomic) IBOutlet XRDropdownView *normalDropdownView2;
@property (weak, nonatomic) IBOutlet XRDropdownView *imageDropdownView1;
@property (weak, nonatomic) IBOutlet XRDropdownView *imageDropdownView2;

@end
