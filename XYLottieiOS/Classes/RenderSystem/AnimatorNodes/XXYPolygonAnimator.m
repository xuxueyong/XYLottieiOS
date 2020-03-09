//
//  XXYPolygonAnimator.m
//  XXYtie
//
//  Created by brandon_withrow on 7/27/17.
//  Copyright © 2017 Airbnb. All rights reserved.
//

#import "XXYPolygonAnimator.h"
#import "XXYKeyframe.h"
#import "XXYPointInterpolator.h"
#import "XXYNumberInterpolator.h"
#import "XXYBezierPath.h"
#import "CGGeometry+XXYAdditions.h"

const CGFloat kPOLYGON_MAGIC_NUMBER = .25f;

@implementation XXYPolygonAnimator {
  XXYNumberInterpolator *_outerRadiusInterpolator;
  XXYNumberInterpolator *_outerRoundnessInterpolator;
  XXYPointInterpolator *_positionInterpolator;
  XXYNumberInterpolator *_pointsInterpolator;
  XXYNumberInterpolator *_rotationInterpolator;
}

- (instancetype _Nonnull)initWithInputNode:(XXYAnimatorNode *_Nullable)inputNode
                             shapePolygon:(XXYShapeStar *_Nonnull)shapeStar {
  self = [super initWithInputNode:inputNode keyName:shapeStar.keyname];
  if (self) {
    _outerRadiusInterpolator = [[XXYNumberInterpolator alloc] initWithKeyframes:shapeStar.outerRadius.keyframes];
    _outerRoundnessInterpolator = [[XXYNumberInterpolator alloc] initWithKeyframes:shapeStar.outerRoundness.keyframes];
    _pointsInterpolator = [[XXYNumberInterpolator alloc] initWithKeyframes:shapeStar.numberOfPoints.keyframes];
    _rotationInterpolator = [[XXYNumberInterpolator alloc] initWithKeyframes:shapeStar.rotation.keyframes];
    _positionInterpolator = [[XXYPointInterpolator alloc] initWithKeyframes:shapeStar.position.keyframes];
  }
  return self;
}

- (NSDictionary *)valueInterpolators {
  return @{@"Points" : _pointsInterpolator,
           @"Position" : _positionInterpolator,
           @"Rotation" : _rotationInterpolator,
           @"Outer Radius" : _outerRadiusInterpolator,
           @"Outer Roundness" : _outerRoundnessInterpolator};
}

- (BOOL)needsUpdateForFrame:(NSNumber *)frame {
  return ([_outerRadiusInterpolator hasUpdateForFrame:frame] ||
          [_outerRoundnessInterpolator hasUpdateForFrame:frame] ||
          [_pointsInterpolator hasUpdateForFrame:frame] ||
          [_rotationInterpolator hasUpdateForFrame:frame] ||
          [_positionInterpolator hasUpdateForFrame:frame]);
}

- (void)performLocalUpdate {
  CGFloat outerRadius = [_outerRadiusInterpolator floatValueForFrame:self.currentFrame];
  CGFloat outerRoundness = [_outerRoundnessInterpolator floatValueForFrame:self.currentFrame] / 100.f;
  CGFloat points = [_pointsInterpolator floatValueForFrame:self.currentFrame];
  CGFloat rotation = [_rotationInterpolator floatValueForFrame:self.currentFrame];
  CGPoint position = [_positionInterpolator pointValueForFrame:self.currentFrame];
  
  XXYBezierPath *path = [[XXYBezierPath alloc] init];
  path.cacheLengths = self.pathShouldCacheLengths;
  CGFloat currentAngle = XXY_DegreesToRadians(rotation - 90);
  CGFloat anglePerPoint = (CGFloat)((2 * M_PI) / points);

  CGFloat x;
  CGFloat y;
  CGFloat previousX;
  CGFloat previousY;
  x = (CGFloat) (outerRadius * cosf(currentAngle));
  y = (CGFloat) (outerRadius * sinf(currentAngle));
  [path XXY_moveToPoint:CGPointMake(x, y)];
  currentAngle += anglePerPoint;
  
  double numPoints = ceil(points);
  for (int i = 0; i < numPoints; i++) {
    previousX = x;
    previousY = y;
    x = (CGFloat) (outerRadius * cosf(currentAngle));
    y = (CGFloat) (outerRadius * sinf(currentAngle));
    
    if (outerRoundness != 0) {
      CGFloat cp1Theta = (CGFloat) (atan2(previousY, previousX) - M_PI / 2.f);
      CGFloat cp1Dx = (CGFloat) cosf(cp1Theta);
      CGFloat cp1Dy = (CGFloat) sinf(cp1Theta);
      
      CGFloat cp2Theta = (CGFloat) (atan2(y, x) - M_PI / 2.f);
      CGFloat cp2Dx = (CGFloat) cosf(cp2Theta);
      CGFloat cp2Dy = (CGFloat) sinf(cp2Theta);
      
      CGFloat cp1x = outerRadius * outerRoundness * kPOLYGON_MAGIC_NUMBER * cp1Dx;
      CGFloat cp1y = outerRadius * outerRoundness * kPOLYGON_MAGIC_NUMBER * cp1Dy;
      CGFloat cp2x = outerRadius * outerRoundness * kPOLYGON_MAGIC_NUMBER * cp2Dx;
      CGFloat cp2y = outerRadius * outerRoundness * kPOLYGON_MAGIC_NUMBER * cp2Dy;
      [path XXY_addCurveToPoint:CGPointMake(x, y)
                  controlPoint1:CGPointMake(previousX - cp1x, previousY - cp1y)
                  controlPoint2:CGPointMake(x + cp2x, y + cp2y)];
    } else {
      [path XXY_addLineToPoint:CGPointMake(x, y)];
    }
    
    currentAngle += anglePerPoint;
  }
  [path XXY_closePath];
  [path XXY_applyTransform:CGAffineTransformMakeTranslation(position.x, position.y)];
  self.localPath = path;
}

@end
