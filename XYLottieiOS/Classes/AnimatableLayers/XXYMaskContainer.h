//
//  XXYMaskContainer.h
//  XXYtie
//
//  Created by brandon_withrow on 7/19/17.
//  Copyright © 2017 Airbnb. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "XXYMask.h"

@interface XXYMaskContainer : CALayer

- (instancetype _Nonnull)initWithMasks:(NSArray<XXYMask *> * _Nonnull)masks;

@property (nonatomic, strong, nullable) NSNumber *currentFrame;

@end
