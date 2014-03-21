//
//  Movie.h
//  Ketchup
//
//  Created by Paul van Nugteren on 12.03.14.
//  Copyright (c) 2014 Paul van Nugteren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Actor;

@interface Movie : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSData * thumbnailImage;
@property (nonatomic, retain) NSDate * year;
@property (nonatomic, retain) Actor *actor;

@end
