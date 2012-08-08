//
//  YouTubeVideoViewController.m
//  thebookoflulz
//
//  Created by Eric J Bell on 8/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "YouTubeVideoViewController.h"
#import "LBYouTubePlayerViewController.h"

@implementation YouTubeVideoViewController

-(id)initWithUrl:(NSString *)url
{
    if ((self = [super init])) {
        LBYouTubePlayerViewController *youtubePlayer = [[LBYouTubePlayerViewController alloc] initWithYouTubeURL:[NSURL URLWithString:url]];
        youtubePlayer.quality = LBYouTubePlayerQualityLarge;
        //[self presentViewController:[youtubePlayer view] animated:YES completion:nil];
        [self.view addSubview:youtubePlayer.view];    }
         
    return self;
}


#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
