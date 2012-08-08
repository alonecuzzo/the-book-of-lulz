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
#import "SearchResult.h"
#import "SearchResultCell.h"
#import "TBLUtil.h"
#import "AppDelegate.h"

static NSString *const kOauthConsumerKey = @"pLM9QUE1O0OYgaO81aGvZEtvnkoTeNwNXzTYoP58WHUELwJaXN";
static NSString *const kBaseTumblrApiUrl = @"http://api.tumblr.com/v2/blog/thebookoflulz.org/posts/";
static NSString *const kPhotoType = @"photo";
static NSString *const kVideoType = @"video";
static NSString *const kTextType = @"text";
static NSString *const kSearchResultCellIdentifier = @"SearchResultCell";

@interface FeedViewController ()
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end

@implementation FeedViewController {
    NSOperationQueue *queue;
    NSMutableArray *searchResults;
    UISwipeGestureRecognizer *swipeGesture;
}

@synthesize feedView = _feedView;
@synthesize searchBar = _searchBar;
@synthesize tableView = _tableView;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

-(SearchResult *)parseText:(NSDictionary *)dictionary
{
    SearchResult *result = [[SearchResult alloc] init];
    result.postURL = [dictionary objectForKey:@"post_url"];
    result.postID = [dictionary objectForKey:@"id"];
    result.tags = [dictionary objectForKey:@"tags"];
    result.timestamp = [dictionary objectForKey:@"timestamp"];
    result.caption = [dictionary objectForKey:@"caption"];
    result.type = [dictionary objectForKey:@"type"];
    result.slug = [dictionary objectForKey:@"slug"];
    
    //this bit rips out the url text in the text post
    //also needs to check for the possiblity of not having html formatted post
    NSString *format = [dictionary objectForKey:@"format"];
    NSString *bodyText = [dictionary objectForKey:@"body"];
    NSString *searchString = @"src";
    NSUInteger searchStringLocation = [bodyText rangeOfString:searchString options:(NSCaseInsensitiveSearch)].location;
    if(searchStringLocation != NSNotFound && [format isEqualToString:@"html"]){
        NSInteger urlOffset = searchString.length + 2;
        NSRange urlRange = {searchStringLocation + urlOffset, bodyText.length - (searchStringLocation + urlOffset)};
        NSString *tempString = [bodyText substringWithRange:urlRange];
        NSUInteger secondQuoteLocation = [tempString rangeOfString:@"\""].location;
        urlRange = NSMakeRange(0, secondQuoteLocation);
        tempString = [tempString substringWithRange:urlRange];
        result.textPhotoURL = tempString;
    }

    return result;
}

-(SearchResult *)parsePhoto:(NSDictionary *)dictionary
{
    SearchResult *result = [[SearchResult alloc] init];
    result.postURL = [dictionary objectForKey:@"post_url"];
    result.postID = [dictionary objectForKey:@"id"];
    result.tags = [dictionary objectForKey:@"tags"];
    result.timestamp = [dictionary objectForKey:@"timestamp"];
    result.caption = [dictionary objectForKey:@"caption"];
    result.type = [dictionary objectForKey:@"type"];
    result.slug = [dictionary objectForKey:@"slug"];
    result.photos = [dictionary objectForKey:@"photos"];
    result.linkURL = [dictionary objectForKey:@"link_url"];
    
    //if it's a gif return nil
    if ([[TBLUtil getFileExtension:[TBLUtil photoImageUrl:result]] isEqualToString:@"gif"] || [[TBLUtil getFileExtension:[TBLUtil photoImageUrl:result]] isEqualToString:@"GIF"]) {
        return nil;
    }
    
    return result;
}

-(SearchResult *)parseVideo:(NSDictionary *)dictionary
{
    SearchResult *result = [[SearchResult alloc] init];
    result.postURL = [dictionary objectForKey:@"post_url"];
    result.postID = [dictionary objectForKey:@"id"];
    result.tags = [dictionary objectForKey:@"tags"];
    result.timestamp = [dictionary objectForKey:@"timestamp"];
    result.caption = [dictionary objectForKey:@"caption"];
    result.type = [dictionary objectForKey:@"type"];
    result.permalinkURL = [dictionary objectForKey:@"permalink_url"];
    result.thumbnailURL = [dictionary objectForKey:@"thumbnail_url"];
    result.html5Capable = (BOOL)[dictionary objectForKey:@"html5_capable"];
    result.videoURL = [dictionary objectForKey:@"video_url"];
    result.slug = [dictionary objectForKey:@"slug"];
    return result;
}

