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

-(void)configureForSearchResult:(SearchResult *)searchResult;

@end
