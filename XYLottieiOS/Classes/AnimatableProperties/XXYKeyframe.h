//
//  XXYKeyframe.h
//  Pods
//
//  Created by brandon_withrow on 7/10/17.
//
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "XXYPlatformCompat.h"
#import "XXYBezierData.h"

NS_ASSUME_NONNULL_BEGIN

@interface XXYKeyframe : NSObject

- (instancetype)initWithKeyframe:(NSDictionary *)keyframe;
- (instancetype)initWithValue:(id)value;
- (void)remapValueWithBlock:(CGFloat (^)(CGFloat inValue))remapBlock;
- (XXYKeyframe *)copyWithData:(id)data;

@property (nonatomic, readonly) NSNumber *keyframeTime;
@property (nonatomic, readonly) BOOL isHold;
@property (nonatomic, readonly) CGPoint inTangent;
@property (nonatomic, readonly) CGPoint outTangent;
@property (nonatomic, readonly) CGPoint spatialInTangent;
@property (nonatomic, readonly) CGPoint spatialOutTangent;

@property (nonatomic, readonly) CGFloat floatValue;
@property (nonatomic, readonly) CGPoint pointValue;
@property (nonatomic, readonly) CGSize sizeValue;
@property (nonatomic, readonly) UIColor *colorValue;
@property (nonatomic, readonly, nullable) XXYBezierData *pathData;
@property (nonatomic, readonly) NSArray *arrayValue;

@end

@interface XXYKeyframeGroup : NSObject

- (instancetype)initWithData:(id)data;

- (void)remapKeyframesWithBlock:(CGFloat (^)(CGFloat inValue))remapBlock;

@property (nonatomic, readonly) NSArray<XXYKeyframe *> *keyframes;

@end

NS_ASSUME_NONNULL_END
