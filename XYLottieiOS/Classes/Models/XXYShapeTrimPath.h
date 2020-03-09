//
//  XXYShapeTrimPath.h
//  XXYtieAnimator
//
//  Created by brandon_withrow on 7/26/16.
//  Copyright © 2016 Brandon Withrow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXYKeyframe.h"

@interface XXYShapeTrimPath : NSObject

- (instancetype)initWithJSON:(NSDictionary *)jsonDictionary;

@property (nonatomic, readonly) NSString *keyname;
@property (nonatomic, readonly) XXYKeyframeGroup *start;
@property (nonatomic, readonly) XXYKeyframeGroup *end;
@property (nonatomic, readonly) XXYKeyframeGroup *offset;

@end
