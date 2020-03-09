//
//  XXYLayerGroup.h
//  Pods
//
//  Created by Brandon Withrow on 2/16/17.
//
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@class XXYLayer;
@class XXYAssetGroup;

@interface XXYLayerGroup : NSObject

- (instancetype)initWithLayerJSON:(NSArray *)layersJSON
                   withAssetGroup:(XXYAssetGroup * _Nullable)assetGroup;

@property (nonatomic, readonly) NSArray <XXYLayer *> *layers;

- (XXYLayer *)layerModelForID:(NSNumber *)layerID;
- (XXYLayer *)layerForReferenceID:(NSString *)referenceID;

@end

NS_ASSUME_NONNULL_END
