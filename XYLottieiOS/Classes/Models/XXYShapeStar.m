//
//  XXYShapeStar.m
//  XXYtie
//
//  Created by brandon_withrow on 7/27/17.
//  Copyright © 2017 Airbnb. All rights reserved.
//

#import "XXYShapeStar.h"

@implementation XXYShapeStar

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
  
  NSDictionary *outerRadius = jsonDictionary[@"or"];
  if (outerRadius) {
    _outerRadius = [[XXYKeyframeGroup alloc] initWithData:outerRadius];
  }
  
  NSDictionary *outerRoundness = jsonDictionary[@"os"];
  if (outerRoundness) {
    _outerRoundness = [[XXYKeyframeGroup alloc] initWithData:outerRoundness];
  }
  
  NSDictionary *innerRadius = jsonDictionary[@"ir"];
  if (innerRadius) {
    _innerRadius = [[XXYKeyframeGroup alloc] initWithData:innerRadius];
  }
  
  NSDictionary *innerRoundness = jsonDictionary[@"is"];
  if (innerRoundness) {
    _innerRoundness = [[XXYKeyframeGroup alloc] initWithData:innerRoundness];
  }
  
  NSDictionary *position = jsonDictionary[@"p"];
  if (position) {
    _position = [[XXYKeyframeGroup alloc] initWithData:position];
  }
  
  NSDictionary *numberOfPoints = jsonDictionary[@"pt"];
  if (numberOfPoints) {
    _numberOfPoints = [[XXYKeyframeGroup alloc] initWithData:numberOfPoints];
  }
  
  NSDictionary *rotation = jsonDictionary[@"r"];
  if (rotation) {
    _rotation = [[XXYKeyframeGroup alloc] initWithData:rotation];
  }
  
  NSNumber *type = jsonDictionary[@"sy"];
  _type = type.integerValue;
}

@end
