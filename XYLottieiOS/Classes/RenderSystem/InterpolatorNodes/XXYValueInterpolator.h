//
//  XXYValueInterpolator.h
//  Pods
//
//  Created by brandon_withrow on 7/10/17.
//
//

#import <Foundation/Foundation.h>
#import "XXYKeyframe.h"

NS_ASSUME_NONNULL_BEGIN

@interface XXYValueInterpolator : NSObject

- (instancetype)initWithKeyframes:(NSArray <XXYKeyframe *> *)keyframes;

/// Used to dynamically update keyframe data.
- (BOOL)setValue:(id)value atFrame:(NSNumber *)frame;
- (id _Nullable)keyframeDataForValue:(id)value;

@property (nonatomic, weak, nullable) XXYKeyframe *leadingKeyframe;
@property (nonatomic, weak, nullable) XXYKeyframe *trailingKeyframe;

- (BOOL)hasUpdateForFrame:(NSNumber *)frame;
- (CGFloat)progressForFrame:(NSNumber *)frame;

@end

NS_ASSUME_NONNULL_END
