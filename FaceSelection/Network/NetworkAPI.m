//
//  NetworkAPI.m
//  FaceSelection
//
//  Created by Sam Green on 6/13/18.
//  Copyright © 2018 Curious Kiwi Co. All rights reserved.
//

#import "NetworkAPI.h"
#import "FaceModel.h"

@interface NetworkAPI ()

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURL *metadataURL;
@property (nonatomic, strong) NSURL *contentURL;

@end

@implementation NetworkAPI

#pragma mark - Singleton
+ (instancetype)sharedAPI {
    static NetworkAPI *gNetworkAPI = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gNetworkAPI = [[NetworkAPI alloc] init];
    });
    return gNetworkAPI;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        self.metadataURL = [NSURL URLWithString:@"https://s3-us-west-2.amazonaws.com/precious-interview/ios-face-selection/family_faces.json"];
    }
    return self;
}

#pragma mark - Public API
- (void)fetchFaces:(void (^)(NSArray<FaceModel *> * _Nullable))complete {
    NSURLSessionDataTask *task = [self.session dataTaskWithURL:self.metadataURL
                                             completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                 NSLog(@"Fetch faces from API. Error details: %@", error.localizedDescription);
                                                 NSError *parseError = nil;
                                                 NSArray<NSDictionary *> *responseArray = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                          options:NSJSONReadingMutableLeaves
                                                                                                                            error:&parseError];
                                                 if (parseError) {
                                                     NSLog(@"Failed to parse json response. Details: %@", parseError.localizedDescription);
                                                     return complete(nil);
                                                 }
                                                 
                                                 NSMutableArray *parsedFaces = [NSMutableArray arrayWithCapacity:responseArray.count];
                                                 for (NSDictionary *faceResponse in responseArray) {
                                                     [parsedFaces addObject:[[FaceModel alloc] initWithDictionary:faceResponse]];
                                                 }
                                                 
                                                 if (complete) {
                                                     complete([parsedFaces copy]);
                                                 }
                                             }];
    [task resume];
}

- (void)fetchImage:(void (^)(void))complete {
    NSURLSessionDownloadTask *task = [self.session downloadTaskWithURL:self.contentURL
                                                     completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                         NSLog(@"Fetch image to location (%@). Error details: %@", location.description, error.localizedDescription);
                                                     }];
    [task resume];
}

@end
