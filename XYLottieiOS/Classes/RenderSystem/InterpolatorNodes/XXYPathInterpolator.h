//
//  XXYPathInterpolator.h
//  XXYtie
//
//  Created by brandon_withrow on 7/13/17.
//  Copyright © 2017 Airbnb. All rights reserved.
//

#import "XXYValueInterpolator.h"
#import "XXYPlatformCompat.h"
#import "XXYBezierPath.h"

NS_ASSUME_NONNULL_BEGIN

@interface XXYPathInterpolator : XXYValueInterpolator

- (XXYBezierPath *)pathForFrame:(NSNumber *)frame cacheLengths:(BOOL)cacheLengths;

@end

NS_ASSUME_NONNULL_END
