//
//  XXYRenderGroup.h
//  XXYtie
//
//  Created by brandon_withrow on 6/27/17.
//  Copyright © 2017 Airbnb. All rights reserved.
//

#import "XXYRenderNode.h"

@interface XXYRenderGroup : XXYRenderNode

- (instancetype _Nonnull)initWithInputNode:(XXYAnimatorNode * _Nullable)inputNode
                                   contents:(NSArray * _Nonnull)contents
                                    keyname:(NSString * _Nullable)keyname;

@property (nonatomic, strong, readonly) CALayer * _Nonnull containerLayer;

@end


