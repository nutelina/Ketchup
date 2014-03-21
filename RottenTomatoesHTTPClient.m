//
//  RottenTomatoesHTTPClient.m
//  Ketchup
//
//  Created by Paul van Nugteren on 21.02.14.
//  Copyright (c) 2014 Paul van Nugteren. All rights reserved.
//

#import "RottenTomatoesHTTPClient.h"
#import "RottenTomatoesAPI.h"


@interface RottenTomatoesHTTPClient()

@property (nonatomic) int currentPage;


@end


@implementation RottenTomatoesHTTPClient

- (int)currentPage
{
    if (!_currentPage) _currentPage = 1;
    return _currentPage;
}


+ (RottenTomatoesHTTPClient *)sharedRottenTomatoesHTTPClient
{
    static RottenTomatoesHTTPClient *_sharedRottenTomatoesHTTPClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedRottenTomatoesHTTPClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:RottenTomatoesAPIBaseUrl]];
    });
    
    return _sharedRottenTomatoesHTTPClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self)
    {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
        return self;
}

- (void)getMovies
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    int bufferOffset = 1;
    
    for (int i = self.currentPage; i < self.currentPage +bufferOffset; i++)
    {
        
        NSString *nextPage = [NSString stringWithFormat:@"%d", i];
        parameters[@"page"] = nextPage;
        NSLog(@"Page %@", nextPage);
        parameters[@"page_limit"] = @"50"; //standard tableview 11 cells per screen
        parameters[@"apikey"] = RottenTomatoesAPIKey;
        parameters[@"country"] = RottenTomatoesAPICountry;
        
        [self GET:RottenTomatoesAPIWhatToGet parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject)
         {
             if ([self.delegate respondsToSelector:@selector(RottenTomatoesHTTPClient:didUpdateWithMovies:)])
             {
                 [self.delegate RottenTomatoesHTTPClient:self didUpdateWithMovies:responseObject];
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error)
         {
             if ([self.delegate respondsToSelector:@selector(RottenTomatoesHTTPClient:didFailWithError:)])
             {
                 [self.delegate RottenTomatoesHTTPClient:self didFailWithError:error];
             }
         }];
        
    }
    self.currentPage = self.currentPage + bufferOffset; //next page
    
}


@end
