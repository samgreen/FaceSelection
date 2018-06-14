//
//  FaceModel.h
//  FaceSelection
//
//  Created by Sam Green on 6/13/18.
//  Copyright © 2018 Curious Kiwi Co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, FaceGender) {
    FaceGenderMale,
    FaceGenderFemale
};

@interface FaceModel : NSObject

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, strong) NSDictionary<NSString *, NSValue *> *landmarks;
@property (nonatomic) CGRect rectangle;
@property (nonatomic) FaceGender gender;

- (instancetype)initWithDictionary:(NSDictionary *)otherDictionary;

@end

NS_ASSUME_NONNULL_END
