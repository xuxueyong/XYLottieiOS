//
//  XXYPathAnimator.h
//  Pods
//
//  Created by brandon_withrow on 6/27/17.
//
//

#import "XXYAnimatorNode.h"
#import "XXYShapePath.h"

@interface XXYPathAnimator : XXYAnimatorNode

- (instancetype _Nonnull)initWithInputNode:(XXYAnimatorNode *_Nullable)inputNode
                                  shapePath:(XXYShapePath *_Nonnull)shapePath;

@end
