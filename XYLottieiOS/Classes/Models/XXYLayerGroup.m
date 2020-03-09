//
//  XXYLayerGroup.m
//  Pods
//
//  Created by Brandon Withrow on 2/16/17.
//
//

#import "XXYLayerGroup.h"
#import "XXYLayer.h"
#import "XXYAssetGroup.h"

@implementation XXYLayerGroup {
  NSDictionary *_modelMap;
  NSDictionary *_referenceIDMap;
}

- (instancetype)initWithLayerJSON:(NSArray *)layersJSON
                   withAssetGroup:(XXYAssetGroup * _Nullable)assetGroup {
  self = [super init];
  if (self) {
    [self _mapFromJSON:layersJSON withAssetGroup:assetGroup];
  }
  return self;
}

- (void)_mapFromJSON:(NSArray *)layersJSON withAssetGroup:(XXYAssetGroup * _Nullable)assetGroup {
  
  NSMutableArray *layers = [NSMutableArray array];
  NSMutableDictionary *modelMap = [NSMutableDictionary dictionary];
  NSMutableDictionary *referenceMap = [NSMutableDictionary dictionary];
  
  for (NSDictionary *layerJSON in layersJSON) {
    XXYLayer *layer = [[XXYLayer alloc] initWithJSON:layerJSON
                                      withAssetGroup:assetGroup];
    [layers addObject:layer];
    modelMap[layer.layerID] = layer;
    if (layer.referenceID) {
      referenceMap[layer.referenceID] = layer;
    }
  }
  
  _referenceIDMap = referenceMap;
  _modelMap = modelMap;
  _layers = layers;
}

- (XXYLayer *)layerModelForID:(NSNumber *)layerID {
  return _modelMap[layerID];
}

- (XXYLayer *)layerForReferenceID:(NSString *)referenceID {
  return _referenceIDMap[referenceID];
}

@end
