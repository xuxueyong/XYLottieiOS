//
//  XXYShapeTransform.h
//  XXYtieAnimator
//
//  Created by Brandon Withrow on 12/15/15.
//  Copyright © 2015 Brandon Withrow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import "XXYKeyframe.h"

@interface XXYShapeTransform : NSObject

- (instancetype)initWithJSON:(NSDictionary *)jsonDictionary;

@property (nonatomic, readonly) NSString *keyname;
@property (nonatomic, readonly) XXYKeyframeGroup *position;
@property (nonatomic, readonly) XXYKeyframeGroup *anchor;
@property (nonatomic, readonly) XXYKeyframeGroup *scale;
@property (nonatomic, readonly) XXYKeyframeGroup *rotation;
@property (nonatomic, readonly) XXYKeyframeGroup *opacity;

@end
