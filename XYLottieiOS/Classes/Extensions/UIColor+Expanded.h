#import "XXYPlatformCompat.h"

// From http://github.com/ars/uicolor-utilities
#define CLAMP(val,min,max)    MIN(MAX(val,min),max)

@interface UIColor (UIColor_Expanded)
@property (nonatomic, readonly) CGColorSpaceModel colorSpaceModel;
@property (nonatomic, readonly) BOOL canProvideRGBComponents;
@property (nonatomic, readonly) CGFloat red; // Only valid if canProvideRGBComponents is YES
@property (nonatomic, readonly) CGFloat green; // Only valid if canProvideRGBComponents is YES
@property (nonatomic, readonly) CGFloat blue; // Only valid if canProvideRGBComponents is YES
@property (nonatomic, readonly) CGFloat white; // Only valid if colorSpaceModel == kCGColorSpaceModelMonochrome
@property (nonatomic, readonly) CGFloat alpha;
@property (nonatomic, readonly) UInt32 rgbHex;

- (NSString *)XXY_colorSpaceString;

- (NSArray *)XXY_arrayFromRGBAComponents;

- (BOOL)XXY_red:(CGFloat *)r green:(CGFloat *)g blue:(CGFloat *)b alpha:(CGFloat *)a;

- (UIColor *)XXY_colorByLuminanceMapping;

- (UIColor *)XXY_colorByMultiplyingByRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
- (UIColor *)       XXY_colorByAddingRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
- (UIColor *) XXY_colorByLighteningToRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
- (UIColor *)  XXY_colorByDarkeningToRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

- (UIColor *)XXY_colorByMultiplyingBy:(CGFloat)f;
- (UIColor *)       XXY_colorByAdding:(CGFloat)f;
- (UIColor *) XXY_colorByLighteningTo:(CGFloat)f;
- (UIColor *)  XXY_colorByDarkeningTo:(CGFloat)f;

- (UIColor *)XXY_colorByMultiplyingByColor:(UIColor *)color;
- (UIColor *)       XXY_colorByAddingColor:(UIColor *)color;
- (UIColor *) XXY_colorByLighteningToColor:(UIColor *)color;
- (UIColor *)  XXY_colorByDarkeningToColor:(UIColor *)color;

- (NSString *)XXY_stringFromColor;
- (NSString *)XXY_hexStringValue;

+ (UIColor *)XXY_randomColor;
+ (UIColor *)XXY_colorWithString:(NSString *)stringToConvert;
+ (UIColor *)XXY_colorWithRGBHex:(UInt32)hex;
+ (UIColor *)XXY_colorWithHexString:(NSString *)stringToConvert;

+ (UIColor *)XXY_colorWithName:(NSString *)cssColorName;

+ (UIColor *)XXY_colorByLerpingFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor amount:(CGFloat)amount;

@end
