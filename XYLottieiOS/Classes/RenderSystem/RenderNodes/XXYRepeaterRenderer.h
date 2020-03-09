//
//  XXYRepeaterRenderer.h
//  XXYtie
//
//  Created by brandon_withrow on 7/28/17.
//  Copyright © 2017 Airbnb. All rights reserved.
//

#import "XXYRenderNode.h"
#import "XXYShapeRepeater.h"

@interface XXYRepeaterRenderer : XXYRenderNode

- (instancetype _Nonnull)initWithInputNode:(XXYAnimatorNode *_Nullable)inputNode
                              shapeRepeater:(XXYShapeRepeater *_Nonnull)repeater;

@end
