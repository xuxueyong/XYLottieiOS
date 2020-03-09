//
//  XXYStrokeRenderer.h
//  XXYtie
//
//  Created by brandon_withrow on 7/17/17.
//  Copyright © 2017 Airbnb. All rights reserved.
//

#import "XXYRenderNode.h"
#import "XXYShapeStroke.h"

@interface XXYStrokeRenderer : XXYRenderNode

- (instancetype _Nonnull)initWithInputNode:(XXYAnimatorNode *_Nullable)inputNode
                                shapeStroke:(XXYShapeStroke *_Nonnull)stroke;


@end
