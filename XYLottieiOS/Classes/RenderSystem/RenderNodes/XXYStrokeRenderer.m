//
//  XXYStrokeRenderer.m
//  XXYtie
//
//  Created by brandon_withrow on 7/17/17.
//  Copyright © 2017 Airbnb. All rights reserved.
//

#import "XXYStrokeRenderer.h"
#import "XXYColorInterpolator.h"
#import "XXYNumberInterpolator.h"

@implementation XXYStrokeRenderer {
  XXYColorInterpolator *_colorInterpolator;
  XXYNumberInterpolator *_opacityInterpolator;
  XXYNumberInterpolator *_widthInterpolator;
  XXYNumberInterpolator *_dashOffsetInterpolator;
  NSArray *_dashPatternInterpolators;
}

- (instancetype)initWithInputNode:(XXYAnimatorNode *)inputNode
                                shapeStroke:(XXYShapeStroke *)stroke {
  self = [super initWithInputNode:inputNode keyName:stroke.keyname];
  if (self) {
    _colorInterpolator = [[XXYColorInterpolator alloc] initWithKeyframes:stroke.color.keyframes];
    _opacityInterpolator = [[XXYNumberInterpolator alloc] initWithKeyframes:stroke.opacity.keyframes];
    _widthInterpolator = [[XXYNumberInterpolator alloc] initWithKeyframes:stroke.width.keyframes];
    
    NSMutableArray *dashPatternIntpolators = [NSMutableArray array];
    NSMutableArray *dashPatterns = [NSMutableArray array];
    for (XXYKeyframeGroup *keyframegroup in stroke.lineDashPattern) {
      XXYNumberInterpolator *interpolator = [[XXYNumberInterpolator alloc] initWithKeyframes:keyframegroup.keyframes];
      [dashPatternIntpolators addObject:interpolator];
      if (dashPatterns && keyframegroup.keyframes.count == 1) {
        XXYKeyframe *first = keyframegroup.keyframes.firstObject;
        [dashPatterns addObject:@(first.floatValue)];
      }
      if (keyframegroup.keyframes.count > 1) {
        dashPatterns = nil;
      }
    }
    
    if (dashPatterns.count) {
      self.outputLayer.lineDashPattern = dashPatterns;
    } else {
      _dashPatternInterpolators = dashPatternIntpolators;
    }
    
    if (stroke.dashOffset) {
      _dashOffsetInterpolator = [[XXYNumberInterpolator alloc] initWithKeyframes:stroke.dashOffset.keyframes];
    }
    
    self.outputLayer.fillColor = nil;
    self.outputLayer.lineCap = stroke.capType == XXYLineCapTypeRound ? kCALineCapRound : kCALineCapButt;
    switch (stroke.joinType) {
      case XXYLineJoinTypeBevel:
        self.outputLayer.lineJoin = kCALineJoinBevel;
        break;
      case XXYLineJoinTypeMiter:
        self.outputLayer.lineJoin = kCALineJoinMiter;
        break;
      case XXYLineJoinTypeRound:
        self.outputLayer.lineJoin = kCALineJoinRound;
        break;
      default:
        break;
    }
  }
  return self;
}

- (NSDictionary *)valueInterpolators {
  return @{@"Color" : _colorInterpolator,
           @"Opacity" : _opacityInterpolator,
           @"Stroke Width" : _widthInterpolator};
}

- (void)_updateLineDashPatternsForFrame:(NSNumber *)frame {
  if (_dashPatternInterpolators.count) {
    NSMutableArray *lineDashPatterns = [NSMutableArray array];
    CGFloat dashTotal = 0;
    for (XXYNumberInterpolator *interpolator in _dashPatternInterpolators) {
      CGFloat patternValue = [interpolator floatValueForFrame:frame];
      dashTotal = dashTotal + patternValue;
      [lineDashPatterns addObject:@(patternValue)];
    }
    if (dashTotal > 0) {
      self.outputLayer.lineDashPattern = lineDashPatterns;
    }
  }
}

- (BOOL)needsUpdateForFrame:(NSNumber *)frame {
  [self _updateLineDashPatternsForFrame:frame];
  BOOL dashOffset = NO;
  if (_dashOffsetInterpolator) {
    dashOffset = [_dashOffsetInterpolator hasUpdateForFrame:frame];
  }
  return (dashOffset ||
          [_colorInterpolator hasUpdateForFrame:frame] ||
          [_opacityInterpolator hasUpdateForFrame:frame] ||
          [_widthInterpolator hasUpdateForFrame:frame]);
}

- (void)performLocalUpdate {
  self.outputLayer.lineDashPhase = [_dashOffsetInterpolator floatValueForFrame:self.currentFrame];
  self.outputLayer.strokeColor = [_colorInterpolator colorForFrame:self.currentFrame].CGColor;
  self.outputLayer.lineWidth = [_widthInterpolator floatValueForFrame:self.currentFrame];
  self.outputLayer.opacity = [_opacityInterpolator floatValueForFrame:self.currentFrame];
}

- (void)rebuildOutputs {
  self.outputLayer.path = self.inputNode.outputPath.CGPath;
}

- (NSDictionary *)actionsForRenderLayer {
  return @{@"strokeColor": [NSNull null],
           @"lineWidth": [NSNull null],
           @"opacity" : [NSNull null]};
}

@end
