//
//  XXYShapePath.h
//  XXYtieAnimator
//
//  Created by Brandon Withrow on 12/15/15.
//  Copyright © 2015 Brandon Withrow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXYKeyframe.h"

@interface XXYShapePath : NSObject

- (instancetype)initWithJSON:(NSDictionary *)jsonDictionary;

@property (nonatomic, readonly) NSString *keyname;
@property (nonatomic, readonly) BOOL closed;
@property (nonatomic, readonly) NSNumber *index;
@property (nonatomic, readonly) XXYKeyframeGroup *shapePath;

@end
