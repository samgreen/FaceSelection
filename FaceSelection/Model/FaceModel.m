//
//  FaceModel.m
//  FaceSelection
//
//  Created by Sam Green on 6/13/18.
//  Copyright © 2018 Curious Kiwi Co. All rights reserved.
//

#import "FaceModel.h"
#import <UIKit/UIKit.h>

#pragma mark - API Keys
static const NSString *const kFaceLandmarksKey = @"faceLandmarks";
static const NSString *const kFaceIdentifierKey = @"faceId";
static const NSString *const kFaceRectangleKey = @"faceRectangle";
static const NSString *const kFaceAttributesKey = @"faceAttributes";

static const NSString *const kRectangleOriginXKey = @"left";
static const NSString *const kRectangleOriginYKey = @"top";
static const NSString *const kRectangleWidthKey = @"width";
static const NSString *const kRectangleHeightKey = @"height";

static const NSString *const kLandmarkOriginXKey = @"x";
static const NSString *const kLandmarkOriginYKey = @"y";

static const NSString *const kAttributeGenderKey = @"female";

#pragma mark - API Values
static NSString *kGenderFemaleValue = @"female";
static NSString *kGenderMaleValue = @"male";

@implementation FaceModel

- (instancetype)initWithDictionary:(NSDictionary *)otherDictionary {
    self = [super init];
    if (self) {
        self.identifier = otherDictionary[kFaceIdentifierKey];
        self.landmarks = [FaceModel parseLandmarksFromDictionary:otherDictionary];
        self.rectangle = [FaceModel parseRectFromDictionary:otherDictionary];
        self.gender = [FaceModel parseGenderFromDictionary:otherDictionary];
    }
    return self;
}

+ (NSDictionary<NSString *, NSValue *> *)parseLandmarksFromDictionary:(NSDictionary *)dictionary {
    NSDictionary *landmarkDictionary = dictionary[kFaceLandmarksKey];
    NSMutableDictionary<NSString *, NSValue *> *parsedLandmarks = [NSMutableDictionary dictionaryWithCapacity:landmarkDictionary.allKeys.count];
    for (NSString *name in landmarkDictionary.allKeys) {
        NSDictionary *landmarkInfo = landmarkDictionary[name];
        const CGFloat x = [landmarkInfo[kLandmarkOriginXKey] floatValue];
        const CGFloat y = [landmarkInfo[kLandmarkOriginYKey] floatValue];
        parsedLandmarks[name] = [NSValue valueWithCGPoint:CGPointMake(x, y)];
    }
    return [parsedLandmarks copy];
}

+ (CGRect)parseRectFromDictionary:(NSDictionary *)dictionary {
    NSDictionary *rectangleDictionary = dictionary[kFaceRectangleKey];
    const CGFloat x = [rectangleDictionary[kRectangleOriginXKey] floatValue];
    const CGFloat y = [rectangleDictionary[kRectangleOriginYKey] floatValue];
    const CGFloat width = [rectangleDictionary[kRectangleWidthKey] floatValue];
    const CGFloat height = [rectangleDictionary[kRectangleHeightKey] floatValue];
    return CGRectMake(x, y, width, height);
}

+ (FaceGender)parseGenderFromDictionary:(NSDictionary *)dictionary {
    NSDictionary *attributesDictionary = dictionary[kFaceAttributesKey];
    NSString *genderValue = attributesDictionary[kAttributeGenderKey];
    if ([genderValue isEqualToString:kGenderFemaleValue]) {
        return FaceGenderFemale;
    } else {
        return FaceGenderMale;
    }
}

@end
