//
//  XXYShapeStroke.h
//  XXYtieAnimator
//
//  Created by Brandon Withrow on 12/15/15.
//  Copyright © 2015 Brandon Withrow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXYKeyframe.h"

typedef enum : NSUInteger {
  XXYLineCapTypeButt,
  XXYLineCapTypeRound,
  XXYLineCapTypeUnknown
} XXYLineCapType;

typedef enum : NSUInteger {
  XXYLineJoinTypeMiter,
  XXYLineJoinTypeRound,
  XXYLineJoinTypeBevel
} XXYLineJoinType;

@interface XXYShapeStroke : NSObject

- (instancetype)initWithJSON:(NSDictionary *)jsonDictionary;

@property (nonatomic, readonly) NSString *keyname;
@property (nonatomic, readonly) BOOL fillEnabled;
@property (nonatomic, readonly) XXYKeyframeGroup *color;
@property (nonatomic, readonly) XXYKeyframeGroup *opacity;
@property (nonatomic, readonly) XXYKeyframeGroup *width;
@property (nonatomic, readonly) XXYKeyframeGroup *dashOffset;
@property (nonatomic, readonly) XXYLineCapType capType;
@property (nonatomic, readonly) XXYLineJoinType joinType;

@property (nonatomic, readonly) NSArray *lineDashPattern;

@end
