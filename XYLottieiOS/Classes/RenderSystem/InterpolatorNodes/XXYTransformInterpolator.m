//
//  XXYTransformInterpolator.m
//  XXYtie
//
//  Created by brandon_withrow on 7/18/17.
//  Copyright © 2017 Airbnb. All rights reserved.
//

#import "XXYTransformInterpolator.h"

// TODO BW Perf update, Cache transform

@implementation XXYTransformInterpolator {
  XXYPointInterpolator *_positionInterpolator;
  XXYPointInterpolator *_anchorInterpolator;
  XXYSizeInterpolator *_scaleInterpolator;
  XXYNumberInterpolator *_rotationInterpolator;
  XXYNumberInterpolator *_positionXInterpolator;
  XXYNumberInterpolator *_positionYInterpolator;
}

+ (instancetype)transformForLayer:(XXYLayer *)layer {
  XXYTransformInterpolator *interpolator = nil;
  if (layer.position) {
    interpolator = [[XXYTransformInterpolator alloc] initWithPosition:layer.position.keyframes
                                                             rotation:layer.rotation.keyframes
                                                               anchor:layer.anchor.keyframes
                                                                scale:layer.scale.keyframes];
  } else {
    interpolator = [[XXYTransformInterpolator alloc] initWithPositionX:layer.positionX.keyframes
                                                             positionY:layer.positionY.keyframes
                                                              rotation:layer.rotation.keyframes
                                                                anchor:layer.anchor.keyframes
                                                                 scale:layer.scale.keyframes];
  }
  interpolator.parentKeyName = [layer.layerName copy];
  return interpolator;
}

- (instancetype)initWithPosition:(NSArray <XXYKeyframe *> *)position
                        rotation:(NSArray <XXYKeyframe *> *)rotation
                          anchor:(NSArray <XXYKeyframe *> *)anchor
                           scale:(NSArray <XXYKeyframe *> *)scale {
  self = [super init];
  if (self) {
    [self initializeWithPositionX:nil positionY:nil position:position rotation:rotation anchor:anchor scale:scale];
  }
  return self;
}

- (instancetype)initWithPositionX:(NSArray <XXYKeyframe *> *)positionX
                        positionY:(NSArray <XXYKeyframe *> *)positionY
                         rotation:(NSArray <XXYKeyframe *> *)rotation
                           anchor:(NSArray <XXYKeyframe *> *)anchor
                            scale:(NSArray <XXYKeyframe *> *)scale {
  self = [super init];
  if (self) {
    [self initializeWithPositionX:positionX positionY:positionY position:nil rotation:rotation anchor:anchor scale:scale];
  }
  return self;
}


- (void)initializeWithPositionX:(NSArray <XXYKeyframe *> *)positionX
                      positionY:(NSArray <XXYKeyframe *> *)positionY
                       position:(NSArray <XXYKeyframe *> *)position
                       rotation:(NSArray <XXYKeyframe *> *)rotation
                         anchor:(NSArray <XXYKeyframe *> *)anchor
                          scale:(NSArray <XXYKeyframe *> *)scale {
  
  if (position) {
    _positionInterpolator = [[XXYPointInterpolator alloc] initWithKeyframes:position];
  }
  if (positionY) {
    _positionYInterpolator = [[XXYNumberInterpolator alloc] initWithKeyframes:positionY];
  }
  if (positionX) {
    _positionXInterpolator = [[XXYNumberInterpolator alloc] initWithKeyframes:positionX];
  }
  _anchorInterpolator = [[XXYPointInterpolator alloc] initWithKeyframes:anchor];
  _scaleInterpolator = [[XXYSizeInterpolator alloc] initWithKeyframes:scale];
  _rotationInterpolator = [[XXYNumberInterpolator alloc] initWithKeyframes:rotation];
}

- (BOOL)hasUpdateForFrame:(NSNumber *)frame {
  BOOL inputUpdate = _inputNode ? [_inputNode hasUpdateForFrame:frame] : NO;
  if (inputUpdate) {
    return inputUpdate;
  }
  if (_positionInterpolator) {
    return ([_positionInterpolator hasUpdateForFrame:frame] ||
            [_anchorInterpolator hasUpdateForFrame:frame] ||
            [_scaleInterpolator hasUpdateForFrame:frame] ||
            [_rotationInterpolator hasUpdateForFrame:frame]);
  }
  return ([_positionXInterpolator hasUpdateForFrame:frame] ||
          [_positionYInterpolator hasUpdateForFrame:frame] ||
          [_anchorInterpolator hasUpdateForFrame:frame] ||
          [_scaleInterpolator hasUpdateForFrame:frame] ||
          [_rotationInterpolator hasUpdateForFrame:frame]);
}

- (CATransform3D)transformForFrame:(NSNumber *)frame {
  CATransform3D baseXform = CATransform3DIdentity;
  if (_inputNode) {
    baseXform = [_inputNode transformForFrame:frame];
  }
  CGPoint position = CGPointZero;
  if (_positionInterpolator) {
    position = [_positionInterpolator pointValueForFrame:frame];
  }
  if (_positionXInterpolator &&
      _positionYInterpolator) {
    position.x = [_positionXInterpolator floatValueForFrame:frame];
    position.y = [_positionYInterpolator floatValueForFrame:frame];
  }
  CGPoint anchor = [_anchorInterpolator pointValueForFrame:frame];
  CGSize scale = [_scaleInterpolator sizeValueForFrame:frame];
  CGFloat rotation = [_rotationInterpolator floatValueForFrame:frame];
  CATransform3D translateXform = CATransform3DTranslate(baseXform, position.x, position.y, 0);
  CATransform3D rotateXform = CATransform3DRotate(translateXform, rotation, 0, 0, 1);
  CATransform3D scaleXform = CATransform3DScale(rotateXform, scale.width, scale.height, 1);
  CATransform3D anchorXform = CATransform3DTranslate(scaleXform, -1 * anchor.x, -1 * anchor.y, 0);
  return anchorXform;
}

@end