-(void)parseDictionary:(NSDictionary *)dictionary
{
    NSDictionary *responseDict = [dictionary objectForKey:@"response"];
    NSArray *postsArray = [responseDict objectForKey:@"posts"];
    if(postsArray == nil){
        NSLog(@"Expected 'posts' array in json result");
        return;
    }
    
    for(NSDictionary *postDict in postsArray) {
        SearchResult *result;
        
        NSString *type = [postDict objectForKey:@"type"];
        
        if([type isEqualToString:kPhotoType]) {
            result = [self parsePhoto:postDict];
        } else if ([type isEqualToString:kVideoType]) {
            result = [self parseVideo:postDict];
        } else if ([type isEqualToString:kTextType]) {
            //result = [self parseText:postDict];
        }
        if(result != nil){
            [searchResults addObject:result];   
        }
    }
}

-(NSURL *)urlWithSearchText:(NSString *)tagString
{
    NSString *escapedTagString = [tagString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlString = [NSString stringWithFormat:@"%@?api_key=%@&tag=%@", kBaseTumblrApiUrl, kOauthConsumerKey, escapedTagString];
    NSURL *url = [NSURL URLWithString:urlString];
    return url;
}

-(void)loadData {
    
    NSString *searchText = self.searchBar.text;
    if (self.searchBar.text.length == 0) {
        searchText = @"";
    }
    NSURL *url = [self urlWithSearchText:searchText];
    //NSLog(@"our url: %@", url);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    searchResults = [NSMutableArray arrayWithCapacity:10];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON){
        //NSLog(@"result: %@", JSON);
        [self parseDictionary:JSON];
        //NSLog(@"searchResults count: %d", [searchResults count]);
        [self.tableView reloadData];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"fail: %@", error);
    }];
    
    operation.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", nil];
    
    [queue addOperation:operation];
}

-(IBAction)performSearch
{
    [self.searchBar resignFirstResponder];
    
    CGRect frame = self.feedView.frame;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    // had to use this special bridge cast... not sure exactly what it is but here's referencing article: http://stackoverflow.com/questions/8031895/refactor-to-arc-gives-error-implicit-error-picture
    [UIView beginAnimations:@"slideFeed" context:(__bridge void *)self.feedView];
    
    if(menuOpen) {
        frame.origin.x = 0;
        menuOpen = NO;
    } else {
        frame.origin.x = 270;
        menuOpen = YES;
        [self.searchBar becomeFirstResponder];
        self.searchBar.text = @"";
    }
    
    self.feedView.frame = frame;
    [UIView commitAnimations];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self performSearch];
    [self loadData];
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    menuOpen = NO;
    
    UINib *celNib = [UINib nibWithNibName:kSearchResultCellIdentifier bundle:nil];
    [self.tableView registerNib:celNib forCellReuseIdentifier:kSearchResultCellIdentifier];
    
    self.tableView.rowHeight = 240;
    
    swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedScreen:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    UIWindow *window = [(AppDelegate *)[[UIApplication sharedApplication] delegate] window];
    [window addGestureRecognizer:swipeGesture];
    
    [self loadData];
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
    UIWindow *window = [(AppDelegate *)[[UIApplication sharedApplication] delegate] window];
    [window removeGestureRecognizer:swipeGesture];
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

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [searchResults count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    SearchResultCell *cell = (SearchResultCell *)[tableView dequeueReusableCellWithIdentifier:kSearchResultCellIdentifier];
    
    // Configure the cell...
    SearchResult *currentResult = [searchResults objectAtIndex:indexPath.row];
    [cell configureForSearchResult:currentResult];
    
    return cell;
}

-(void) swipedScreen:(UISwipeGestureRecognizer*)swipeGesture {
    [self performSearch];
}


@end
