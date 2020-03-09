//
//  XXYShapeCircle.h
//  XXYtieAnimator
//
//  Created by Brandon Withrow on 12/15/15.
//  Copyright © 2015 Brandon Withrow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXYKeyframe.h"

NS_ASSUME_NONNULL_BEGIN

@interface XXYShapeCircle : NSObject

- (instancetype)initWithJSON:(NSDictionary *)jsonDictionary;

@property (nonatomic, readonly) NSString *keyname;
@property (nonatomic, readonly) XXYKeyframeGroup *position;
@property (nonatomic, readonly) XXYKeyframeGroup *size;
@property (nonatomic, readonly) BOOL reversed;

@end

NS_ASSUME_NONNULL_END
