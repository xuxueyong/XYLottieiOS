//
//  XXYLayer.h
//  XXYtieAnimator
//
//  Created by Brandon Withrow on 12/14/15.
//  Copyright © 2015 Brandon Withrow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXYPlatformCompat.h"
#import "XXYKeyframe.h"

@class XXYShapeGroup;
@class XXYMask;
@class XXYAsset;
@class XXYAssetGroup;

typedef enum : NSInteger {
  XXYLayerTypePrecomp,
  XXYLayerTypeSolid,
  XXYLayerTypeImage,
  XXYLayerTypeNull,
  XXYLayerTypeShape,
  XXYLayerTypeUnknown
} XXYLayerType;

typedef enum : NSInteger {
  XXYMatteTypeNone,
  XXYMatteTypeAdd,
  XXYMatteTypeInvert,
  XXYMatteTypeUnknown
} XXYMatteType;

NS_ASSUME_NONNULL_BEGIN

@interface XXYLayer : NSObject

- (instancetype)initWithJSON:(NSDictionary *)jsonDictionary
              withAssetGroup:(XXYAssetGroup * _Nullable)assetGroup;

@property (nonatomic, readonly) NSString *layerName;
@property (nonatomic, readonly, nullable) NSString *referenceID;
@property (nonatomic, readonly) NSNumber *layerID;
@property (nonatomic, readonly) XXYLayerType layerType;
@property (nonatomic, readonly, nullable) NSNumber *parentID;
@property (nonatomic, readonly) NSNumber *startFrame;
@property (nonatomic, readonly) NSNumber *inFrame;
@property (nonatomic, readonly) NSNumber *outFrame;
@property (nonatomic, readonly) CGRect layerBounds;

@property (nonatomic, readonly, nullable) NSArray<XXYShapeGroup *> *shapes;
@property (nonatomic, readonly, nullable) NSArray<XXYMask *> *masks;

@property (nonatomic, readonly, nullable) NSNumber *layerWidth;
@property (nonatomic, readonly, nullable) NSNumber *layerHeight;
@property (nonatomic, readonly, nullable) UIColor *solidColor;
@property (nonatomic, readonly, nullable) XXYAsset *imageAsset;

@property (nonatomic, readonly) XXYKeyframeGroup *opacity;
@property (nonatomic, readonly) XXYKeyframeGroup *rotation;
@property (nonatomic, readonly, nullable) XXYKeyframeGroup *position;

@property (nonatomic, readonly, nullable) XXYKeyframeGroup *positionX;
@property (nonatomic, readonly, nullable) XXYKeyframeGroup *positionY;

@property (nonatomic, readonly) XXYKeyframeGroup *anchor;
@property (nonatomic, readonly) XXYKeyframeGroup *scale;

@property (nonatomic, readonly) XXYMatteType matteType;

@end

NS_ASSUME_NONNULL_END
