//
//  XXYTrimPathNode.h
//  XXYtie
//
//  Created by brandon_withrow on 7/21/17.
//  Copyright © 2017 Airbnb. All rights reserved.
//

#import "XXYAnimatorNode.h"
#import "XXYShapeTrimPath.h"

@interface XXYTrimPathNode : XXYAnimatorNode

- (instancetype _Nonnull)initWithInputNode:(XXYAnimatorNode *_Nullable)inputNode
                                  trimPath:(XXYShapeTrimPath *_Nonnull)trimPath;

@end
