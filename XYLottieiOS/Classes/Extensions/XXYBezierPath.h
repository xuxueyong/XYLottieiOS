//
//  XXYBezierPath.h
//  XXYtie
//
//  Created by brandon_withrow on 7/20/17.
//  Copyright © 2017 Airbnb. All rights reserved.
//

#import "XXYPlatformCompat.h"

NS_ASSUME_NONNULL_BEGIN

@interface XXYBezierPath : NSObject

+ (instancetype)newPath;

- (void)XXY_moveToPoint:(CGPoint)point;

- (void)XXY_addLineToPoint:(CGPoint)point;

- (void)XXY_addCurveToPoint:(CGPoint)point
              controlPoint1:(CGPoint)cp1
              controlPoint2:(CGPoint)cp2;

- (void)XXY_closePath;

- (void)XXY_removeAllPoints;

- (void)XXY_appendPath:(XXYBezierPath *)bezierPath;

- (void)trimPathFromT:(CGFloat)fromT toT:(CGFloat)toT offset:(CGFloat)offset;

- (void)XXY_applyTransform:(CGAffineTransform)transform;

@property (nonatomic, assign) BOOL cacheLengths;

@property (nonatomic, readonly) CGFloat length;

@property (nonatomic, readonly) CGPathRef CGPath;
@property (nonatomic, readonly) CGPoint currentPoint;
@property (nonatomic) CGFloat lineWidth;
@property (nonatomic) CGLineCap lineCapStyle;
@property (nonatomic) CGLineJoin lineJoinStyle;
@property (nonatomic) CGFloat miterLimit;
@property (nonatomic) CGFloat flatness;
@property (nonatomic) BOOL usesEvenOddFillRule;
@property (readonly, getter=isEmpty) BOOL empty;
@property (nonatomic, readonly) CGRect bounds;

@end

NS_ASSUME_NONNULL_END
