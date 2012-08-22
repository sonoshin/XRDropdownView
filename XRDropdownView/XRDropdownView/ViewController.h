//
//  ViewController.h
//  XRDropdownView
//
//  Created by Xinrui Gao on 22/08/12.
//  Copyright (c) 2012 Xinrui Gao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XRDropdownView.h"

@interface ViewController : UIViewController <XRDropdownViewDelegate>

@property (strong, nonatomic) IBOutletCollection(XRDropdownView) NSArray *dropdownViews;

@end
