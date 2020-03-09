//
//  XXYMaskContainer.m
//  XXYtie
//
//  Created by brandon_withrow on 7/19/17.
//  Copyright © 2017 Airbnb. All rights reserved.
//

#import "XXYMaskContainer.h"
#import "XXYPathInterpolator.h"
#import "XXYNumberInterpolator.h"

@interface XXYMaskNodeLayer : CAShapeLayer

@property (nonatomic, readonly) XXYMask *maskNode;

- (instancetype)initWithMask:(XXYMask *)maskNode;
- (BOOL)hasUpdateForFrame:(NSNumber *)frame;

@end

@implementation XXYMaskNodeLayer {
  XXYPathInterpolator *_pathInterpolator;
  XXYNumberInterpolator *_opacityInterpolator;
  XXYNumberInterpolator *_expansionInterpolator;
}

- (instancetype)initWithMask:(XXYMask *)maskNode {
  self = [super init];
  if (self) {
    _pathInterpolator = [[XXYPathInterpolator alloc] initWithKeyframes:maskNode.maskPath.keyframes];
    _opacityInterpolator = [[XXYNumberInterpolator alloc] initWithKeyframes:maskNode.opacity.keyframes];
    _expansionInterpolator = [[XXYNumberInterpolator alloc] initWithKeyframes:maskNode.expansion.keyframes];
    _maskNode = maskNode;
    self.fillColor = [UIColor blueColor].CGColor;
  }
  return self;
}

- (void)updateForFrame:(NSNumber *)frame withViewBounds:(CGRect)viewBounds {
  if ([self hasUpdateForFrame:frame]) {
    XXYBezierPath *path = [_pathInterpolator pathForFrame:frame cacheLengths:NO];
    
    if (self.maskNode.maskMode == XXYMaskModeSubtract) {
      CGMutablePathRef pathRef = CGPathCreateMutable();
      CGPathAddRect(pathRef, NULL, viewBounds);
      CGPathAddPath(pathRef, NULL, path.CGPath);
      self.path = pathRef;
      self.fillRule = @"even-odd";
      CGPathRelease(pathRef);
    } else {
      self.path = path.CGPath;
    }
    
    self.opacity = [_opacityInterpolator floatValueForFrame:frame];
  }
}

- (BOOL)hasUpdateForFrame:(NSNumber *)frame {
  return ([_pathInterpolator hasUpdateForFrame:frame] ||
          [_opacityInterpolator hasUpdateForFrame:frame]);
}

@end

@implementation XXYMaskContainer {
  NSArray<XXYMaskNodeLayer *> *_masks;
}

- (instancetype)initWithMasks:(NSArray<XXYMask *> *)masks {
  self = [super init];
  if (self) {
    NSMutableArray *maskNodes = [NSMutableArray array];
    CALayer *containerLayer = [CALayer layer];
    
    for (XXYMask *mask in masks) {
      XXYMaskNodeLayer *node = [[XXYMaskNodeLayer alloc] initWithMask:mask];
      [maskNodes addObject:node];
      if (mask.maskMode == XXYMaskModeAdd ||
          mask == masks.firstObject) {
        [containerLayer addSublayer:node];
      } else {
        containerLayer.mask = node;
        CALayer *newContainer = [CALayer layer];
        [newContainer addSublayer:containerLayer];
        containerLayer = newContainer;
      }
    }
    [self addSublayer:containerLayer];
    _masks = maskNodes;

  }
  return self;
}

- (void)setCurrentFrame:(NSNumber *)currentFrame {
  if (_currentFrame == currentFrame) {
    return;
  }
  _currentFrame = currentFrame;
  
  for (XXYMaskNodeLayer *nodeLayer in _masks) {
    [nodeLayer updateForFrame:currentFrame withViewBounds:self.bounds];
  }
}

@end
