//
//  XXYShapeStar.h
//  XXYtie
//
//  Created by brandon_withrow on 7/27/17.
//  Copyright © 2017 Airbnb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXYKeyframe.h"

typedef enum : NSUInteger {
  XXYPolystarShapeNone,
  XXYPolystarShapeStar,
  XXYPolystarShapePolygon
} XXYPolystarShape;

@interface XXYShapeStar : NSObject

- (instancetype)initWithJSON:(NSDictionary *)jsonDictionary;

@property (nonatomic, readonly) NSString *keyname;
@property (nonatomic, readonly) XXYKeyframeGroup *outerRadius;
@property (nonatomic, readonly) XXYKeyframeGroup *outerRoundness;

@property (nonatomic, readonly) XXYKeyframeGroup *innerRadius;
@property (nonatomic, readonly) XXYKeyframeGroup *innerRoundness;

@property (nonatomic, readonly) XXYKeyframeGroup *position;
@property (nonatomic, readonly) XXYKeyframeGroup *numberOfPoints;
@property (nonatomic, readonly) XXYKeyframeGroup *rotation;

@property (nonatomic, readonly) XXYPolystarShape type;

@end
