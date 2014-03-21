//
//  RottenTomatoesHTTPClient.h
//  Ketchup
//
//  Created by Paul van Nugteren on 21.02.14.
//  Copyright (c) 2014 Paul van Nugteren. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@protocol RottenTomatoesHTTPClientDelegate;

@interface RottenTomatoesHTTPClient : AFHTTPSessionManager

@property (nonatomic, weak) id<RottenTomatoesHTTPClientDelegate>delegate;

+ (RottenTomatoesHTTPClient *)sharedRottenTomatoesHTTPClient;
- (instancetype)initWithBaseURL:(NSURL *)url;
- (void)getMovies;

@end

@protocol RottenTomatoesHTTPClientDelegate <NSObject>

@optional
- (void)RottenTomatoesHTTPClient: (RottenTomatoesHTTPClient *)client didUpdateWithMovies: (id)respondsObject;
- (void)RottenTomatoesHTTPClient: (RottenTomatoesHTTPClient *)client didFailWithError: (NSError *)error;
@end