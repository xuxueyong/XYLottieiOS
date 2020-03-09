//
//  XXYRepeaterRenderer.m
//  XXYtie
//
//  Created by brandon_withrow on 7/28/17.
//  Copyright © 2017 Airbnb. All rights reserved.
//

#import "XXYRepeaterRenderer.h"
#import "XXYTransformInterpolator.h"
#import "XXYNumberInterpolator.h"
#import "XXYHelpers.h"

@implementation XXYRepeaterRenderer {
  XXYTransformInterpolator *_transformInterpolator;
  XXYNumberInterpolator *_copiesInterpolator;
  XXYNumberInterpolator *_offsetInterpolator;
  XXYNumberInterpolator *_startOpacityInterpolator;
  XXYNumberInterpolator *_endOpacityInterpolator;
  
  CALayer *_instanceLayer;
  CAReplicatorLayer *_replicatorLayer;
  CALayer *centerPoint_DEBUG;
}

- (instancetype)initWithInputNode:(XXYAnimatorNode *)inputNode
                              shapeRepeater:(XXYShapeRepeater *)repeater {
  self = [super initWithInputNode:inputNode keyName:repeater.keyname];
  if (self) {
    _transformInterpolator = [[XXYTransformInterpolator alloc] initWithPosition:repeater.position.keyframes
                                                                       rotation:repeater.rotation.keyframes
                                                                         anchor:repeater.anchorPoint.keyframes
                                                                          scale:repeater.scale.keyframes];
    _copiesInterpolator = [[XXYNumberInterpolator alloc] initWithKeyframes:repeater.copies.keyframes];
    _offsetInterpolator = [[XXYNumberInterpolator alloc] initWithKeyframes:repeater.offset.keyframes];
    _startOpacityInterpolator = [[XXYNumberInterpolator alloc] initWithKeyframes:repeater.startOpacity.keyframes];
    _endOpacityInterpolator = [[XXYNumberInterpolator alloc] initWithKeyframes:repeater.endOpacity.keyframes];
    
    _instanceLayer = [CALayer layer];
    [self recursivelyAddChildLayers:inputNode];
    
    _replicatorLayer = [CAReplicatorLayer layer];
    _replicatorLayer.actions = @{@"instanceCount" : [NSNull null],
                                 @"instanceTransform" : [NSNull null],
                                 @"instanceAlphaOffset" : [NSNull null]};
    [_replicatorLayer addSublayer:_instanceLayer];
    [self.outputLayer addSublayer:_replicatorLayer];
    
    centerPoint_DEBUG = [CALayer layer];
    centerPoint_DEBUG.bounds = CGRectMake(0, 0, 20, 20);
    if (ENABLE_DEBUG_SHAPES) {
      [self.outputLayer addSublayer:centerPoint_DEBUG];
    }
  }
  return self;
}

- (NSDictionary *)valueInterpolators {
  return @{@"Copies" : _copiesInterpolator,
           @"Offset" : _offsetInterpolator,
           @"Transform.Anchor Point" : _transformInterpolator.anchorInterpolator,
           @"Transform.Position" : _transformInterpolator.positionInterpolator,
           @"Transform.Scale" : _transformInterpolator.scaleInterpolator,
           @"Transform.Rotation" : _transformInterpolator.rotationInterpolator,
           @"Transform.Start Opacity" : _startOpacityInterpolator,
           @"Transform.End Opacity" : _endOpacityInterpolator};
}

- (void)recursivelyAddChildLayers:(XXYAnimatorNode *)node {
  if ([node isKindOfClass:[XXYRenderNode class]]) {
    [_instanceLayer addSublayer:[(XXYRenderNode *)node outputLayer]];
  }
  if (![node isKindOfClass:[XXYRepeaterRenderer class]] &&
      node.inputNode) {
    [self recursivelyAddChildLayers:node.inputNode];
  }
}

- (BOOL)needsUpdateForFrame:(NSNumber *)frame {
  // TODO BW Add offset ability
  return ([_transformInterpolator hasUpdateForFrame:frame] ||
          [_copiesInterpolator hasUpdateForFrame:frame] ||
          [_startOpacityInterpolator hasUpdateForFrame:frame] ||
          [_endOpacityInterpolator hasUpdateForFrame:frame]);
}

- (void)performLocalUpdate {
  centerPoint_DEBUG.backgroundColor =  [UIColor greenColor].CGColor;
  centerPoint_DEBUG.borderColor = [UIColor lightGrayColor].CGColor;
  centerPoint_DEBUG.borderWidth = 2.f;
  
  CGFloat copies = ceilf([_copiesInterpolator floatValueForFrame:self.currentFrame]);
  _replicatorLayer.instanceCount = (NSInteger)copies;
  _replicatorLayer.instanceTransform = [_transformInterpolator transformForFrame:self.currentFrame];
  CGFloat startOpacity = [_startOpacityInterpolator floatValueForFrame:self.currentFrame];
  CGFloat endOpacity = [_endOpacityInterpolator floatValueForFrame:self.currentFrame];
  CGFloat opacityStep = (endOpacity - startOpacity) / copies;
  _instanceLayer.opacity = startOpacity;
  _replicatorLayer.instanceAlphaOffset = opacityStep;
}

@end
