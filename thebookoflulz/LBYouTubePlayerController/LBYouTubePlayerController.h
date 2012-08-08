//
//  LBYouTubePlayerController.h
//  LBYouTubeView
//
//  Created by Laurin Brandner on 29.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface LBYouTubePlayerController : UIView {
    MPMoviePlayerViewController* controller;
}

@property (nonatomic, strong, readonly) MPMoviePlayerViewController* controller;

-(void)loadYouTubeVideo:(NSURL*)URL;

@end
