//
//  XXYAnimationCache.m
//  XXYtie
//
//  Created by Brandon Withrow on 1/9/17.
//  Copyright © 2017 Brandon Withrow. All rights reserved.
//

#import "XXYAnimationCache.h"

const NSInteger kXXYCacheSize = 50;

@implementation XXYAnimationCache {
  NSMutableDictionary *animationsCache_;
  NSMutableArray *lruOrderArray_;
}

+ (instancetype)sharedCache {
  static XXYAnimationCache *sharedCache = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedCache = [[self alloc] init];
  });
  return sharedCache;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    animationsCache_ = [[NSMutableDictionary alloc] init];
    lruOrderArray_ = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)addAnimation:(XXYComposition *)animation forKey:(NSString *)key {
  if (lruOrderArray_.count >= kXXYCacheSize) {
    NSString *oldKey = lruOrderArray_[0];
    [animationsCache_ removeObjectForKey:oldKey];
    [lruOrderArray_ removeObject:oldKey];
  }
  [lruOrderArray_ removeObject:key];
  [lruOrderArray_ addObject:key];
  [animationsCache_ setObject:animation forKey:key];
}

- (XXYComposition *)animationForKey:(NSString *)key {
  if (!key) {
    return nil;
  }
  XXYComposition *animation = [animationsCache_ objectForKey:key];
  [lruOrderArray_ removeObject:key];
  [lruOrderArray_ addObject:key];
  return animation;
}

- (void)clearCache {
  [animationsCache_ removeAllObjects];
  [lruOrderArray_ removeAllObjects];
}

- (void)removeAnimationForKey:(NSString *)key {
  [lruOrderArray_ removeObject:key];
  [animationsCache_ removeObjectForKey:key];
}

- (void)disableCaching {
  [self clearCache];
  animationsCache_ = nil;
  lruOrderArray_ = nil;
}

@end
