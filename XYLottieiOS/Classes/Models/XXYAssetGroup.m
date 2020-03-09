//
//  XXYAssetGroup.m
//  Pods
//
//  Created by Brandon Withrow on 2/17/17.
//
//

#import "XXYAssetGroup.h"
#import "XXYAsset.h"

@implementation XXYAssetGroup {
  NSMutableDictionary<NSString *, XXYAsset *> *_assetMap;
  NSDictionary<NSString *, NSDictionary *> *_assetJSONMap;
}

- (instancetype _Nonnull)initWithJSON:(NSArray * _Nonnull)jsonArray
                      withAssetBundle:(NSBundle *_Nullable)bundle {
  self = [super init];
  if (self) {
    _assetBundle = bundle;
    _assetMap = [NSMutableDictionary dictionary];
    NSMutableDictionary *assetJSONMap = [NSMutableDictionary dictionary];
    for (NSDictionary<NSString *, NSString *> *assetDictionary in jsonArray) {
      NSString *referenceID = assetDictionary[@"id"];
      if (referenceID) {
        assetJSONMap[referenceID] = assetDictionary;
      }
    }
    _assetJSONMap = assetJSONMap;
  }
  return self;
}

- (void)buildAssetNamed:(NSString *)refID {
  
  if ([self assetModelForID:refID]) {
    return;
  }
  
  NSDictionary *assetDictionary = _assetJSONMap[refID];
  if (assetDictionary) {
    XXYAsset *asset = [[XXYAsset alloc] initWithJSON:assetDictionary
                                      withAssetGroup:self
                                     withAssetBundle:_assetBundle];
    _assetMap[refID] = asset;
  }
}

- (void)finalizeInitialization {
  for (NSString *refID in _assetJSONMap.allKeys) {
    [self buildAssetNamed:refID];
  }
  _assetJSONMap = nil;
}

- (XXYAsset *)assetModelForID:(NSString *)assetID {
  return _assetMap[assetID];
}

- (void)setRootDirectory:(NSString *)rootDirectory {
    _rootDirectory = rootDirectory;
    [_assetMap enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, XXYAsset * _Nonnull obj, BOOL * _Nonnull stop) {
        obj.rootDirectory = rootDirectory;
    }];
}
@end
