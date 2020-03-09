//
//  XXYPathInterpolator.m
//  XXYtie
//
//  Created by brandon_withrow on 7/13/17.
//  Copyright © 2017 Airbnb. All rights reserved.
//

#import "XXYPathInterpolator.h"
#import "CGGeometry+XXYAdditions.h"

@implementation XXYPathInterpolator

- (XXYBezierPath *)pathForFrame:(NSNumber *)frame cacheLengths:(BOOL)cacheLengths {
  CGFloat progress = [self progressForFrame:frame];
  
  XXYBezierPath *returnPath = [[XXYBezierPath alloc] init];
  returnPath.cacheLengths = cacheLengths;
  XXYBezierData *leadingData = self.leadingKeyframe.pathData;
  XXYBezierData *trailingData = self.trailingKeyframe.pathData;
  NSInteger vertexCount = leadingData ? leadingData.count : trailingData.count;
  BOOL closePath = leadingData ? leadingData.closed : trailingData.closed;
  CGPoint cp1 = CGPointMake(0, 0);
  CGPoint cp2, p1, cp3 = CGPointZero;
  CGPoint startPoint = CGPointMake(0, 0);
  CGPoint startInTangent = CGPointMake(0, 0);
  for (int i = 0; i < vertexCount; i++) {
    if (progress == 0) {
      cp2 = [leadingData inTangentAtIndex:i];
      p1 = [leadingData vertexAtIndex:i];
      cp3 = [leadingData outTangentAtIndex:i];
    } else if (progress == 1) {
      cp2 = [trailingData inTangentAtIndex:i];
      p1 = [trailingData vertexAtIndex:i];
      cp3 = [trailingData outTangentAtIndex:i];
    } else {
      cp2 = XXY_PointInLine([leadingData inTangentAtIndex:i],
                            [trailingData inTangentAtIndex:i],
                            progress);
      p1 = XXY_PointInLine([leadingData vertexAtIndex:i],
                           [trailingData vertexAtIndex:i],
                           progress);
      cp3 = XXY_PointInLine([leadingData outTangentAtIndex:i],
                            [trailingData outTangentAtIndex:i],
                            progress);
    }
    if (i == 0) {
      startPoint = p1;
      startInTangent = cp2;
      [returnPath XXY_moveToPoint:p1];
    } else {
      [returnPath XXY_addCurveToPoint:p1 controlPoint1:cp1 controlPoint2:cp2];
    }
    cp1 = cp3;
  }
  
  if (closePath) {
    [returnPath XXY_addCurveToPoint:startPoint controlPoint1:cp3 controlPoint2:startInTangent];
    [returnPath XXY_closePath];
  }

  return returnPath;
}

@end
