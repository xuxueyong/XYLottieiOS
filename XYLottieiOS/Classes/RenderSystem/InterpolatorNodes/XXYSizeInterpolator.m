//
//  XXYSizeInterpolator.m
//  XXYtie
//
//  Created by brandon_withrow on 7/13/17.
//  Copyright © 2017 Airbnb. All rights reserved.
//

#import "XXYPlatformCompat.h"
#import "XXYSizeInterpolator.h"
#import "CGGeometry+XXYAdditions.h"

@implementation XXYSizeInterpolator

- (CGSize)sizeValueForFrame:(NSNumber *)frame {
  CGFloat progress = [self progressForFrame:frame];
  if (progress == 0) {
    return self.leadingKeyframe.sizeValue;
  }
  if (progress == 1) {
    return self.trailingKeyframe.sizeValue;
  }
  return CGSizeMake(XXY_RemapValue(progress, 0, 1, self.leadingKeyframe.sizeValue.width, self.trailingKeyframe.sizeValue.width),
                    XXY_RemapValue(progress, 0, 1, self.leadingKeyframe.sizeValue.height, self.trailingKeyframe.sizeValue.height));
}

- (id)keyframeDataForValue:(id)value {
  if ([value isKindOfClass:[NSValue class]]) {
    CGSize sizeValue = [(NSValue *)value CGSizeValue];
    return @[@(sizeValue.width), @(sizeValue.height)];
  }
  return nil;
}

@end
