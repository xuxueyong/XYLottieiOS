//
//  XXYColorInterpolator.h
//  XXYtie
//
//  Created by brandon_withrow on 7/13/17.
//  Copyright © 2017 Airbnb. All rights reserved.
//

#import "XXYValueInterpolator.h"
#import "XXYPlatformCompat.h"

NS_ASSUME_NONNULL_BEGIN

@interface XXYColorInterpolator : XXYValueInterpolator

- (UIColor *)colorForFrame:(NSNumber *)frame;

@end

NS_ASSUME_NONNULL_END
