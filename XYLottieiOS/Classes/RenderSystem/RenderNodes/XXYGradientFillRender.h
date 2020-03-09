//
//  XXYGradientFillRender.h
//  XXYtie
//
//  Created by brandon_withrow on 7/27/17.
//  Copyright © 2017 Airbnb. All rights reserved.
//

#import "XXYRenderNode.h"
#import "XXYShapeGradientFill.h"

@interface XXYGradientFillRender : XXYRenderNode

- (instancetype _Nonnull)initWithInputNode:(XXYAnimatorNode *_Nullable)inputNode
                          shapeGradientFill:(XXYShapeGradientFill *_Nonnull)fill;

@end
