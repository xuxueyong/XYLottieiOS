//
//  XXYRenderGroup.m
//  XXYtie
//
//  Created by brandon_withrow on 6/27/17.
//  Copyright © 2017 Airbnb. All rights reserved.
//

#import "XXYRenderGroup.h"
#import "XXYModels.h"
#import "XXYPathAnimator.h"
#import "XXYFillRenderer.h"
#import "XXYStrokeRenderer.h"
#import "XXYNumberInterpolator.h"
#import "XXYTransformInterpolator.h"
#import "XXYCircleAnimator.h"
#import "XXYRoundedRectAnimator.h"
#import "XXYTrimPathNode.h"
#import "XXYShapeStar.h"
#import "XXYPolygonAnimator.h"
#import "XXYPolystarAnimator.h"
#import "XXYShapeGradientFill.h"
#import "XXYGradientFillRender.h"
#import "XXYRepeaterRenderer.h"
#import "XXYShapeRepeater.h"

@implementation XXYRenderGroup {
  XXYAnimatorNode *_rootNode;
  XXYBezierPath *_outputPath;
  XXYBezierPath *_localPath;
  BOOL _rootNodeHasUpdate;
  XXYNumberInterpolator *_opacityInterpolator;
  XXYTransformInterpolator *_transformInterolator;
}

- (instancetype _Nonnull)initWithInputNode:(XXYAnimatorNode * _Nullable)inputNode
                                   contents:(NSArray * _Nonnull)contents
                                    keyname:(NSString * _Nullable)keyname {
  self = [super initWithInputNode:inputNode keyName:keyname];
  if (self) {
    _containerLayer = [CALayer layer];
    _containerLayer.actions = @{@"transform": [NSNull null],
                                @"opacity": [NSNull null]};
    [self buildContents:contents];
  }
  return self;
}

- (NSDictionary *)valueInterpolators {
  if (_opacityInterpolator && _transformInterolator) {
    return @{@"Transform.Opacity" : _opacityInterpolator,
             @"Transform.Position" : _transformInterolator.positionInterpolator,
             @"Transform.Scale" : _transformInterolator.scaleInterpolator,
             @"Transform.Rotation" : _transformInterolator.scaleInterpolator,
             @"Transform.Anchor Point" : _transformInterolator.anchorInterpolator};
  }
  return nil;
}

- (void)buildContents:(NSArray *)contents {
  XXYAnimatorNode *previousNode = nil;
  XXYShapeTransform *transform;
  for (id item in contents) {
    if ([item isKindOfClass:[XXYShapeFill class]]) {
      XXYFillRenderer *fillRenderer = [[XXYFillRenderer alloc] initWithInputNode:previousNode
                                                                       shapeFill:(XXYShapeFill *)item];
      [self.containerLayer insertSublayer:fillRenderer.outputLayer atIndex:0];
      previousNode = fillRenderer;
    } else if ([item isKindOfClass:[XXYShapeStroke class]]) {
      XXYStrokeRenderer *strokRenderer = [[XXYStrokeRenderer alloc] initWithInputNode:previousNode
                                                                          shapeStroke:(XXYShapeStroke *)item];
      [self.containerLayer insertSublayer:strokRenderer.outputLayer atIndex:0];
      previousNode = strokRenderer;
    } else if ([item isKindOfClass:[XXYShapePath class]]) {
      XXYPathAnimator *pathAnimator = [[XXYPathAnimator alloc] initWithInputNode:previousNode
                                                                       shapePath:(XXYShapePath *)item];
      previousNode = pathAnimator;
    } else if ([item isKindOfClass:[XXYShapeRectangle class]]) {
      XXYRoundedRectAnimator *rectAnimator = [[XXYRoundedRectAnimator alloc] initWithInputNode:previousNode
                                                                                shapeRectangle:(XXYShapeRectangle *)item];
      previousNode = rectAnimator;
    } else if ([item isKindOfClass:[XXYShapeCircle class]]) {
      XXYCircleAnimator *circleAnimator = [[XXYCircleAnimator alloc] initWithInputNode:previousNode
                                                                           shapeCircle:(XXYShapeCircle *)item];
      previousNode = circleAnimator;
    } else if ([item isKindOfClass:[XXYShapeGroup class]]) {
      XXYShapeGroup *shapeGroup = (XXYShapeGroup *)item;
      XXYRenderGroup *renderGroup = [[XXYRenderGroup alloc] initWithInputNode:previousNode contents:shapeGroup.items keyname:shapeGroup.keyname];
      [self.containerLayer insertSublayer:renderGroup.containerLayer atIndex:0];
      previousNode = renderGroup;
    } else if ([item isKindOfClass:[XXYShapeTransform class]]) {
      transform = (XXYShapeTransform *)item;
    } else if ([item isKindOfClass:[XXYShapeTrimPath class]]) {
      XXYTrimPathNode *trim = [[XXYTrimPathNode alloc] initWithInputNode:previousNode trimPath:(XXYShapeTrimPath *)item];
      previousNode = trim;
    } else if ([item isKindOfClass:[XXYShapeStar class]]) {
      XXYShapeStar *star = (XXYShapeStar *)item;
      if (star.type == XXYPolystarShapeStar) {
        XXYPolystarAnimator *starAnimator = [[XXYPolystarAnimator alloc] initWithInputNode:previousNode shapeStar:star];
        previousNode = starAnimator;
      }
      if (star.type == XXYPolystarShapePolygon) {
        XXYPolygonAnimator *polygonAnimator = [[XXYPolygonAnimator alloc] initWithInputNode:previousNode shapePolygon:star];
        previousNode = polygonAnimator;
      }
    } else if ([item isKindOfClass:[XXYShapeGradientFill class]]) {
      XXYGradientFillRender *gradientFill = [[XXYGradientFillRender alloc] initWithInputNode:previousNode shapeGradientFill:(XXYShapeGradientFill *)item];
      previousNode = gradientFill;
      [self.containerLayer insertSublayer:gradientFill.outputLayer atIndex:0];
    } else if ([item isKindOfClass:[XXYShapeRepeater class]]) {
      XXYRepeaterRenderer *repeater = [[XXYRepeaterRenderer alloc] initWithInputNode:previousNode shapeRepeater:(XXYShapeRepeater *)item];
      previousNode = repeater;
      [self.containerLayer insertSublayer:repeater.outputLayer atIndex:0];
    }
  }
  if (transform) {
    _opacityInterpolator = [[XXYNumberInterpolator alloc] initWithKeyframes:transform.opacity.keyframes];
    _transformInterolator = [[XXYTransformInterpolator alloc] initWithPosition:transform.position.keyframes
                                                                      rotation:transform.rotation.keyframes
                                                                        anchor:transform.anchor.keyframes
                                                                         scale:transform.scale.keyframes];
  }
  _rootNode = previousNode;
}

