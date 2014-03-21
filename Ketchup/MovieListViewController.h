//
//  MovieListViewController.h
//  Ketchup
//
//  Created by Paul van Nugteren on 18.02.14.
//  Copyright (c) 2014 Paul van Nugteren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RottenTomatoesHTTPClient.h"

@interface MovieListViewController : UITableViewController <RottenTomatoesHTTPClientDelegate>

@property (nonatomic, strong) NSMutableArray *items; // of movies NSDictionary


@end
