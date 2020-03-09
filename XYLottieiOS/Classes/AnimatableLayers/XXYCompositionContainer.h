//
//  XXYCompositionContainer.h
//  XXYtie
//
//  Created by brandon_withrow on 7/18/17.
//  Copyright © 2017 Airbnb. All rights reserved.
//

#import "XXYLayerContainer.h"
#import "XXYAssetGroup.h"

@interface XXYCompositionContainer : XXYLayerContainer

- (instancetype _Nonnull)initWithModel:(XXYLayer * _Nullable)layer
                          inLayerGroup:(XXYLayerGroup * _Nullable)layerGroup
                        withLayerGroup:(XXYLayerGroup * _Nullable)childLayerGroup
                       withAssestGroup:(XXYAssetGroup * _Nullable)assetGroup;

- (void)addSublayer:(nonnull CALayer *)subLayer
       toLayerNamed:(nonnull NSString *)layerName
     applyTransform:(BOOL)applyTransform;

- (CGRect)convertRect:(CGRect)rect
            fromLayer:(CALayer *_Nonnull)fromlayer
         toLayerNamed:(NSString *_Nonnull)layerName;

@property (nonatomic, readonly, nonnull) NSArray<XXYLayerContainer *> *childLayers;
@property (nonatomic, readonly, nonnull)  NSDictionary *childMap;

@end
