//
//  XXYLayerContainer.m
//  XXYtie
//
//  Created by brandon_withrow on 7/18/17.
//  Copyright © 2017 Airbnb. All rights reserved.
//

#import "XXYLayerContainer.h"
#import "XXYTransformInterpolator.h"
#import "XXYNumberInterpolator.h"
#import "CGGeometry+XXYAdditions.h"
#import "XXYRenderGroup.h"
#import "XXYHelpers.h"
#import "XXYMaskContainer.h"
#import "XXYAsset.h"

#if TARGET_OS_IPHONE || TARGET_OS_SIMULATOR
#import "XXYCacheProvider.h"
#endif

@implementation XXYLayerContainer {
  XXYTransformInterpolator *_transformInterpolator;
  XXYNumberInterpolator *_opacityInterpolator;
  NSNumber *_inFrame;
  NSNumber *_outFrame;
  CALayer *DEBUG_Center;
  XXYRenderGroup *_contentsGroup;
  XXYMaskContainer *_maskLayer;
  NSDictionary *_valueInterpolators;
}

@dynamic currentFrame;

- (instancetype)initWithModel:(XXYLayer *)layer
                 inLayerGroup:(XXYLayerGroup *)layerGroup {
  self = [super init];
  if (self) {
    _wrapperLayer = [CALayer new];
    [self addSublayer:_wrapperLayer];
    DEBUG_Center = [CALayer layer];
    
    DEBUG_Center.bounds = CGRectMake(0, 0, 20, 20);
    DEBUG_Center.borderColor = [UIColor blueColor].CGColor;
    DEBUG_Center.borderWidth = 2;
    DEBUG_Center.masksToBounds = YES;
    
    if (ENABLE_DEBUG_SHAPES) {
      [_wrapperLayer addSublayer:DEBUG_Center];
    } 
    self.actions = @{@"hidden" : [NSNull null], @"opacity" : [NSNull null], @"transform" : [NSNull null]};
    _wrapperLayer.actions = [self.actions copy];
    [self commonInitializeWith:layer inLayerGroup:layerGroup];
  }
  return self;
}

- (void)commonInitializeWith:(XXYLayer *)layer
                inLayerGroup:(XXYLayerGroup *)layerGroup {
  if (layer == nil) {
    return;
  }
  _layerName = layer.layerName;
  if (layer.layerType == XXYLayerTypeImage ||
      layer.layerType == XXYLayerTypeSolid ||
      layer.layerType == XXYLayerTypePrecomp) {
    _wrapperLayer.bounds = CGRectMake(0, 0, layer.layerWidth.floatValue, layer.layerHeight.floatValue);
    _wrapperLayer.anchorPoint = CGPointMake(0, 0);
    _wrapperLayer.masksToBounds = YES;
    DEBUG_Center.position = XXY_RectGetCenterPoint(self.bounds);
  }
  
  if (layer.layerType == XXYLayerTypeImage) {
    [self _setImageForAsset:layer.imageAsset];
  }
  
  _inFrame = [layer.inFrame copy];
  _outFrame = [layer.outFrame copy];
  _transformInterpolator = [XXYTransformInterpolator transformForLayer:layer];
  if (layer.parentID) {
    NSNumber *parentID = layer.parentID;
    XXYTransformInterpolator *childInterpolator = _transformInterpolator;
    while (parentID != nil) {
      XXYLayer *parentModel = [layerGroup layerModelForID:parentID];
      XXYTransformInterpolator *interpolator = [XXYTransformInterpolator transformForLayer:parentModel];
      childInterpolator.inputNode = interpolator;
      childInterpolator = interpolator;
      parentID = parentModel.parentID;
    }
  }
  _opacityInterpolator = [[XXYNumberInterpolator alloc] initWithKeyframes:layer.opacity.keyframes];
  if (layer.layerType == XXYLayerTypeShape &&
      layer.shapes.count) {
    [self buildContents:layer.shapes];
  }
  if (layer.layerType == XXYLayerTypeSolid) {
    _wrapperLayer.backgroundColor = layer.solidColor.CGColor;
  }
  if (layer.masks.count) {
    _maskLayer = [[XXYMaskContainer alloc] initWithMasks:layer.masks];
    _wrapperLayer.mask = _maskLayer;
  }
  
  NSMutableDictionary *interpolators = [NSMutableDictionary dictionary];
  interpolators[@"Transform.Opacity"] = _opacityInterpolator;
  interpolators[@"Transform.Anchor Point"] = _transformInterpolator.anchorInterpolator;
  interpolators[@"Transform.Scale"] = _transformInterpolator.scaleInterpolator;
  interpolators[@"Transform.Rotation"] = _transformInterpolator.rotationInterpolator;
  if (_transformInterpolator.positionXInterpolator &&
      _transformInterpolator.positionYInterpolator) {
    interpolators[@"Transform.X Position"] = _transformInterpolator.positionXInterpolator;
    interpolators[@"Transform.Y Position"] = _transformInterpolator.positionYInterpolator;
  } else if (_transformInterpolator.positionInterpolator) {
    interpolators[@"Transform.Position"] = _transformInterpolator.positionInterpolator;
  }
  _valueInterpolators = interpolators;
}

