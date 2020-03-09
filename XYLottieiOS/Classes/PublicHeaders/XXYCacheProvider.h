//
//  XXYCacheProvider.h
//  XXYtie
//
//  Created by punmy on 2017/7/8.
//
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE || TARGET_OS_SIMULATOR

#import <UIKit/UIKit.h>
@compatibility_alias XXYImage UIImage;

@protocol XXYImageCache;

#pragma mark - XXYCacheProvider

@interface XXYCacheProvider : NSObject

+ (id<XXYImageCache>)imageCache;
+ (void)setImageCache:(id<XXYImageCache>)cache;

@end

#pragma mark - XXYImageCache

/**
 This protocol represent the interface of a image cache which XXYtie can use.
 */
@protocol XXYImageCache <NSObject>

@required
- (XXYImage *)imageForKey:(NSString *)key;
- (void)setImage:(XXYImage *)image forKey:(NSString *)key;

@end

#endif
