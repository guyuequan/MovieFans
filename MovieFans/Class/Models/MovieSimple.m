//
//  MovieSimple.m
//  TVFans
//
//  Created by Leo Gao on 2/18/15.
//  Copyright (c) 2015 LeoCode. All rights reserved.
//

#import "MovieSimple.h"

@implementation MovieSimple
- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_movieID forKey:@"movieID"];
    [encoder encodeObject:_movieName forKey:@"movieName"];
    [encoder encodeObject:_posterPathMedium forKey:@"posterPathMedium"];
    [encoder encodeObject:_posterPathLarge forKey:@"posterPathLarge"];
    [encoder encodeObject:_categoryArr forKey:@"categoryArr"];
    [encoder encodeObject:_country forKey:@"country"];
    [encoder encodeObject:_rating forKey:@"rating"];
    [encoder encodeObject:_pubDate forKey:@"pubDate"];
    [encoder encodeObject:_year forKey:@"year"];
    [encoder encodeObject:_rank forKey:@"rank"];
    [encoder encodeObject:_wishSee forKey:@"wishSee"];
}
- (id)initWithCoder:(NSCoder *)decoder {
    if(self = [super init]){
        _movieID = [decoder decodeObjectForKey:@"movieID"];
        _movieName = [decoder decodeObjectForKey:@"movieName"];
        _posterPathMedium = [decoder decodeObjectForKey:@"posterPathMedium"];
        _posterPathLarge = [decoder decodeObjectForKey:@"posterPathLarge"];
        _categoryArr = [decoder decodeObjectForKey:@"categoryArr"];
        _country = [decoder decodeObjectForKey:@"country"];
        _rating = [decoder decodeObjectForKey:@"rating"];
        _pubDate = [decoder decodeObjectForKey:@"pubDate"];
        _year = [decoder decodeObjectForKey:@"year"];
        _rank = [decoder decodeObjectForKey:@"rank"];
        _wishSee = [decoder decodeObjectForKey:@"wishSee"];
    }
    return self;
}
- (NSString *)description{
    return [NSString stringWithFormat:@"\n{id:%@\n,name:%@\n}",self.movieID,self.movieName];
}
@end