- (void)buildContents:(NSArray *)contents {
  _contentsGroup = [[XXYRenderGroup alloc] initWithInputNode:nil contents:contents keyname:_layerName];
  [_wrapperLayer addSublayer:_contentsGroup.containerLayer];
}

#if TARGET_OS_IPHONE || TARGET_OS_SIMULATOR

- (void)_setImageForAsset:(XXYAsset *)asset {
  if (asset.imageName) {
    UIImage *image;
    if (asset.rootDirectory.length > 0) {
      NSString *rootDirectory  = asset.rootDirectory;
      if (asset.imageDirectory.length > 0) {
        rootDirectory = [rootDirectory stringByAppendingPathComponent:asset.imageDirectory];
      }
      NSString *imagePath = [rootDirectory stringByAppendingPathComponent:asset.imageName];
        
      id<XXYImageCache> imageCache = [XXYCacheProvider imageCache];
      if (imageCache) {
        image = [imageCache imageForKey:imagePath];
        if (!image) {
          image = [UIImage imageWithContentsOfFile:imagePath];
          [imageCache setImage:image forKey:imagePath];
        }
      } else {
        image = [UIImage imageWithContentsOfFile:imagePath];
      }
    } else {
      NSArray *components = [asset.imageName componentsSeparatedByString:@"."];
      image = [UIImage imageNamed:components.firstObject inBundle:asset.assetBundle compatibleWithTraitCollection:nil];
    }
    
    if (image) {
      _wrapperLayer.contents = (__bridge id _Nullable)(image.CGImage);
    } else {
      NSLog(@"%s: Warn: image not found: %@", __PRETTY_FUNCTION__, asset.imageName);
    }
  }
}

#else

- (void)_setImageForAsset:(XXYAsset *)asset {
  if (asset.imageName) {
    NSArray *components = [asset.imageName componentsSeparatedByString:@"."];
    NSImage *image = [NSImage imageNamed:components.firstObject];
    if (image) {
      NSWindow *window = [NSApp mainWindow];
      CGFloat desiredScaleFactor = [window backingScaleFactor];
      CGFloat actualScaleFactor = [image recommendedLayerContentsScale:desiredScaleFactor];
      id layerContents = [image layerContentsForContentsScale:actualScaleFactor];
      _wrapperLayer.contents = layerContents;
    }
  }
  
}

#endif

// MARK - Animation

+ (BOOL)needsDisplayForKey:(NSString *)key {
  if ([key isEqualToString:@"currentFrame"]) {
    return YES;
  }
  return [super needsDisplayForKey:key];
}

- (id<CAAction>)actionForKey:(NSString *)event {
  if ([event isEqualToString:@"currentFrame"]) {
    CABasicAnimation *theAnimation = [CABasicAnimation
                                      animationWithKeyPath:event];
    theAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    theAnimation.fromValue = [[self presentationLayer] valueForKey:event];
    return theAnimation;
  }
  return [super actionForKey:event];
}

- (id)initWithLayer:(id)layer {
  if (self = [super initWithLayer:layer]) {
    if ([layer isKindOfClass:[XXYLayerContainer class]]) {
      XXYLayerContainer *other = (XXYLayerContainer *)layer;
      self.currentFrame = [other.currentFrame copy];
    }
  }
  return self;
}

