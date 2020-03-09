//
//  XXYArrayInterpolator.h
//  XXYtie
//
//  Created by brandon_withrow on 7/27/17.
//  Copyright © 2017 Airbnb. All rights reserved.
//

#import "XXYValueInterpolator.h"

NS_ASSUME_NONNULL_BEGIN

@interface XXYArrayInterpolator : XXYValueInterpolator

- (NSArray *)numberArrayForFrame:(NSNumber *)frame;

@end

NS_ASSUME_NONNULL_END
