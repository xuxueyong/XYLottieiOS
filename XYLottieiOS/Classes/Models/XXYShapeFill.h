//
//  XXYShapeFill.h
//  XXYtieAnimator
//
//  Created by Brandon Withrow on 12/15/15.
//  Copyright © 2015 Brandon Withrow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXYKeyframe.h"

NS_ASSUME_NONNULL_BEGIN

@interface XXYShapeFill : NSObject

- (instancetype)initWithJSON:(NSDictionary *)jsonDictionary;

@property (nonatomic, readonly) NSString *keyname;
@property (nonatomic, readonly) BOOL fillEnabled;
@property (nonatomic, readonly) XXYKeyframeGroup *color;
@property (nonatomic, readonly) XXYKeyframeGroup *opacity;
@property (nonatomic, readonly) BOOL evenOddFillRule;

@end

NS_ASSUME_NONNULL_END
