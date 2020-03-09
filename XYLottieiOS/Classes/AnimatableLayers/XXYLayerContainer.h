//
//  XXYLayerContainer.h
//  XXYtie
//
//  Created by brandon_withrow on 7/18/17.
//  Copyright © 2017 Airbnb. All rights reserved.
//

#import "XXYPlatformCompat.h"
#import "XXYLayer.h"
#import "XXYLayerGroup.h"

@interface XXYLayerContainer : CALayer

- (instancetype _Nonnull)initWithModel:(XXYLayer * _Nullable)layer
                 inLayerGroup:(XXYLayerGroup * _Nullable)layerGroup;

@property (nonatomic,  readonly, strong, nullable) NSString *layerName;
@property (nonatomic, nullable) NSNumber *currentFrame;
@property (nonatomic, assign) CGRect viewportBounds;
@property (nonatomic, readonly, nonnull) CALayer *wrapperLayer;
- (void)displayWithFrame:(NSNumber * _Nonnull)frame;
- (void)displayWithFrame:(NSNumber * _Nonnull)frame forceUpdate:(BOOL)forceUpdate;

- (void)addAndMaskSublayer:(nonnull CALayer *)subLayer;

- (BOOL)setValue:(nonnull id)value
      forKeypath:(nonnull NSString *)keypath
         atFrame:(nullable NSNumber *)frame;

- (void)logHierarchyKeypathsWithParent:(NSString * _Nullable)parent;

@end
