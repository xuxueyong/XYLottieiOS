//
//  XXYPointInterpolator.h
//  XXYtie
//
//  Created by brandon_withrow on 7/12/17.
//  Copyright © 2017 Airbnb. All rights reserved.
//

#import "XXYValueInterpolator.h"

NS_ASSUME_NONNULL_BEGIN

@interface XXYPointInterpolator : XXYValueInterpolator

- (CGPoint)pointValueForFrame:(NSNumber *)frame;

@end

NS_ASSUME_NONNULL_END
