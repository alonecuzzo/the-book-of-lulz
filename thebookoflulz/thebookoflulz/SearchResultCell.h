//
//  SearchResultCell.h
//  thebookoflulz
//
//  Created by Eric J Bell on 8/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchResult;

@interface SearchResultCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *searchResultImageView;

-(void)configureForSearchResult:(SearchResult *)searchResult;

@end
