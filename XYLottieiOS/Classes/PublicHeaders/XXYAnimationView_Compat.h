//
//  XXYAnimationView_Compat.h
//  XXYtie
//
//  Created by Oleksii Pavlovskyi on 2/2/17.
//  Copyright (c) 2017 Airbnb. All rights reserved.
//

#if TARGET_OS_IPHONE || TARGET_OS_SIMULATOR

#import <UIKit/UIKit.h>
@compatibility_alias XXYView UIView;

#else

#import <AppKit/AppKit.h>
@compatibility_alias XXYView NSView;

typedef NS_ENUM(NSInteger, XXYViewContentMode) {
    XXYViewContentModeScaleToFill,
    XXYViewContentModeScaleAspectFit,
    XXYViewContentModeScaleAspectFill,
    XXYViewContentModeRedraw,
    XXYViewContentModeCenter,
    XXYViewContentModeTop,
    XXYViewContentModeBottom,
    XXYViewContentModeLeft,
    XXYViewContentModeRight,
    XXYViewContentModeTopLeft,
    XXYViewContentModeTopRight,
    XXYViewContentModeBottomLeft,
    XXYViewContentModeBottomRight,
};

#endif

