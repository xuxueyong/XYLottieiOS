//
//  XXYFillRenderer.h
//  XXYtie
//
//  Created by brandon_withrow on 6/27/17.
//  Copyright © 2017 Airbnb. All rights reserved.
//

#import "XXYRenderNode.h"
#import "XXYShapeFill.h"

@interface XXYFillRenderer : XXYRenderNode

- (instancetype _Nonnull)initWithInputNode:(XXYAnimatorNode *_Nullable)inputNode
                                  shapeFill:(XXYShapeFill *_Nonnull)fill;

@end
