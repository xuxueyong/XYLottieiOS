//
//  XXYCacheProvider.m
//  XXYtie
//
//  Created by punmy on 2017/7/8.
//
//

#import "XXYCacheProvider.h"

@implementation XXYCacheProvider

static id<XXYImageCache> _imageCache;

+ (id<XXYImageCache>)imageCache {
    return _imageCache;
}

+ (void)setImageCache:(id<XXYImageCache>)cache {
    _imageCache = cache;
}

@end
