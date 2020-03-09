//
//  XXYGradientFillRender.m
//  XXYtie
//
//  Created by brandon_withrow on 7/27/17.
//  Copyright © 2017 Airbnb. All rights reserved.
//

#import "XXYGradientFillRender.h"
#import "XXYArrayInterpolator.h"
#import "XXYPointInterpolator.h"
#import "XXYNumberInterpolator.h"
#import "CGGeometry+XXYAdditions.h"
#import "XXYHelpers.h"
#import "XXYRadialGradientLayer.h"

@implementation XXYGradientFillRender {
  BOOL _evenOddFillRule;
  CALayer *centerPoint_DEBUG;
  
  CAShapeLayer *_maskShape;
  XXYRadialGradientLayer *_gradientOpacityLayer;
  XXYRadialGradientLayer *_gradientLayer;
  NSInteger _numberOfPositions;
  
  CGPoint _startPoint;
  CGPoint _endPoint;
  
  XXYArrayInterpolator *_gradientInterpolator;
  XXYPointInterpolator *_startPointInterpolator;
  XXYPointInterpolator *_endPointInterpolator;
  XXYNumberInterpolator *_opacityInterpolator;
}

- (instancetype)initWithInputNode:(XXYAnimatorNode *)inputNode
                          shapeGradientFill:(XXYShapeGradientFill *)fill {
  self = [super initWithInputNode:inputNode keyName:fill.keyname];
  if (self) {
    _gradientInterpolator = [[XXYArrayInterpolator alloc] initWithKeyframes:fill.gradient.keyframes];
    _startPointInterpolator = [[XXYPointInterpolator alloc] initWithKeyframes:fill.startPoint.keyframes];
    _endPointInterpolator = [[XXYPointInterpolator alloc] initWithKeyframes:fill.endPoint.keyframes];
    _opacityInterpolator = [[XXYNumberInterpolator alloc] initWithKeyframes:fill.opacity.keyframes];
    _numberOfPositions = fill.numberOfColors.integerValue;
    
    _evenOddFillRule = fill.evenOddFillRule;
    CALayer *wrapperLayer = [CALayer new];
    _maskShape = [CAShapeLayer new];
    _maskShape.fillRule = _evenOddFillRule ? @"even-odd" : @"non-zero";
    _maskShape.fillColor = [UIColor whiteColor].CGColor;
    _maskShape.actions = @{@"path": [NSNull null]};
    
    _gradientOpacityLayer = [XXYRadialGradientLayer new];
    _gradientOpacityLayer.isRadial = (fill.type == XXYGradientTypeRadial);
    _gradientOpacityLayer.actions = @{@"startPoint" : [NSNull null],
                                      @"endPoint" : [NSNull null],
                                      @"opacity" : [NSNull null],
                                      @"locations" : [NSNull null],
                                      @"colors" : [NSNull null],
                                      @"bounds" : [NSNull null],
                                      @"anchorPoint" : [NSNull null],
                                      @"isRadial" : [NSNull null]};
    _gradientOpacityLayer.mask = _maskShape;
    [wrapperLayer addSublayer:_gradientOpacityLayer];
    
    _gradientLayer = [XXYRadialGradientLayer new];
    _gradientLayer.isRadial = (fill.type == XXYGradientTypeRadial);
    _gradientLayer.mask = wrapperLayer;
    _gradientLayer.actions = [_gradientOpacityLayer.actions copy];
    [self.outputLayer addSublayer:_gradientLayer];
    
    centerPoint_DEBUG = [CALayer layer];
    centerPoint_DEBUG.bounds = CGRectMake(0, 0, 20, 20);
    if (ENABLE_DEBUG_SHAPES) {
      [self.outputLayer addSublayer:centerPoint_DEBUG];
    }
  }
  return self;
}

- (NSDictionary *)valueInterpolators {
  return @{@"Start Point" : _startPointInterpolator,
           @"End Point" : _endPointInterpolator,
           @"Opacity" : _opacityInterpolator};
}

- (BOOL)needsUpdateForFrame:(NSNumber *)frame {
  return ([_gradientInterpolator hasUpdateForFrame:frame] ||
          [_startPointInterpolator hasUpdateForFrame:frame] ||
          [_endPointInterpolator hasUpdateForFrame:frame] ||
          [_opacityInterpolator hasUpdateForFrame:frame]);
}

- (void)performLocalUpdate {
  centerPoint_DEBUG.backgroundColor =  [UIColor magentaColor].CGColor;
  centerPoint_DEBUG.borderColor = [UIColor lightGrayColor].CGColor;
  centerPoint_DEBUG.borderWidth = 2.f;
  _startPoint = [_startPointInterpolator pointValueForFrame:self.currentFrame];
  _endPoint = [_endPointInterpolator pointValueForFrame:self.currentFrame];
  self.outputLayer.opacity = [_opacityInterpolator floatValueForFrame:self.currentFrame];
  NSArray *numberArray = [_gradientInterpolator numberArrayForFrame:self.currentFrame];
  NSMutableArray *colorArray = [NSMutableArray array];
  NSMutableArray *locationsArray = [NSMutableArray array];
  
  NSMutableArray *opacityArray = [NSMutableArray array];
  NSMutableArray *opacitylocationsArray = [NSMutableArray array];
  for (int i = 0; i < _numberOfPositions; i++) {
    int ix = i * 4;
    NSNumber *location = numberArray[ix];
    NSNumber *r = numberArray[(ix + 1)];
    NSNumber *g = numberArray[(ix + 2)];
    NSNumber *b = numberArray[(ix + 3)];
    [locationsArray addObject:location];
    UIColor *color = [UIColor colorWithRed:r.floatValue green:g.floatValue blue:b.floatValue alpha:1];
    [colorArray addObject:(id)(color.CGColor)];
  }
  for (NSInteger i = (_numberOfPositions * 4); i < numberArray.count; i = i + 2) {
    NSNumber *opacityLocation = numberArray[i];
    [opacitylocationsArray addObject:opacityLocation];
    NSNumber *opacity = numberArray[i + 1];
    UIColor *opacityColor = [UIColor colorWithWhite:1 alpha:opacity.floatValue];
    [opacityArray addObject:(id)(opacityColor.CGColor)];
  }
  if (opacityArray.count == 0) {
    _gradientOpacityLayer.backgroundColor = [UIColor whiteColor].CGColor;
  } else {
    _gradientOpacityLayer.startPoint = _startPoint;
    _gradientOpacityLayer.endPoint = _endPoint;
    _gradientOpacityLayer.locations = opacitylocationsArray;
    _gradientOpacityLayer.colors = opacityArray;
  }
  _gradientLayer.startPoint = _startPoint;
  _gradientLayer.endPoint = _endPoint;
  _gradientLayer.locations = locationsArray;
  _gradientLayer.colors = colorArray;
}

- (void)rebuildOutputs {
  CGRect frame = [self.inputNode.outputPath bounds];
  CGPoint modifiedAnchor = CGPointMake(-frame.origin.x / frame.size.width,
                                       -frame.origin.y / frame.size.height);
  _maskShape.path = self.inputNode.outputPath.CGPath;
  _gradientOpacityLayer.bounds = frame;
  _gradientOpacityLayer.anchorPoint = modifiedAnchor;
  
  _gradientLayer.bounds = frame;
  _gradientLayer.anchorPoint = modifiedAnchor;
  
}

- (NSDictionary *)actionsForRenderLayer {
  return @{@"backgroundColor": [NSNull null],
           @"fillColor": [NSNull null],
           @"opacity" : [NSNull null]};
}

@end