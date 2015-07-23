//
//  RWEpisode.h
//  DogmaDebate
//
//  Created by Rondale Williams on 6/15/15.
//  Copyright (c) 2015 RondaleWilliams. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWEpisode : NSObject
@property (nonatomic, strong) NSArray *episodes;

@property (nonatomic, strong) NSMutableArray *episodeTitles;
@property (nonatomic, strong) NSURL *imageURL;

- (instancetype)init;

@end
