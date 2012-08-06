//
//  SearchResultCell.m
//  thebookoflulz
//
//  Created by Eric J Bell on 8/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SearchResultCell.h"
#import "SearchResult.h"
#import "UIImageView+AFNetworking.h"

@implementation SearchResultCell

@synthesize searchResultImageView = _searchResultImageView;

-(void)awakeFromNib
{
    [super awakeFromNib];
}

-(void)configureForSearchResult:(SearchResult *)searchResult
{
    NSLog(@"hey im a cell and im equal to: %@", searchResult.type);
    
    //check text first
    if([searchResult.type isEqualToString:@"text"]) {
        //[self.searchResultImageView setImage:[NSURL URLWithString:searchResult.textPhotoURL]];
        NSLog(@"text cell: %@", searchResult.textPhotoURL);
    } else if([searchResult.type isEqualToString:@"video"]) {
        if(searchResult.thumbnailURL.length > 0) {
            [self.searchResultImageView setImageWithURL:[NSURL URLWithString:searchResult.thumbnailURL] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
            //NSLog(@"here's teh url: %@", searchResult.thumbnailURL);
        }
    }
}

-(void)prepareForReuse
{
    [super prepareForReuse];
    [self.searchResultImageView cancelImageRequestOperation];
}

@end
