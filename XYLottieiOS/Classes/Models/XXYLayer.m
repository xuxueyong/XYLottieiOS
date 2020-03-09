//
//  XXYLayer.m
//  XXYtieAnimator
//
//  Created by Brandon Withrow on 12/14/15.
//  Copyright © 2015 Brandon Withrow. All rights reserved.
//

#import "XXYLayer.h"
#import "XXYAsset.h"
#import "XXYAssetGroup.h"
#import "XXYShapeGroup.h"
#import "XXYComposition.h"
#import "XXYHelpers.h"
#import "XXYMask.h"
#import "XXYHelpers.h"

@implementation XXYLayer

- (instancetype)initWithJSON:(NSDictionary *)jsonDictionary
              withAssetGroup:(XXYAssetGroup *)assetGroup {
  self = [super init];
  if (self) {
    [self _mapFromJSON:jsonDictionary
     withAssetGroup:assetGroup];
  }
  return self;
}

- (void)_mapFromJSON:(NSDictionary *)jsonDictionary
      withAssetGroup:(XXYAssetGroup *)assetGroup {

  _layerName = [jsonDictionary[@"nm"] copy];
  _layerID = [jsonDictionary[@"ind"] copy];
  
  NSNumber *layerType = jsonDictionary[@"ty"];
  _layerType = layerType.integerValue;
  
  if (jsonDictionary[@"refId"]) {
    _referenceID = [jsonDictionary[@"refId"] copy];
  }
  
  _parentID = [jsonDictionary[@"parent"] copy];
  
  if (jsonDictionary[@"st"]) {
    _startFrame = [jsonDictionary[@"st"] copy];
  }
  _inFrame = [jsonDictionary[@"ip"] copy];
  _outFrame = [jsonDictionary[@"op"] copy];

  if (_layerType == XXYLayerTypePrecomp) {
    _layerHeight = [jsonDictionary[@"h"] copy];
    _layerWidth = [jsonDictionary[@"w"] copy];
    [assetGroup buildAssetNamed:_referenceID];
  } else if (_layerType == XXYLayerTypeImage) {
    [assetGroup buildAssetNamed:_referenceID];
    _imageAsset = [assetGroup assetModelForID:_referenceID];
    _layerWidth = [_imageAsset.assetWidth copy];
    _layerHeight = [_imageAsset.assetHeight copy];
  } else if (_layerType == XXYLayerTypeSolid) {
    _layerWidth = jsonDictionary[@"sw"];
    _layerHeight = jsonDictionary[@"sh"];
    NSString *solidColor = jsonDictionary[@"sc"];
    _solidColor = [UIColor XXY_colorWithHexString:solidColor];
  }
  
  _layerBounds = CGRectMake(0, 0, _layerWidth.floatValue, _layerHeight.floatValue);
  
  NSDictionary *ks = jsonDictionary[@"ks"];
  
  NSDictionary *opacity = ks[@"o"];
  if (opacity) {
    _opacity = [[XXYKeyframeGroup alloc] initWithData:opacity];
    [_opacity remapKeyframesWithBlock:^CGFloat(CGFloat inValue) {
      return XXY_RemapValue(inValue, 0, 100, 0, 1);
    }];
  }
  
  NSDictionary *rotation = ks[@"r"];
  if (rotation == nil) {
    rotation = ks[@"rz"];
  }
  if (rotation) {
    _rotation = [[XXYKeyframeGroup alloc] initWithData:rotation];
    [_rotation remapKeyframesWithBlock:^CGFloat(CGFloat inValue) {
      return XXY_DegreesToRadians(inValue);
    }];
  }
  
  NSDictionary *position = ks[@"p"];
  if ([position[@"s"] boolValue]) {
    // Separate dimensions
    _positionX = [[XXYKeyframeGroup alloc] initWithData:position[@"x"]];
    _positionY = [[XXYKeyframeGroup alloc] initWithData:position[@"y"]];
  } else {
    _position = [[XXYKeyframeGroup alloc] initWithData:position ];
  }
  
  NSDictionary *anchor = ks[@"a"];
  if (anchor) {
    _anchor = [[XXYKeyframeGroup alloc] initWithData:anchor];
  }
  
  NSDictionary *scale = ks[@"s"];
  if (scale) {
    _scale = [[XXYKeyframeGroup alloc] initWithData:scale];
    [_scale remapKeyframesWithBlock:^CGFloat(CGFloat inValue) {
      return XXY_RemapValue(inValue, 0, 100, 0, 1);
    }];
  }
  
  _matteType = [jsonDictionary[@"tt"] integerValue];
  
  
  NSMutableArray *masks = [NSMutableArray array];
  for (NSDictionary *maskJSON in jsonDictionary[@"masksProperties"]) {
    XXYMask *mask = [[XXYMask alloc] initWithJSON:maskJSON];
    [masks addObject:mask];
  }
  _masks = masks.count ? masks : nil;
  
  NSMutableArray *shapes = [NSMutableArray array];
  for (NSDictionary *shapeJSON in jsonDictionary[@"shapes"]) {
    id shapeItem = [XXYShapeGroup shapeItemWithJSON:shapeJSON];
    if (shapeItem) {
      [shapes addObject:shapeItem];
    }
  }
  _shapes = shapes;
    
  NSArray *effects = jsonDictionary[@"ef"];
  if (effects.count > 0) {
    
    NSDictionary *effectNames = @{ @0: @"slider",
                                   @1: @"angle",
                                   @2: @"color",
                                   @3: @"point",
                                   @4: @"checkbox",
                                   @5: @"group",
                                   @6: @"noValue",
                                   @7: @"dropDown",
                                   @9: @"customValue",
                                   @10: @"layerIndex",
                                   @20: @"tint",
                                   @21: @"fill" };
                             
    for (NSDictionary *effect in effects) {
      NSNumber *typeNumber = effect[@"ty"];
      NSString *name = effect[@"nm"];
      NSString *internalName = effect[@"mn"];
      NSString *typeString = effectNames[typeNumber];
      if (typeString) {
        NSLog(@"%s: Warning: %@ effect not supported: %@ / %@", __PRETTY_FUNCTION__, typeString, internalName, name);
      }
    }
  }
}

- (NSString *)description {
    NSMutableString *text = [[super description] mutableCopy];
    [text appendFormat:@" %@ id: %d pid: %d frames: %d-%d", _layerName, (int)_layerID.integerValue, (int)_parentID.integerValue,
     (int)_inFrame.integerValue, (int)_outFrame.integerValue];
    return text;
}

@end
