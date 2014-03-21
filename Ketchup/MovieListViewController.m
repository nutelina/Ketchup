//
//  MovieListViewController.m
//  Ketchup
//
//  Created by Paul van Nugteren on 18.02.14.
//  Copyright (c) 2014 Paul van Nugteren. All rights reserved.
//

#import "MovieListViewController.h"
#import "RottenTomatoesAPI.h"
#import "UIImageView+AFNetworking.h"


@interface MovieListViewController ()


@property (nonatomic, strong) RottenTomatoesHTTPClient *rottenTomatoesHTTPClient;

@property (nonatomic, getter = isFetching) BOOL fetching;
@property (nonatomic, strong) NSMutableArray *placeHolder;

@end

@implementation MovieListViewController


-(RottenTomatoesHTTPClient *)rottenTomatoesHTTPClient
{
    if (!_rottenTomatoesHTTPClient) _rottenTomatoesHTTPClient = [RottenTomatoesHTTPClient sharedRottenTomatoesHTTPClient];
    
    return _rottenTomatoesHTTPClient;
        
}


@synthesize items =_items;

- (void)setItems:(NSMutableArray *)items
{
    _items = items;
}



-(NSMutableArray *)items
{
    if (!_items)
    {
        NSMutableArray * items = [[NSMutableArray alloc] init];
        _items = items;
        
    }
    return _items;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.placeHolder = [[NSMutableArray alloc] init];
    for (int i = 0; i < 1000; i++) {
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"Loading...", @"title", nil];
        [self.placeHolder addObject: dict];
    }
    
    self.rottenTomatoesHTTPClient.delegate = self;
    [self.rottenTomatoesHTTPClient getMovies];
    self.fetching = NO;
}

- (void)RottenTomatoesHTTPClient: (RottenTomatoesHTTPClient *)client didUpdateWithMovies: (id)respondsObject
{
    
    NSArray *moreMovies = [respondsObject valueForKeyPath: RottenTomatoesMovies];
    if ([self.items count] > [self.placeHolder count])
    {
    NSRange tail = NSMakeRange([self.items count] - [self.placeHolder count], [self.placeHolder count]);
    [self.items removeObjectsInRange: tail];
    [self.items addObjectsFromArray: moreMovies];
    [self.tableView reloadData];
    }
    else
    {
        [self.items addObjectsFromArray: moreMovies];
        [self.tableView reloadData];
    }
    self.fetching = NO;
}

- (void)RottenTomatoesHTTPClient: (RottenTomatoesHTTPClient *)client didFailWithError: (NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Movies"
                                                        message:[NSString stringWithFormat:@"%@",error]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items count];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat actualPosition = scrollView.bounds.size.height + scrollView.contentOffset.y;
    CGFloat contentBufferBoundery = scrollView.contentSize.height - 200; //Magic number how close to the end of tableView the it should start fetching
 
    if (actualPosition >= contentBufferBoundery && !self.isFetching) //RottenTomatoes has a limit of 5 calls a second
    {
        [self.items addObjectsFromArray: self.placeHolder];
        [self.tableView reloadData];
        [self.rottenTomatoesHTTPClient getMovies];
        self.fetching = YES;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    
    if (self.items) {
        if ([self.items[indexPath.row] isKindOfClass: [NSDictionary class]])
        {
            NSDictionary *movie = self.items[indexPath.row];
            NSString *movieTitle = [movie objectForKey:RottenTomatoesMovieTitle];
            cell.textLabel.text = movieTitle;
            

            NSURL *url = [NSURL URLWithString:[movie valueForKeyPath: RottenTomatoesMovieThumbnail]];

            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
            
            __weak UITableViewCell *weakCell = cell;
            
            [cell.imageView setImageWithURLRequest:request
                                  placeholderImage:placeholderImage
                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                               
                                               weakCell.imageView.image = image;
                                               [weakCell setNeedsLayout];
                                               
                                           } failure:nil];

        }   
    }
        return cell;
}


@end
