//
//  XXYMask.m
//  XXYtieAnimator
//
//  Created by Brandon Withrow on 12/14/15.
//  Copyright © 2015 Brandon Withrow. All rights reserved.
//

#import "XXYMask.h"
#import "CGGeometry+XXYAdditions.h"

@implementation XXYMask

- (instancetype)initWithJSON:(NSDictionary *)jsonDictionary {
  self = [super init];
  if (self) {
    [self _mapFromJSON:jsonDictionary];
  }
  return self;
}

- (void)_mapFromJSON:(NSDictionary *)jsonDictionary {
  NSNumber *closed = jsonDictionary[@"cl"];
  _closed = closed.boolValue;
  
  NSNumber *inverted = jsonDictionary[@"inv"];
  _inverted = inverted.boolValue;
  
  NSString *mode = jsonDictionary[@"mode"];
  if ([mode isEqualToString:@"a"]) {
    _maskMode = XXYMaskModeAdd;
  } else if ([mode isEqualToString:@"s"]) {
    _maskMode = XXYMaskModeSubtract;
  } else if ([mode isEqualToString:@"i"]) {
    _maskMode = XXYMaskModeIntersect;
  } else {
    _maskMode = XXYMaskModeUnknown;
  }
  
  NSDictionary *maskshape = jsonDictionary[@"pt"];
  if (maskshape) {
    _maskPath = [[XXYKeyframeGroup alloc] initWithData:maskshape];
  }
  
  NSDictionary *opacity = jsonDictionary[@"o"];
  if (opacity) {
    _opacity = [[XXYKeyframeGroup alloc] initWithData:opacity];
    [_opacity remapKeyframesWithBlock:^CGFloat(CGFloat inValue) {
      return XXY_RemapValue(inValue, 0, 100, 0, 1);
    }];
  }
  
  NSDictionary *expansion = jsonDictionary[@"x"];
  if (expansion) {
    _expansion = [[XXYKeyframeGroup alloc] initWithData:expansion];
  }
}

@end
