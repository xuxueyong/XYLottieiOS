//
//  XXYShapeGradientFill.h
//  XXYtie
//
//  Created by brandon_withrow on 7/26/17.
//  Copyright © 2017 Airbnb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXYKeyframe.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
  XXYGradientTypeLinear,
  XXYGradientTypeRadial
} XXYGradientType;

@interface XXYShapeGradientFill : NSObject

- (instancetype)initWithJSON:(NSDictionary *)jsonDictionary;

@property (nonatomic, readonly) NSString *keyname;
@property (nonatomic, readonly) NSNumber *numberOfColors;
@property (nonatomic, readonly) XXYKeyframeGroup *startPoint;
@property (nonatomic, readonly) XXYKeyframeGroup *endPoint;
@property (nonatomic, readonly) XXYKeyframeGroup *gradient;
@property (nonatomic, readonly) XXYKeyframeGroup *opacity;
@property (nonatomic, readonly) BOOL evenOddFillRule;
@property (nonatomic, readonly) XXYGradientType type;

@end

NS_ASSUME_NONNULL_END
