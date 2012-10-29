//
//  XRDropdownViewImageCell.m
//  GArch-iOS
//
//  Created by Xinrui Gao on 28/09/12.
//  Copyright (c) 2012 Karim Sallam. All rights reserved.
//

#import "XRDropdownViewImageCell.h"

@implementation XRDropdownViewImageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Initialization code
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
  [super setSelected:selected animated:animated];
  if (selected) {
    [self setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WishlistButtonStyle2"]]];
    self.label.textColor = [UIColor colorWithRed:174.0/255.0 green:154.0/255.0 blue:142.0/255.0 alpha:1.0];
    self.checkImage.hidden = NO;
  }else{
    [self setBackgroundView:nil];
    self.label.textColor = [UIColor whiteColor];
    self.checkImage.hidden = YES;
  }
}

@end
