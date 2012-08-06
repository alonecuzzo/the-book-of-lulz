//
//  SearchResult.h
//  thebookoflulz
//
//  Created by Eric J Bell on 8/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchResult : NSObject

@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *postURL;
@property (nonatomic, copy) NSString *videoURL;
@property (nonatomic, copy) NSString *thumbnailURL;
@property (nonatomic, copy) NSString *permalinkURL;
@property (nonatomic, copy) NSNumber *timestamp;
@property (nonatomic, copy) NSString *caption;
@property (nonatomic, copy) NSNumber *postID;
@property (nonatomic, copy) NSArray *tags;
@property (nonatomic, copy) NSArray *photos;
@property (nonatomic, copy) NSString *slug;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *linkURL;
@property (nonatomic, copy) NSString *textPhotoURL;
@property (nonatomic) BOOL html5Capable;


@end
