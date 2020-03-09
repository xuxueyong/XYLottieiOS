//
//  XXYShapeGradientFill.m
//  XXYtie
//
//  Created by brandon_withrow on 7/26/17.
//  Copyright © 2017 Airbnb. All rights reserved.
//

#import "XXYShapeGradientFill.h"
#import "CGGeometry+XXYAdditions.h"

@implementation XXYShapeGradientFill

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
  
  NSNumber *type = jsonDictionary[@"t"];
  
  if (type.integerValue != 1) {
    _type = XXYGradientTypeRadial;
  } else {
    _type = XXYGradientTypeLinear;
  }
  
  NSDictionary *start = jsonDictionary[@"s"];
  if (start) {
    _startPoint = [[XXYKeyframeGroup alloc] initWithData:start];
  }
  
  NSDictionary *end = jsonDictionary[@"e"];
  if (end) {
    _endPoint = [[XXYKeyframeGroup alloc] initWithData:end];
  }
  
  NSDictionary *gradient = jsonDictionary[@"g"];
  if (gradient) {
    NSDictionary *unwrappedGradient = gradient[@"k"];
    _numberOfColors = gradient[@"p"];
    _gradient = [[XXYKeyframeGroup alloc] initWithData:unwrappedGradient];
  }
  
  NSDictionary *opacity = jsonDictionary[@"o"];
  if (opacity) {
    _opacity = [[XXYKeyframeGroup alloc] initWithData:opacity];
    [_opacity remapKeyframesWithBlock:^CGFloat(CGFloat inValue) {
      return XXY_RemapValue(inValue, 0, 100, 0, 1);
    }];
  }
  
  NSNumber *evenOdd = jsonDictionary[@"r"];
  if (evenOdd.integerValue == 2) {
    _evenOddFillRule = YES;
  } else {
    _evenOddFillRule = NO;
  }
}
@end
