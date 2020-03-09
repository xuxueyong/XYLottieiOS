//
//  XXYAssetGroup.h
//  Pods
//
//  Created by Brandon Withrow on 2/17/17.
//
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@class XXYAsset;
@class XXYLayerGroup;
@interface XXYAssetGroup : NSObject
@property (nonatomic, readwrite) NSString * _Nullable rootDirectory;
@property (nonatomic, readonly, nullable) NSBundle *assetBundle;

- (instancetype _Nonnull)initWithJSON:(NSArray * _Nonnull)jsonArray
                      withAssetBundle:(NSBundle *_Nullable)bundle;

- (void)buildAssetNamed:(NSString * _Nonnull)refID;

- (void)finalizeInitialization;

- (XXYAsset * _Nullable)assetModelForID:(NSString * _Nonnull)assetID;

@end
