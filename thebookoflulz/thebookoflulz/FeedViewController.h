//
//  ViewController.h
//  thebookoflulz
//
//  Created by Eric J Bell on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LBYouTubePlayerViewController.h"

@interface FeedViewController : UIViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, LBYouTubePlayerControllerDelegate>{
    BOOL menuOpen;
    IBOutlet UIView *feedView;
}

@property (nonatomic, weak) UIView *feedView;

-(IBAction)performSearch;

-(void)youTubePlayerViewController:(LBYouTubePlayerViewController *)controller didSuccessfullyExtractYouTubeURL:(NSURL *)videoURL;
-(void)youTubePlayerViewController:(LBYouTubePlayerViewController *)controller failedExtractingYouTubeURLWithError:(NSError *)error;

@end
