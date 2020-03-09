
#import "XXYPlatformCompat.h"

#import <CoreGraphics/CoreGraphics.h>
#import <GLKit/GLKMathTypes.h>
#import <GLKit/GLKit.h>
//
// Core Graphics Geometry Additions
//

extern const CGSize CGSizeMax;

CGRect XXY_RectIntegral(CGRect rect);

// Centering

// Returns a rectangle of the given size, centered at a point
CGRect XXY_RectCenteredAtPoint(CGPoint center, CGSize size, BOOL integral);

// Returns the center point of a CGRect
CGPoint XXY_RectGetCenterPoint(CGRect rect);

// Insetting

// Inset the rectangle on a single edge
CGRect XXY_RectInsetLeft(CGRect rect, CGFloat inset);
CGRect XXY_RectInsetRight(CGRect rect, CGFloat inset);
CGRect XXY_RectInsetTop(CGRect rect, CGFloat inset);
CGRect XXY_RectInsetBottom(CGRect rect, CGFloat inset);

// Inset the rectangle on two edges
CGRect XXY_RectInsetHorizontal(CGRect rect, CGFloat leftInset, CGFloat rightInset);
CGRect XXY_RectInsetVertical(CGRect rect, CGFloat topInset, CGFloat bottomInset);

// Inset the rectangle on all edges
CGRect XXY_RectInsetAll(CGRect rect, CGFloat leftInset, CGFloat rightInset, CGFloat topInset, CGFloat bottomInset);

// Framing

// Returns a rectangle of size framed in the center of the given rectangle
CGRect XXY_RectFramedCenteredInRect(CGRect rect, CGSize size, BOOL integral);

// Returns a rectangle of size framed in the given rectangle and inset
CGRect XXY_RectFramedLeftInRect(CGRect rect, CGSize size, CGFloat inset, BOOL integral);
CGRect XXY_RectFramedRightInRect(CGRect rect, CGSize size, CGFloat inset, BOOL integral);
CGRect XXY_RectFramedTopInRect(CGRect rect, CGSize size, CGFloat inset, BOOL integral);
CGRect XXY_RectFramedBottomInRect(CGRect rect, CGSize size, CGFloat inset, BOOL integral);

CGRect XXY_RectFramedTopLeftInRect(CGRect rect, CGSize size, CGFloat insetWidth, CGFloat insetHeight, BOOL integral);
CGRect XXY_RectFramedTopRightInRect(CGRect rect, CGSize size, CGFloat insetWidth, CGFloat insetHeight, BOOL integral);
CGRect XXY_RectFramedBottomLeftInRect(CGRect rect, CGSize size, CGFloat insetWidth, CGFloat insetHeight, BOOL integral);
CGRect XXY_RectFramedBottomRightInRect(CGRect rect, CGSize size, CGFloat insetWidth, CGFloat insetHeight, BOOL integral);

// Divides a rect into sections and returns the section at specified index

CGRect XXY_RectDividedSection(CGRect rect, NSInteger sections, NSInteger index, CGRectEdge fromEdge);

// Returns a rectangle of size attached to the given rectangle
CGRect XXY_RectAttachedLeftToRect(CGRect rect, CGSize size, CGFloat margin, BOOL integral);
CGRect XXY_RectAttachedRightToRect(CGRect rect, CGSize size, CGFloat margin, BOOL integral);
CGRect XXY_RectAttachedTopToRect(CGRect rect, CGSize size, CGFloat margin, BOOL integral);
CGRect XXY_RectAttachedBottomToRect(CGRect rect, CGSize size, CGFloat margin, BOOL integral);

CGRect XXY_RectAttachedBottomLeftToRect(CGRect rect, CGSize size, CGFloat marginWidth, CGFloat marginHeight, BOOL integral);
CGRect XXY_RectAttachedBottomRightToRect(CGRect rect, CGSize size, CGFloat marginWidth, CGFloat marginHeight, BOOL integral);
CGRect XXY_RectAttachedTopRightToRect(CGRect rect, CGSize size, CGFloat marginWidth, CGFloat marginHeight, BOOL integral);
CGRect XXY_RectAttachedTopLeftToRect(CGRect rect, CGSize size, CGFloat marginWidth, CGFloat marginHeight, BOOL integral);

BOOL XXY_CGPointIsZero(CGPoint point);

// Combining
// Adds all values of the 2nd rect to the first rect
CGRect XXY_RectAddRect(CGRect rect, CGRect other);
CGRect XXY_RectAddPoint(CGRect rect, CGPoint point);
CGRect XXY_RectAddSize(CGRect rect, CGSize size);
CGRect XXY_RectBounded(CGRect rect);

CGPoint XXY_PointAddedToPoint(CGPoint point1, CGPoint point2);

CGRect XXY_RectSetHeight(CGRect rect, CGFloat height);

CGFloat XXY_PointDistanceFromPoint(CGPoint point1, CGPoint point2);
CGFloat XXY_DegreesToRadians(CGFloat degrees);

GLKMatrix4 XXY_GLKMatrix4FromCATransform(CATransform3D xform);

CATransform3D XXY_CATransform3DFromGLKMatrix4(GLKMatrix4 xform);

CATransform3D XXY_CATransform3DSlerpToTransform(CATransform3D fromXorm, CATransform3D toXform, CGFloat amount );

CGFloat XXY_RemapValue(CGFloat value, CGFloat low1, CGFloat high1, CGFloat low2, CGFloat high2 );
CGPoint XXY_PointByLerpingPoints(CGPoint point1, CGPoint point2, CGFloat value);

CGPoint XXY_PointInLine(CGPoint A, CGPoint B, CGFloat T);
CGPoint XXY_PointInCubicCurve(CGPoint start, CGPoint cp1, CGPoint cp2, CGPoint end, CGFloat T);

CGFloat XXY_CubicBezeirInterpolate(CGPoint P0, CGPoint P1, CGPoint P2, CGPoint P3, CGFloat x);
CGFloat XXY_SolveCubic(CGFloat a, CGFloat b, CGFloat c, CGFloat d);
CGFloat XXY_SolveQuadratic(CGFloat a, CGFloat b, CGFloat c);
CGFloat XXY_Squared(CGFloat f);
CGFloat XXY_Cubed(CGFloat f);
CGFloat XXY_CubicRoot(CGFloat f);

CGFloat XXY_CubicLength(CGPoint fromPoint, CGPoint toPoint, CGPoint controlPoint1, CGPoint controlPoint2);
CGFloat XXY_CubicLengthWithPrecision(CGPoint fromPoint, CGPoint toPoint, CGPoint controlPoint1, CGPoint controlPoint2, CGFloat iterations);
