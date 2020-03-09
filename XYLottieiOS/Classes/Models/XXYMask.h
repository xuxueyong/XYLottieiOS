//
//  XXYMask.h
//  XXYtieAnimator
//
//  Created by Brandon Withrow on 12/14/15.
//  Copyright © 2015 Brandon Withrow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXYKeyframe.h"

typedef enum : NSUInteger {
  XXYMaskModeAdd,
  XXYMaskModeSubtract,
  XXYMaskModeIntersect,
  XXYMaskModeUnknown
} XXYMaskMode;

@interface XXYMask : NSObject

- (instancetype _Nonnull)initWithJSON:(NSDictionary * _Nonnull)jsonDictionary;

@property (nonatomic, readonly) BOOL closed;
@property (nonatomic, readonly) BOOL inverted;
@property (nonatomic, readonly) XXYMaskMode maskMode;
@property (nonatomic, readonly, nullable) XXYKeyframeGroup *maskPath;
@property (nonatomic, readonly, nullable) XXYKeyframeGroup *opacity;
@property (nonatomic, readonly, nullable) XXYKeyframeGroup *expansion;
@end
