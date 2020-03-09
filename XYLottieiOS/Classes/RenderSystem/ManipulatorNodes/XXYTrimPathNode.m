//
//  XXYTrimPathNode.m
//  XXYtie
//
//  Created by brandon_withrow on 7/21/17.
//  Copyright © 2017 Airbnb. All rights reserved.
//

#import "XXYTrimPathNode.h"
#import "XXYNumberInterpolator.h"
#import "XXYPathAnimator.h"
#import "XXYCircleAnimator.h"
#import "XXYRoundedRectAnimator.h"
#import "XXYRenderGroup.h"

@implementation XXYTrimPathNode {
  XXYNumberInterpolator *_startInterpolator;
  XXYNumberInterpolator *_endInterpolator;
  XXYNumberInterpolator *_offsetInterpolator;
  
  CGFloat _startT;
  CGFloat _endT;
  CGFloat _offsetT;
}

- (instancetype _Nonnull)initWithInputNode:(XXYAnimatorNode *_Nullable)inputNode
                                   trimPath:(XXYShapeTrimPath *_Nonnull)trimPath {
  self = [super initWithInputNode:inputNode keyName:trimPath.keyname];
  if (self) {
    inputNode.pathShouldCacheLengths = YES;
    _startInterpolator = [[XXYNumberInterpolator alloc] initWithKeyframes:trimPath.start.keyframes];
    _endInterpolator = [[XXYNumberInterpolator alloc] initWithKeyframes:trimPath.end.keyframes];
    _offsetInterpolator = [[XXYNumberInterpolator alloc] initWithKeyframes:trimPath.offset.keyframes];
  }
  return self;
}

- (NSDictionary *)valueInterpolators {
  return @{@"Start" : _startInterpolator,
           @"End" : _endInterpolator,
           @"Offset" : _offsetInterpolator};
}

- (BOOL)needsUpdateForFrame:(NSNumber *)frame {
  return ([_startInterpolator hasUpdateForFrame:frame] ||
          [_endInterpolator hasUpdateForFrame:frame] ||
          [_offsetInterpolator hasUpdateForFrame:frame]);
}

- (BOOL)updateWithFrame:(NSNumber *)frame
      withModifierBlock:(void (^ _Nullable)(XXYAnimatorNode * _Nonnull))modifier
       forceLocalUpdate:(BOOL)forceUpdate {
  BOOL localUpdate = [self needsUpdateForFrame:frame];
  [self forceSetCurrentFrame:frame];
  if (localUpdate) {
    [self performLocalUpdate];
  }
  if (self.inputNode == nil) {
    return localUpdate;
  }
  
  BOOL inputUpdated = [self.inputNode updateWithFrame:frame withModifierBlock:^(XXYAnimatorNode * _Nonnull inputNode) {
    if ([inputNode isKindOfClass:[XXYPathAnimator class]] ||
        [inputNode isKindOfClass:[XXYCircleAnimator class]] ||
        [inputNode isKindOfClass:[XXYRoundedRectAnimator class]]) {
      [inputNode.localPath trimPathFromT:_startT toT:_endT offset:_offsetT];
    }
    if (modifier) {
      modifier(inputNode);
    }
    
  } forceLocalUpdate:(localUpdate || forceUpdate)];
  
  return inputUpdated;
}

- (void)performLocalUpdate {
  _startT = [_startInterpolator floatValueForFrame:self.currentFrame] / 100;
  _endT = [_endInterpolator floatValueForFrame:self.currentFrame] / 100;
  _offsetT = [_offsetInterpolator floatValueForFrame:self.currentFrame] / 360;
}

- (void)rebuildOutputs {
  // Skip this step.
}

- (XXYBezierPath *)localPath {
  return self.inputNode.localPath;
}

/// Forwards its input node's output path forwards downstream
- (XXYBezierPath *)outputPath {
  return self.inputNode.outputPath;
}

@end
