//
//  XXYShapeRepeater.m
//  XXYtie
//
//  Created by brandon_withrow on 7/28/17.
//  Copyright © 2017 Airbnb. All rights reserved.
//

#import "XXYShapeRepeater.h"
#import "CGGeometry+XXYAdditions.h"

@implementation XXYShapeRepeater

- (instancetype)initWithJSON:(NSDictionary *)jsonDictionary  {
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
  
  NSDictionary *copies = jsonDictionary[@"c"];
  if (copies) {
    _copies = [[XXYKeyframeGroup alloc] initWithData:copies];
  }
  
  NSDictionary *offset = jsonDictionary[@"o"];
  if (offset) {
    _offset = [[XXYKeyframeGroup alloc] initWithData:offset];
  }
  
  NSDictionary *transform = jsonDictionary[@"tr"];
  
  NSDictionary *rotation = transform[@"r"];
  if (rotation) {
    _rotation = [[XXYKeyframeGroup alloc] initWithData:rotation];
    [_rotation remapKeyframesWithBlock:^CGFloat(CGFloat inValue) {
      return XXY_DegreesToRadians(inValue);
    }];
  }
  
  NSDictionary *startOpacity = transform[@"so"];
  if (startOpacity) {
    _startOpacity = [[XXYKeyframeGroup alloc] initWithData:startOpacity];
    [_startOpacity remapKeyframesWithBlock:^CGFloat(CGFloat inValue) {
      return XXY_RemapValue(inValue, 0, 100, 0, 1);
    }];
  }
  
  NSDictionary *endOpacity = transform[@"eo"];
  if (endOpacity) {
    _endOpacity = [[XXYKeyframeGroup alloc] initWithData:endOpacity];
    [_endOpacity remapKeyframesWithBlock:^CGFloat(CGFloat inValue) {
      return XXY_RemapValue(inValue, 0, 100, 0, 1);
    }];
  }
  
  NSDictionary *anchorPoint = transform[@"a"];
  if (anchorPoint) {
    _anchorPoint = [[XXYKeyframeGroup alloc] initWithData:anchorPoint];
  }
  
  NSDictionary *position = transform[@"p"];
  if (position) {
    _position = [[XXYKeyframeGroup alloc] initWithData:position];
  }
  
  NSDictionary *scale = transform[@"s"];
  if (scale) {
    _scale = [[XXYKeyframeGroup alloc] initWithData:scale];
    [_scale remapKeyframesWithBlock:^CGFloat(CGFloat inValue) {
      return XXY_RemapValue(inValue, 0, 100, 0, 1);
    }];
  }
}

@end
