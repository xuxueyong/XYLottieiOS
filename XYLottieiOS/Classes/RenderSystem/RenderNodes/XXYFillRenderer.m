//
//  XXYFillRenderer.m
//  XXYtie
//
//  Created by brandon_withrow on 6/27/17.
//  Copyright © 2017 Airbnb. All rights reserved.
//

#import "XXYFillRenderer.h"
#import "XXYColorInterpolator.h"
#import "XXYNumberInterpolator.h"
#import "XXYHelpers.h"

@implementation XXYFillRenderer {
  XXYColorInterpolator *colorInterpolator_;
  XXYNumberInterpolator *opacityInterpolator_;
  BOOL _evenOddFillRule;
  CALayer *centerPoint_DEBUG;
}

- (instancetype)initWithInputNode:(XXYAnimatorNode *)inputNode
                                  shapeFill:(XXYShapeFill *)fill {
  self = [super initWithInputNode:inputNode keyName:fill.keyname];
  if (self) {
    colorInterpolator_ = [[XXYColorInterpolator alloc] initWithKeyframes:fill.color.keyframes];
    opacityInterpolator_ = [[XXYNumberInterpolator alloc] initWithKeyframes:fill.opacity.keyframes];
    centerPoint_DEBUG = [CALayer layer];
    centerPoint_DEBUG.bounds = CGRectMake(0, 0, 20, 20);
    if (ENABLE_DEBUG_SHAPES) {
      [self.outputLayer addSublayer:centerPoint_DEBUG];
    }
    _evenOddFillRule = fill.evenOddFillRule;
    
    self.outputLayer.fillRule = _evenOddFillRule ? @"even-odd" : @"non-zero";
  }
  return self;
}

- (NSDictionary *)valueInterpolators {
  return @{@"Color" : colorInterpolator_,
           @"Opacity" : opacityInterpolator_};
}

- (BOOL)needsUpdateForFrame:(NSNumber *)frame {
  return [colorInterpolator_ hasUpdateForFrame:frame] || [opacityInterpolator_ hasUpdateForFrame:frame];
}

- (void)performLocalUpdate {
  centerPoint_DEBUG.backgroundColor =  [colorInterpolator_ colorForFrame:self.currentFrame].CGColor;
  centerPoint_DEBUG.borderColor = [UIColor lightGrayColor].CGColor;
  centerPoint_DEBUG.borderWidth = 2.f;
  self.outputLayer.fillColor = [colorInterpolator_ colorForFrame:self.currentFrame].CGColor;
  self.outputLayer.opacity = [opacityInterpolator_ floatValueForFrame:self.currentFrame];
}

- (void)rebuildOutputs {
  self.outputLayer.path = self.inputNode.outputPath.CGPath;
}

- (NSDictionary *)actionsForRenderLayer {
  return @{@"backgroundColor": [NSNull null],
           @"fillColor": [NSNull null],
           @"opacity" : [NSNull null]};
}

@end
