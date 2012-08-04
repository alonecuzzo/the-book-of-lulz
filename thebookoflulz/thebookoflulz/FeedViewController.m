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
#import "AFJSONRequestOperation.h"

static NSString *const kOauthConsumerKey = @"pLM9QUE1O0OYgaO81aGvZEtvnkoTeNwNXzTYoP58WHUELwJaXN";
static NSString *const kBaseTumblrApiUrl = @"http://api.tumblr.com/v2/blog/thebookoflulz.org/posts/";

@interface FeedViewController ()
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@end

@implementation FeedViewController {
    NSOperationQueue *queue;
}

@synthesize feedView = _feedView;
@synthesize searchBar = _searchBar;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    menuOpen = NO;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        queue = [[NSOperationQueue alloc] init];
    }
    return self;
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

-(NSURL *)urlWithSearchText:(NSString *)searchText
{
    NSString *escapedSearchString = [searchText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlString = [NSString stringWithFormat:@"%@?api_key=%@", kBaseTumblrApiUrl, kOauthConsumerKey];
    NSURL *url = [NSURL URLWithString:urlString];
    return url;
}

-(void)loadData {
    
    NSString *searchText = self.searchBar.text;
    if (self.searchBar.text.length == 0) {
        searchText = @"";
    }
    NSURL *url = [self urlWithSearchText:searchText];
    NSLog(@"our url: %@", url);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON){
        NSLog(@"result: %@", JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"fail: %@", error);
    }];
    
    operation.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", nil];
    
    [queue addOperation:operation];
}

-(IBAction)searchButtonTapped:(id)sender
{
    CGRect frame = self.feedView.frame;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    // had to use this special bridge cast... not sure exactly what it is but here's referencing article: http://stackoverflow.com/questions/8031895/refactor-to-arc-gives-error-implicit-error-picture
    [UIView beginAnimations:@"slideFeed" context:(__bridge void *)self.feedView];
    
    if(menuOpen) {
        frame.origin.x = 0;
        menuOpen = NO;
    } else {
        frame.origin.x = 245;
        menuOpen = YES;
    }
    
    self.feedView.frame = frame;
    [UIView commitAnimations];
    
    [self loadData];
}




@end