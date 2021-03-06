//
//  XXYScene.m
//  XXYtieAnimator
//
//  Created by Brandon Withrow on 12/14/15.
//  Copyright © 2015 Brandon Withrow. All rights reserved.
//

#import "XXYComposition.h"
#import "XXYLayer.h"
#import "XXYAssetGroup.h"
#import "XXYLayerGroup.h"
#import "XXYAnimationCache.h"

@implementation XXYComposition

# pragma mark - Convenience Initializers

+ (nullable instancetype)animationNamed:(nonnull NSString *)animationName {
  return [self animationNamed:animationName inBundle:[NSBundle mainBundle]];
}

+ (nullable instancetype)animationNamed:(nonnull NSString *)animationName inBundle:(nonnull NSBundle *)bundle {
  NSArray *components = [animationName componentsSeparatedByString:@"."];
  animationName = components.firstObject;
  
  XXYComposition *comp = [[XXYAnimationCache sharedCache] animationForKey:animationName];
  if (comp) {
    return comp;
  }
  
  NSError *error;
  NSString *filePath = [bundle pathForResource:animationName ofType:@"json"];
  NSData *jsonData = [[NSData alloc] initWithContentsOfFile:filePath];
  NSDictionary  *JSONObject = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData
                                                                         options:0 error:&error] : nil;
  if (JSONObject && !error) {
    XXYComposition *laScene = [[XXYComposition alloc] initWithJSON:JSONObject withAssetBundle:bundle];
    [[XXYAnimationCache sharedCache] addAnimation:laScene forKey:animationName];
    laScene.cacheKey = animationName;
    return laScene;
  }
  NSLog(@"%s: Animation Not Found", __PRETTY_FUNCTION__);
  return nil;
}

+ (nullable instancetype)animationWithFilePath:(nonnull NSString *)filePath {
  NSString *animationName = filePath;
  
  XXYComposition *comp = [[XXYAnimationCache sharedCache] animationForKey:animationName];
  if (comp) {
    return comp;
  }
  
  NSError *error;
  NSData *jsonData = [[NSData alloc] initWithContentsOfFile:filePath];
  NSDictionary  *JSONObject = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData
                                                                         options:0 error:&error] : nil;
  if (JSONObject && !error) {
    XXYComposition *laScene = [[XXYComposition alloc] initWithJSON:JSONObject withAssetBundle:[NSBundle mainBundle]];
    laScene.rootDirectory = [filePath stringByDeletingLastPathComponent];
    [[XXYAnimationCache sharedCache] addAnimation:laScene forKey:animationName];
    laScene.cacheKey = animationName;
    return laScene;
  }
  
  NSLog(@"%s: Animation Not Found", __PRETTY_FUNCTION__);
  return nil;
}

+ (nonnull instancetype)animationFromJSON:(nonnull NSDictionary *)animationJSON {
  return [self animationFromJSON:animationJSON inBundle:[NSBundle mainBundle]];
}

+ (nonnull instancetype)animationFromJSON:(nullable NSDictionary *)animationJSON inBundle:(nullable NSBundle *)bundle {
  return [[XXYComposition alloc] initWithJSON:animationJSON withAssetBundle:bundle];
}

#pragma mark - Initializer

- (instancetype _Nonnull)initWithJSON:(NSDictionary * _Nullable)jsonDictionary
                      withAssetBundle:(NSBundle * _Nullable)bundle {
  self = [super init];
  if (self) {
    if (jsonDictionary) {
      [self _mapFromJSON:jsonDictionary withAssetBundle:bundle];
    }
  }
  return self;
}

#pragma mark - Internal Methods

- (void)_mapFromJSON:(NSDictionary *)jsonDictionary
     withAssetBundle:(NSBundle *)bundle {
  NSNumber *width = jsonDictionary[@"w"];
  NSNumber *height = jsonDictionary[@"h"];
  if (width && height) {
    CGRect bounds = CGRectMake(0, 0, width.floatValue, height.floatValue);
    _compBounds = bounds;
  }
  
  _startFrame = [jsonDictionary[@"ip"] copy];
  _endFrame = [jsonDictionary[@"op"] copy];
  _framerate = [jsonDictionary[@"fr"] copy];
  
  if (_startFrame && _endFrame && _framerate) {
    NSInteger frameDuration = (_endFrame.integerValue - _startFrame.integerValue) - 1;
    NSTimeInterval timeDuration = frameDuration / _framerate.floatValue;
    _timeDuration = timeDuration;
  }
  
  NSArray *assetArray = jsonDictionary[@"assets"];
  if (assetArray.count) {
    _assetGroup = [[XXYAssetGroup alloc] initWithJSON:assetArray withAssetBundle:bundle];
  }
  
  NSArray *layersJSON = jsonDictionary[@"layers"];
  if (layersJSON) {
    _layerGroup = [[XXYLayerGroup alloc] initWithLayerJSON:layersJSON
                                            withAssetGroup:_assetGroup];
  }
  
  [_assetGroup finalizeInitialization];
}
  
- (void)setRootDirectory:(NSString *)rootDirectory {
    _rootDirectory = rootDirectory;
    self.assetGroup.rootDirectory = rootDirectory;
}
  
@end
