//
//  XXYShape.m
//  XXYtieAnimator
//
//  Created by Brandon Withrow on 12/14/15.
//  Copyright © 2015 Brandon Withrow. All rights reserved.
//

#import "XXYShapeGroup.h"
#import "XXYShapeFill.h"
#import "XXYShapePath.h"
#import "XXYShapeCircle.h"
#import "XXYShapeStroke.h"
#import "XXYShapeTransform.h"
#import "XXYShapeRectangle.h"
#import "XXYShapeTrimPath.h"
#import "XXYShapeGradientFill.h"
#import "XXYShapeStar.h"
#import "XXYShapeRepeater.h"

@implementation XXYShapeGroup

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
  
  NSArray *itemsJSON = jsonDictionary[@"it"];
  NSMutableArray *items = [NSMutableArray array];
  for (NSDictionary *itemJSON in itemsJSON) {
    id newItem = [XXYShapeGroup shapeItemWithJSON:itemJSON];
    if (newItem) {
      [items addObject:newItem];
    }
  }
  _items = items;
}

+ (id)shapeItemWithJSON:(NSDictionary *)itemJSON {
  NSString *type = itemJSON[@"ty"];
  if ([type isEqualToString:@"gr"]) {
    XXYShapeGroup *group = [[XXYShapeGroup alloc] initWithJSON:itemJSON];
    return group;
  } else if ([type isEqualToString:@"st"]) {
    XXYShapeStroke *stroke = [[XXYShapeStroke alloc] initWithJSON:itemJSON];
    return stroke;
  } else if ([type isEqualToString:@"fl"]) {
    XXYShapeFill *fill = [[XXYShapeFill alloc] initWithJSON:itemJSON];
    return fill;
  } else if ([type isEqualToString:@"tr"]) {
    XXYShapeTransform *transform = [[XXYShapeTransform alloc] initWithJSON:itemJSON];
    return transform;
  } else if ([type isEqualToString:@"sh"]) {
    XXYShapePath *path = [[XXYShapePath alloc] initWithJSON:itemJSON];
    return path;
  } else if ([type isEqualToString:@"el"]) {
    XXYShapeCircle *circle = [[XXYShapeCircle alloc] initWithJSON:itemJSON];
    return circle;
  } else if ([type isEqualToString:@"rc"]) {
    XXYShapeRectangle *rectangle = [[XXYShapeRectangle alloc] initWithJSON:itemJSON];
    return rectangle;
  } else if ([type isEqualToString:@"tm"]) {
    XXYShapeTrimPath *trim = [[XXYShapeTrimPath alloc] initWithJSON:itemJSON];
    return trim;
  } else  if ([type isEqualToString:@"gs"]) {
    NSLog(@"%s: Warning: gradient strokes are not supported", __PRETTY_FUNCTION__);
  } else  if ([type isEqualToString:@"gf"]) {
    XXYShapeGradientFill *gradientFill = [[XXYShapeGradientFill alloc] initWithJSON:itemJSON];
    return gradientFill;
  } else if ([type isEqualToString:@"sr"]) {
    XXYShapeStar *star = [[XXYShapeStar alloc] initWithJSON:itemJSON];
    return star;
  } else if ([type isEqualToString:@"mm"]) {
    NSString *name = itemJSON[@"nm"];
    NSLog(@"%s: Warning: merge shape is not supported. name: %@", __PRETTY_FUNCTION__, name);
  } else if ([type isEqualToString:@"rp"]) {
    XXYShapeRepeater *repeater = [[XXYShapeRepeater alloc] initWithJSON:itemJSON];
    return repeater;
  } else {
    NSString *name = itemJSON[@"nm"];
    NSLog(@"%s: Unsupported shape: %@ name: %@", __PRETTY_FUNCTION__, type, name);
  }
  
  return nil;
}

- (NSString *)description {
    NSMutableString *text = [[super description] mutableCopy];
    [text appendFormat:@" items: %@", self.items];
    return text;
}

@end
