//
//  XXYAnimationView_Internal.h
//  XXYtie
//
//  Created by Brandon Withrow on 12/7/16.
//  Copyright © 2016 Brandon Withrow. All rights reserved.
//

#import "XXYAnimationView.h"

typedef enum : NSUInteger {
  XXYConstraintTypeAlignToBounds,
  XXYConstraintTypeAlignToLayer,
  XXYConstraintTypeNone
} XXYConstraintType;

@interface XXYAnimationView () <CAAnimationDelegate>

- (CALayer * _Nullable)layerForKey:(NSString * _Nonnull)keyname;
- (NSArray * _Nonnull)compositionLayers;

@end
