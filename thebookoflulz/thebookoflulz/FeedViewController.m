//
//  ViewController.m
//  thebookoflulz
//
//  Created by Eric J Bell on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FeedViewController.h"
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>


@implementation FeedViewController 

@synthesize feedView = _feedView;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

-(IBAction)searchButtonTapped:(id)sender
{
    NSLog(@"tapped");
    
    CGRect frame = self.feedView.frame;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    // had to use this special bridge cast... not sure exactly what it is but here's referencing article: http://stackoverflow.com/questions/8031895/refactor-to-arc-gives-error-implicit-error-picture
    [UIView beginAnimations:@"slideFeed" context:(__bridge void *)self.feedView];
    
    if(menuOpen) {
        frame.origin.x = 0;
        menuOpen = NO;
    } else {
        frame.origin.x = 200;
        menuOpen = YES;
    }
    
    self.feedView.frame = frame;
    [UIView commitAnimations];
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    menuOpen = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
