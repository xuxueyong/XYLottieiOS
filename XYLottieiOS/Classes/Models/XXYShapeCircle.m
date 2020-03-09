//
//  XXYShapeCircle.m
//  XXYtieAnimator
//
//  Created by Brandon Withrow on 12/15/15.
//  Copyright © 2015 Brandon Withrow. All rights reserved.
//

#import "XXYShapeCircle.h"

@implementation XXYShapeCircle

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
  
  NSDictionary *size= jsonDictionary[@"s"];
  if (size) {
    _size = [[XXYKeyframeGroup alloc] initWithData:size];
  }
  NSNumber *reversed = jsonDictionary[@"d"];
  _reversed = (reversed.integerValue == 3);
}

@end
