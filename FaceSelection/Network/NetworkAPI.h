//
//  NetworkAPI.h
//  FaceSelection
//
//  Created by Sam Green on 6/13/18.
//  Copyright © 2018 Curious Kiwi Co. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class FaceModel;

@interface NetworkAPI : NSObject

+ (instancetype)sharedAPI;

- (void)fetchFaces:(void (^)(NSArray<FaceModel *> * _Nullable faces))complete;
- (void)fetchImage:(void (^)(NSURL *))complete;

@end

NS_ASSUME_NONNULL_END
