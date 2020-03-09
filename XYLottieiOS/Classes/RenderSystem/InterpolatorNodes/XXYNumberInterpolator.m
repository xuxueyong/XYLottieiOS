//
//  XXYNumberInterpolator.m
//  XXYtie
//
//  Created by brandon_withrow on 7/11/17.
//  Copyright © 2017 Airbnb. All rights reserved.
//

#import "XXYNumberInterpolator.h"
#import "CGGeometry+XXYAdditions.h"

@implementation XXYNumberInterpolator

- (CGFloat)floatValueForFrame:(NSNumber *)frame {
  CGFloat progress = [self progressForFrame:frame];
  if (progress == 0) {
    return self.leadingKeyframe.floatValue;
  }
  if (progress == 1) {
    return self.trailingKeyframe.floatValue;
  }
  return XXY_RemapValue(progress, 0, 1, self.leadingKeyframe.floatValue, self.trailingKeyframe.floatValue);
}

- (id)keyframeDataForValue:(id)value {
  if ([value isKindOfClass:[NSNumber class]]) {
    return value;
  }
  return nil;
}

@end
