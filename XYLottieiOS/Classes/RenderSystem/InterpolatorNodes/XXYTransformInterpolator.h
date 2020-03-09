//
//  XXYTransformInterpolator.h
//  XXYtie
//
//  Created by brandon_withrow on 7/18/17.
//  Copyright © 2017 Airbnb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXYNumberInterpolator.h"
#import "XXYPointInterpolator.h"
#import "XXYSizeInterpolator.h"
#import "XXYKeyframe.h"
#import "XXYLayer.h"

NS_ASSUME_NONNULL_BEGIN

@interface XXYTransformInterpolator : NSObject

+ (instancetype)transformForLayer:(XXYLayer *)layer;

- (instancetype)initWithPosition:(NSArray <XXYKeyframe *> *)position
                        rotation:(NSArray <XXYKeyframe *> *)rotation
                          anchor:(NSArray <XXYKeyframe *> *)anchor
                           scale:(NSArray <XXYKeyframe *> *)scale;

- (instancetype)initWithPositionX:(NSArray <XXYKeyframe *> *)positionX
                        positionY:(NSArray <XXYKeyframe *> *)positionY
                         rotation:(NSArray <XXYKeyframe *> *)rotation
                           anchor:(NSArray <XXYKeyframe *> *)anchor
                            scale:(NSArray <XXYKeyframe *> *)scale;

@property (nonatomic, strong) XXYTransformInterpolator * inputNode;

@property (nonatomic, readonly) XXYPointInterpolator *positionInterpolator;
@property (nonatomic, readonly) XXYPointInterpolator *anchorInterpolator;
@property (nonatomic, readonly) XXYSizeInterpolator *scaleInterpolator;
@property (nonatomic, readonly) XXYNumberInterpolator *rotationInterpolator;
@property (nonatomic, readonly) XXYNumberInterpolator *positionXInterpolator;
@property (nonatomic, readonly) XXYNumberInterpolator *positionYInterpolator;
@property (nonatomic, strong, nullable) NSString *parentKeyName;

- (CATransform3D)transformForFrame:(NSNumber *)frame;
- (BOOL)hasUpdateForFrame:(NSNumber *)frame;

@end

NS_ASSUME_NONNULL_END
