#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "XXYCompositionContainer.h"
#import "XXYLayerContainer.h"
#import "XXYMaskContainer.h"
#import "XXYBezierData.h"
#import "XXYKeyframe.h"
#import "CGGeometry+XXYAdditions.h"
#import "UIColor+Expanded.h"
#import "XXYBezierPath.h"
#import "XXYHelpers.h"
#import "XXYRadialGradientLayer.h"
#import "CALayer+Compat.h"
#import "LOTPlatformCompat.h"
#import "NSValue+Compat.h"
#import "UIColor.h"
#import "XXYAsset.h"
#import "XXYAssetGroup.h"
#import "XXYLayer.h"
#import "XXYLayerGroup.h"
#import "XXYMask.h"
#import "XXYModels.h"
#import "XXYShapeCircle.h"
#import "XXYShapeFill.h"
#import "XXYShapeGradientFill.h"
#import "XXYShapeGroup.h"
#import "XXYShapePath.h"
#import "XXYShapeRectangle.h"
#import "XXYShapeRepeater.h"
#import "XXYShapeStar.h"
#import "XXYShapeStroke.h"
#import "XXYShapeTransform.h"
#import "XXYShapeTrimPath.h"
#import "XXYAnimationView_Internal.h"
#import "LOTAnimatedControl.h"
#import "LOTAnimatedSwitch.h"
#import "LOTAnimationCache.h"
#import "LOTAnimationTransitionController.h"
#import "LOTAnimationView.h"
#import "LOTAnimationView_Compat.h"
#import "LOTCacheProvider.h"
#import "LOTComposition.h"
#import "Lottie.h"
#import "XXYCircleAnimator.h"
#import "XXYPathAnimator.h"
#import "XXYPolygonAnimator.h"
#import "XXYPolystarAnimator.h"
#import "XXYRoundedRectAnimator.h"
#import "XXYArrayInterpolator.h"
#import "XXYColorInterpolator.h"
#import "XXYNumberInterpolator.h"
#import "XXYPathInterpolator.h"
#import "XXYPointInterpolator.h"
#import "XXYSizeInterpolator.h"
#import "XXYTransformInterpolator.h"
#import "XXYValueInterpolator.h"
#import "XXYTrimPathNode.h"
#import "XXYFillRenderer.h"
#import "XXYGradientFillRender.h"
#import "XXYRenderGroup.h"
#import "XXYRepeaterRenderer.h"
#import "XXYStrokeRenderer.h"
#import "XXYAnimatorNode.h"
#import "XXYRenderNode.h"

FOUNDATION_EXPORT double XYLottieiOSVersionNumber;
FOUNDATION_EXPORT const unsigned char XYLottieiOSVersionString[];

