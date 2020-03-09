//
//  XXYCircleAnimator.h
//  XXYtie
//
//  Created by brandon_withrow on 7/19/17.
//  Copyright © 2017 Airbnb. All rights reserved.
//

#import "XXYAnimatorNode.h"
#import "XXYShapeCircle.h"

@interface XXYCircleAnimator : XXYAnimatorNode

- (instancetype _Nonnull)initWithInputNode:(XXYAnimatorNode *_Nullable)inputNode
                                  shapeCircle:(XXYShapeCircle *_Nonnull)shapeCircle;

@end
