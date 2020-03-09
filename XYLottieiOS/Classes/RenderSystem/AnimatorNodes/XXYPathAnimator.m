//
//  XXYPathAnimator.m
//  Pods
//
//  Created by brandon_withrow on 6/27/17.
//
//

#import "XXYPathAnimator.h"
#import "XXYPathInterpolator.h"

@implementation XXYPathAnimator {
  XXYShapePath *_pathConent;
  XXYPathInterpolator *_interpolator;
}

- (instancetype _Nonnull)initWithInputNode:(XXYAnimatorNode *_Nullable)inputNode
                                  shapePath:(XXYShapePath *_Nonnull)shapePath {
  self = [super initWithInputNode:inputNode keyName:shapePath.keyname];
  if (self) {
    _pathConent = shapePath;
    _interpolator = [[XXYPathInterpolator alloc] initWithKeyframes:_pathConent.shapePath.keyframes];
  }
  return self;
}

- (NSDictionary *)valueInterpolators {
  return @{@"Path" : _interpolator};
}

- (BOOL)needsUpdateForFrame:(NSNumber *)frame {
  return [_interpolator hasUpdateForFrame:frame];
}

- (void)performLocalUpdate {
  self.localPath = [_interpolator pathForFrame:self.currentFrame cacheLengths:self.pathShouldCacheLengths];
}

@end
