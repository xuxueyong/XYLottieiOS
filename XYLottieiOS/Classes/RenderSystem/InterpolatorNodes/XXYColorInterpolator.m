//
//  XXYColorInterpolator.m
//  XXYtie
//
//  Created by brandon_withrow on 7/13/17.
//  Copyright © 2017 Airbnb. All rights reserved.
//

#import "XXYColorInterpolator.h"
#import "XXYPlatformCompat.h"
#import "UIColor+Expanded.h"

@implementation XXYColorInterpolator

- (UIColor *)colorForFrame:(NSNumber *)frame {
  CGFloat progress = [self progressForFrame:frame];
  if (progress == 0) {
    return self.leadingKeyframe.colorValue;
  }
  if (progress == 1) {
    return self.trailingKeyframe.colorValue;
  }
  UIColor *returnColor = [UIColor XXY_colorByLerpingFromColor:self.leadingKeyframe.colorValue toColor:self.trailingKeyframe.colorValue amount:progress];
  return returnColor;
}

- (id)keyframeDataForValue:(id)value {
  if ([value isKindOfClass:[UIColor class]]) {
    NSArray *colorComponents = [(UIColor *)value XXY_arrayFromRGBAComponents];
    return colorComponents;
  }
  return nil;
}

@end
