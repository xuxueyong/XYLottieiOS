//
//  XXYShapeRepeater.h
//  XXYtie
//
//  Created by brandon_withrow on 7/28/17.
//  Copyright © 2017 Airbnb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXYKeyframe.h"

NS_ASSUME_NONNULL_BEGIN

@interface XXYShapeRepeater : NSObject

- (instancetype)initWithJSON:(NSDictionary *)jsonDictionary;

@property (nonatomic, readonly) NSString *keyname;
@property (nonatomic, readonly, nullable) XXYKeyframeGroup *copies;
@property (nonatomic, readonly, nullable) XXYKeyframeGroup *offset;
@property (nonatomic, readonly, nullable) XXYKeyframeGroup *anchorPoint;
@property (nonatomic, readonly, nullable) XXYKeyframeGroup *scale;
@property (nonatomic, readonly, nullable) XXYKeyframeGroup *position;
@property (nonatomic, readonly, nullable) XXYKeyframeGroup *rotation;
@property (nonatomic, readonly, nullable) XXYKeyframeGroup *startOpacity;
@property (nonatomic, readonly, nullable) XXYKeyframeGroup *endOpacity;

@end

NS_ASSUME_NONNULL_END