- (BOOL)needsUpdateForFrame:(NSNumber *)frame {
  return ([_opacityInterpolator hasUpdateForFrame:frame] ||
          [_transformInterolator hasUpdateForFrame:frame] ||
          _rootNodeHasUpdate);

}

- (BOOL)updateWithFrame:(NSNumber *)frame withModifierBlock:(void (^ _Nullable)(XXYAnimatorNode * _Nonnull))modifier forceLocalUpdate:(BOOL)forceUpdate {
  indentation_level = indentation_level + 1;
  _rootNodeHasUpdate = [_rootNode updateWithFrame:frame withModifierBlock:modifier forceLocalUpdate:forceUpdate];
  indentation_level = indentation_level - 1;
  BOOL update = [super updateWithFrame:frame withModifierBlock:modifier forceLocalUpdate:forceUpdate];
  return update;
}

- (void)performLocalUpdate {
  if (_opacityInterpolator) {
    self.containerLayer.opacity = [_opacityInterpolator floatValueForFrame:self.currentFrame];
  }
  if (_transformInterolator) {
    CATransform3D xform = [_transformInterolator transformForFrame:self.currentFrame];
    self.containerLayer.transform = xform;
    
    CGAffineTransform appliedXform = CATransform3DGetAffineTransform(xform);
    _localPath = [_rootNode.outputPath copy];
    [_localPath XXY_applyTransform:appliedXform];
  } else {
    _localPath = [_rootNode.outputPath copy];
  }
}

- (void)rebuildOutputs {
  if (self.inputNode) {
    _outputPath = [self.inputNode.outputPath copy];
    [_outputPath XXY_appendPath:self.localPath];
  } else {
    _outputPath = self.localPath;
  }
}

- (void)setPathShouldCacheLengths:(BOOL)pathShouldCacheLengths {
  [super setPathShouldCacheLengths:pathShouldCacheLengths];
  _rootNode.pathShouldCacheLengths = pathShouldCacheLengths;
}

- (XXYBezierPath *)localPath {
  return _localPath;
}

- (XXYBezierPath *)outputPath {
  return _outputPath;
}

- (BOOL)setInterpolatorValue:(id)value
                      forKey:(NSString *)key
                    forFrame:(NSNumber *)frame {
  BOOL interpolatorsSet = [super setInterpolatorValue:value forKey:key forFrame:frame];
  if (interpolatorsSet) {
    return YES;
  }
  return [_rootNode setValue:value forKeyAtPath:key forFrame:frame];
}

- (void)logHierarchyKeypathsWithParent:(NSString * _Nullable)parent {
  NSString *keypath = self.keyname;
  if (parent && self.keyname) {
    keypath = [NSString stringWithFormat:@"%@.%@", parent, self.keyname];
  }
  if (keypath) {
    for (NSString *interpolator in self.valueInterpolators.allKeys) {
      [self logString:[NSString stringWithFormat:@"%@.%@", keypath, interpolator]];
    }
    [_rootNode logHierarchyKeypathsWithParent:keypath];
  }
  
  [self.inputNode logHierarchyKeypathsWithParent:parent];
}

@end
