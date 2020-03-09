//
//  XXYPolystarAnimator.h
//  XXYtie
//
//  Created by brandon_withrow on 7/27/17.
//  Copyright © 2017 Airbnb. All rights reserved.
//

#import "XXYAnimatorNode.h"
#import "XXYShapeStar.h"

@interface XXYPolystarAnimator : XXYAnimatorNode

- (instancetype _Nonnull)initWithInputNode:(XXYAnimatorNode *_Nullable)inputNode
                             shapeStar:(XXYShapeStar *_Nonnull)shapeStar;

@end
