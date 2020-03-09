//
//  XXYRoundedRectAnimator.h
//  XXYtie
//
//  Created by brandon_withrow on 7/19/17.
//  Copyright © 2017 Airbnb. All rights reserved.
//

#import "XXYAnimatorNode.h"
#import "XXYShapeRectangle.h"

@interface XXYRoundedRectAnimator : XXYAnimatorNode

- (instancetype _Nonnull)initWithInputNode:(XXYAnimatorNode *_Nullable)inputNode
                                shapeRectangle:(XXYShapeRectangle *_Nonnull)shapeRectangle;


@end