- (void)display {
  @synchronized(self) {
    XXYLayerContainer *presentation = self;
    if (self.animationKeys.count &&
      self.presentationLayer) {
        presentation = (XXYLayerContainer *)self.presentationLayer;
    }
    [self displayWithFrame:presentation.currentFrame];
  }
}

- (void)displayWithFrame:(NSNumber *)frame {
  [self displayWithFrame:frame forceUpdate:NO];
}

- (void)displayWithFrame:(NSNumber *)frame forceUpdate:(BOOL)forceUpdate {
  if (ENABLE_DEBUG_LOGGING) NSLog(@"View %@ Displaying Frame %@", self, frame);
  BOOL hidden = NO;
  if (_inFrame && _outFrame) {
    hidden = (frame.floatValue < _inFrame.floatValue ||
              frame.floatValue > _outFrame.floatValue);
  }
  self.hidden = hidden;
  if (hidden) {
    return;
  }
  if (_opacityInterpolator && [_opacityInterpolator hasUpdateForFrame:frame]) {
    self.opacity = [_opacityInterpolator floatValueForFrame:frame];
  }
  if (_transformInterpolator && [_transformInterpolator hasUpdateForFrame:frame]) {
    _wrapperLayer.transform = [_transformInterpolator transformForFrame:frame];
  }
  [_contentsGroup updateWithFrame:frame withModifierBlock:nil forceLocalUpdate:forceUpdate];
  _maskLayer.currentFrame = frame;
}

- (void)addAndMaskSublayer:(nonnull CALayer *)subLayer {
  [_wrapperLayer addSublayer:subLayer];
}

- (BOOL)setValue:(nonnull id)value
      forKeypath:(nonnull NSString *)keypath
         atFrame:(nullable NSNumber *)frame {
  NSArray *components = [keypath componentsSeparatedByString:@"."];
  NSString *firstKey = components.firstObject;
  if ([firstKey isEqualToString:self.layerName]) {
    NSString *nextPath = [keypath stringByReplacingCharactersInRange:NSMakeRange(0, firstKey.length + 1) withString:@""];
    XXYValueInterpolator *interpolator = _valueInterpolators[nextPath];
    if (interpolator) {
      return [interpolator setValue:value atFrame:frame];
    } else {
      return [_contentsGroup setValue:value forKeyAtPath:keypath forFrame:frame];
    }
  } else {
    NSArray *transFormComponents = [keypath componentsSeparatedByString:@".Transform."];
    if (transFormComponents.count == 2) {
      // Is a layer level transform. Check if it applies to a parent transform.
      NSString *layerName = transFormComponents.firstObject;
      NSString *attribute = transFormComponents.lastObject;
      XXYTransformInterpolator *parentTransform = _transformInterpolator.inputNode;
      while (parentTransform) {
        if ([parentTransform.parentKeyName isEqualToString:layerName]) {
          if ([attribute isEqualToString:@"Anchor Point"]) {
            [parentTransform.anchorInterpolator setValue:value atFrame:frame];
          } else if ([attribute isEqualToString:@"Scale"]) {
            [parentTransform.scaleInterpolator setValue:value atFrame:frame];
          } else if ([attribute isEqualToString:@"Rotation"]) {
            [parentTransform.rotationInterpolator setValue:value atFrame:frame];
          } else if ([attribute isEqualToString:@"X Position"]) {
            [parentTransform.positionXInterpolator setValue:value atFrame:frame];
          } else if ([attribute isEqualToString:@"Y Position"]) {
            [parentTransform.positionYInterpolator setValue:value atFrame:frame];
          } else if ([attribute isEqualToString:@"Position"]) {
            [parentTransform.positionInterpolator setValue:value atFrame:frame];
          }
          parentTransform = nil;
        }
        parentTransform = parentTransform.inputNode;
      }
    }
  }
  return NO;
}

- (void)setViewportBounds:(CGRect)viewportBounds {
  _viewportBounds = viewportBounds;
  if (_maskLayer) {
    CGPoint center = XXY_RectGetCenterPoint(viewportBounds);
    viewportBounds.origin = CGPointMake(-center.x, -center.y);
    _maskLayer.bounds = viewportBounds;
  }
}

- (void)logHierarchyKeypathsWithParent:(NSString * _Nullable)parent {
  [_contentsGroup logHierarchyKeypathsWithParent:parent];
}

@end