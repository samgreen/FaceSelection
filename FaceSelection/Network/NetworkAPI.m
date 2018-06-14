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
        self.contentURL = [NSURL URLWithString:@"https://s3-us-west-2.amazonaws.com/precious-interview/ios-face-selection/family.jpg"];
    }
    return self;
}

#pragma mark - Public API
- (void)fetchFaces:(void (^)(NSArray<FaceModel *> * _Nullable))complete {
    NSURLSessionDataTask *task = [self.session dataTaskWithURL:self.metadataURL
                                             completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                 // Handle networking errors
                                                 if (error) {
                                                    NSLog(@"Fetch faces from API. Error details: %@", error.localizedDescription);
                                                     return complete(nil);
                                                 }
                                                 
                                                 // Parse the response to a foundation object
                                                 NSError *parseError = nil;
                                                 NSArray<NSDictionary *> *responseArray = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                          options:NSJSONReadingMutableLeaves
                                                                                                                            error:&parseError];
                                                 // Handle parse errors
                                                 if (parseError) {
                                                     NSLog(@"Failed to parse json response. Details: %@", parseError.localizedDescription);
                                                     return complete(nil);
                                                 }
                                                 
                                                 // Parse the foundation object to our model objects
                                                 NSMutableArray *parsedFaces = [NSMutableArray arrayWithCapacity:responseArray.count];
                                                 for (NSDictionary *faceResponse in responseArray) {
                                                     [parsedFaces addObject:[[FaceModel alloc] initWithDictionary:faceResponse]];
                                                 }
                                                 
                                                 // Return the parsed model objects
                                                 if (complete) {
                                                     complete([parsedFaces copy]);
                                                 }
                                             }];
    [task resume];
}

- (void)fetchImage:(void (^)(NSURL *))complete {
    NSURLSessionDownloadTask *task = [self.session downloadTaskWithURL:self.contentURL
                                                     completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                         // Handle networking errors
                                                         if (error) {
                                                             NSLog(@"Fetch image to location (%@). Error details: %@", location.description, error.localizedDescription);
                                                         }
                                                         
                                                         NSFileManager *fileManager = [NSFileManager defaultManager];
                                                         // Construct a path for this file in the Documents/ directory
                                                         NSURL *documentsURL = [fileManager URLsForDirectory:NSDocumentDirectory
                                                                                                   inDomains:NSUserDomainMask].firstObject;
                                                         NSURL *newImageURL = [documentsURL URLByAppendingPathComponent:@"image.jpg"];
                                                         
                                                         // Move the temporary file to the Documents/ directory
                                                         NSError *fileError = nil;
                                                         [[NSFileManager defaultManager] moveItemAtURL:location
                                                                                                 toURL:newImageURL
                                                                                                 error:&fileError];
                                                         
                                                         // Handle file errors
                                                         if (fileError) {
                                                             NSLog(@"Failed to move fetched image. Details: %@", fileError.localizedDescription);
                                                         }
                                                         
                                                         // Return the final URL for the image
                                                         if (complete) {
                                                             complete(newImageURL);
                                                         }
                                                     }];
    [task resume];
}

@end
