//
//  ViewController.m
//  FaceSelection
//
//  Created by Daniel Lau on 4/26/18.
//  Copyright © 2018 Curious Kiwi Co. All rights reserved.
//

#import "ViewController.h"
#import "Network/NetworkAPI.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, weak) IBOutlet UITextView *textView;

@property (nonatomic, strong) NSArray<FaceModel *> *faces;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.loadingIndicator startAnimating];
    self.imageView.image = nil;
    self.textView.text = nil;
    
    // Image URL: https://s3-us-west-2.amazonaws.com/precious-interview/ios-face-selection/family.jpg
    // JSON URL: https://s3-us-west-2.amazonaws.com/precious-interview/ios-face-selection/family_faces.json
    // JSON contents documentation: https://westus.dev.cognitive.microsoft.com/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236

    [[NetworkAPI sharedAPI] fetchFaces:^(NSArray<FaceModel *> *faces) {
        self.faces = faces;
    }];
    
    [[NetworkAPI sharedAPI] fetchImage:^{
        // TODO: enable image view
        self.imageView.image = nil;
    }];
}

@end
