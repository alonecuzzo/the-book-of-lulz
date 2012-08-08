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
#import "AnimatedGif.h"
#import "TBLUtil.h"

@interface SearchResultCell ()
@property (nonatomic, weak) IBOutlet UIImageView *playIcon;
@property (nonatomic, weak) IBOutlet UIImageView *searchResultImageView;
@end


@implementation SearchResultCell{
    UIImageView *animatedGifImageView;
}

@synthesize searchResultImageView = _searchResultImageView;
@synthesize playIcon = _playIcon;

-(void)awakeFromNib
{
    [super awakeFromNib];
}

-(void)configureForSearchResult:(SearchResult *)searchResult
{
    //NSLog(@"hey im a cell and im equal to: %@", searchResult.type);

    if(![searchResult.type isEqualToString:@"video"]){
        self.playIcon.hidden = YES;    
    }
    
    //check text first
    if([searchResult.type isEqualToString:@"text"]) {
        //animatedGifImageView = [AnimatedGif getAnimationForGifAtUrl:[NSURL URLWithString:searchResult.textPhotoURL]];
        //[self.searchResultImageView addSubview:animatedGifImageView];
        //[self.searchResultImageView setImage:[NSURL URLWithString:searchResult.textPhotoURL]];
        NSLog(@"text cell: %@", searchResult.textPhotoURL);
    } else if([searchResult.type isEqualToString:@"video"]) {
        if(searchResult.thumbnailURL.length > 0) {
            self.playIcon.hidden = NO;
            if (![[TBLUtil getFileExtension:searchResult.thumbnailURL] isEqualToString:@"gif"] || ![[TBLUtil getFileExtension:searchResult.thumbnailURL] isEqualToString:@"GIF"]) {
                [self.searchResultImageView setImageWithURL:[NSURL URLWithString:searchResult.thumbnailURL] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
            }
            //NSLog(@"file extension: %@", [self getFileExtension:searchResult.thumbnailURL]);
        }
    } else if([searchResult.type isEqualToString:@"photo"]) {
        NSString *imageUrl = [TBLUtil photoImageUrl:searchResult];
        NSLog(@"image url: %@", imageUrl);
        if(![[TBLUtil getFileExtension:imageUrl] isEqualToString:@"gif"] || [[TBLUtil getFileExtension:imageUrl] isEqualToString:@"GIF"] ) {
            [self.searchResultImageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
        }
    }
}

-(void)prepareForReuse
{
    [super prepareForReuse];
    [self.searchResultImageView cancelImageRequestOperation];
    animatedGifImageView = nil;
}

@end
