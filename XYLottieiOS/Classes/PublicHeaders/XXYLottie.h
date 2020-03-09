//
//  XXYtie.h
//  Pods
//
//  Created by brandon_withrow on 1/27/17.
//
//

#if __has_feature(modules)
@import Foundation;
#else
#import <Foundation/Foundation.h>
#endif

#ifndef XXYtie_h
#define XXYtie_h

//! Project version number for XXYtie.
FOUNDATION_EXPORT double XXYtieVersionNumber;

//! Project version string for XXYtie.
FOUNDATION_EXPORT const unsigned char XXYtieVersionString[];

#include <TargetConditionals.h>

#if TARGET_OS_IPHONE || TARGET_OS_SIMULATOR
#import "XXYAnimationTransitionController.h"
#import "XXYAnimatedSwitch.h"
#import "XXYAnimatedControl.h"
#endif

#if TARGET_OS_IPHONE || TARGET_OS_SIMULATOR
#import "XXYCacheProvider.h"
#endif

#import "XXYAnimationView.h"
#import "XXYAnimationCache.h"
#import "XXYComposition.h"

#endif /* XXYtie_h */
