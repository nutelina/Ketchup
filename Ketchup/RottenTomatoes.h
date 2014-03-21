//
//  RottenTomatoes.h
//  Ketchup
//
//  Created by Paul van Nugteren on 18.02.14.
//  Copyright (c) 2014 Paul van Nugteren. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ROTTENTOMATOES_TITLE @"movies.title"
#define ROTTENTOMATOES_MOVIES @"movies"


@interface RottenTomatoes : NSObject

@property (nonatomic, strong) NSArray *moreMovies;

-(void)getMoreMovies;
+(NSArray *)getMoviesAsync;

@end
