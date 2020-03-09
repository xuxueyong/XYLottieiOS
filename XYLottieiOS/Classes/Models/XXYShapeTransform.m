//
//  XXYShapeTransform.m
//  XXYtieAnimator
//
//  Created by Brandon Withrow on 12/15/15.
//  Copyright © 2015 Brandon Withrow. All rights reserved.
//

#import "XXYShapeTransform.h"
#import "XXYHelpers.h"

@implementation XXYShapeTransform

- (instancetype)initWithJSON:(NSDictionary *)jsonDictionary {
  self = [super init];
  if (self) {
    [self _mapFromJSON:jsonDictionary];
  }
  return self;
}

- (void)_mapFromJSON:(NSDictionary *)jsonDictionary {
  
  if (jsonDictionary[@"nm"] ) {
    _keyname = [jsonDictionary[@"nm"] copy];
  }
  
  NSDictionary *position = jsonDictionary[@"p"];
  if (position) {
    _position = [[XXYKeyframeGroup alloc] initWithData:position];
  }
  
  NSDictionary *anchor = jsonDictionary[@"a"];
  if (anchor) {
    _anchor = [[XXYKeyframeGroup alloc] initWithData:anchor];
  }
  
  NSDictionary *scale = jsonDictionary[@"s"];
  if (scale) {
    _scale = [[XXYKeyframeGroup alloc] initWithData:scale];
    [_scale remapKeyframesWithBlock:^CGFloat(CGFloat inValue) {
      return XXY_RemapValue(inValue, 0, 100, 0, 1);
    }];
  }
  
  NSDictionary *rotation = jsonDictionary[@"r"];
  if (rotation) {
    _rotation = [[XXYKeyframeGroup alloc] initWithData:rotation];
    [_rotation remapKeyframesWithBlock:^CGFloat(CGFloat inValue) {
      return XXY_DegreesToRadians(inValue);
    }];
  }
  
  NSDictionary *opacity = jsonDictionary[@"o"];
  if (opacity) {
    _opacity = [[XXYKeyframeGroup alloc] initWithData:opacity];
    [_opacity remapKeyframesWithBlock:^CGFloat(CGFloat inValue) {
      return XXY_RemapValue(inValue, 0, 100, 0, 1);
    }];
  }
  
  NSString *name = jsonDictionary[@"nm"];
  
  NSDictionary *skew = jsonDictionary[@"sk"];
  BOOL hasSkew = (skew && [skew[@"k"] isEqual:@0] == NO);
  NSDictionary *skewAxis = jsonDictionary[@"sa"];
  BOOL hasSkewAxis = (skewAxis && [skewAxis[@"k"] isEqual:@0] == NO);
  
  if (hasSkew || hasSkewAxis) {
    NSLog(@"%s: Warning: skew is not supported: %@", __PRETTY_FUNCTION__, name);
  }
}

- (NSString *)description {
  return [NSString stringWithFormat:@"XXYShapeTransform \"Position: %@ Anchor: %@ Scale: %@ Rotation: %@ Opacity: %@\"", _position.description, _anchor.description, _scale.description, _rotation.description, _opacity.description];
}

@end
