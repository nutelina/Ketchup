//
//  RottenTomatoes.m
//  Ketchup
//
//  Created by Paul van Nugteren on 18.02.14.
//  Copyright (c) 2014 Paul van Nugteren. All rights reserved.
//

#import "RottenTomatoes.h"
#import "RottenTomatoesAPI.h"

#import "AFNetworking.h"


@interface RottenTomatoes()


@end



@implementation RottenTomatoes

-(NSArray *)moreMovies
{
    if (!_moreMovies) {
        _moreMovies = [[NSArray alloc] init];
    }
    return _moreMovies;
}


-(void)getMoreMovies
{
    
    NSURL *url = [NSURL URLWithString:ROTTEN_TOMATOES_API_URL_WITH_KEY];
    NSURLRequest *request = [NSURLRequest requestWithURL: url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *jsonResults = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:NULL];
        self.moreMovies = [jsonResults valueForKeyPath:ROTTENTOMATOES_MOVIES];
        NSLog(@"Set self.moreMovies: %@", self.moreMovies);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Movies"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:@"Retry", nil];
        [alertView show];
    }];
    
    [operation start];


}


+(NSArray *)getMoviesAsync
{
    NSURL *url = [NSURL URLWithString:ROTTEN_TOMATOES_API_URL_WITH_KEY];
    NSURLRequest *request = [NSURLRequest requestWithURL: url];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    __block NSArray *movies;
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *localfile, NSURLResponse *response, NSError *error) {
        if (!error)
        {
            if ([request.URL isEqual:url])
            {
                NSData *jsonResults = [NSData dataWithContentsOfURL:url];
#warning TODO update the options and error!
                NSDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResults options:0 error:NULL];
                
                dispatch_async(dispatch_get_main_queue(), ^{movies = [propertyListResults valueForKeyPath:ROTTENTOMATOES_MOVIES]; }); //don't know how to return a value
            }
        }
    }];
    return movies;
}
                                      
                                      

@end
