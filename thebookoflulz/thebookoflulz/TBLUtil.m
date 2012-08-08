//
//  TBLUtil.m
//  thebookoflulz
//
//  Created by Eric J Bell on 8/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TBLUtil.h"
#import "SearchResult.h"

@implementation TBLUtil

+(NSString *)photoImageUrl:(SearchResult *)searchResult
{
    //have to parse the photos object
    NSDictionary *photosObject = (NSDictionary *)[searchResult.photos objectAtIndex:0];
    NSArray *altSizesArray = (NSArray *)[photosObject objectForKey:@"alt_sizes"];
    NSDictionary *altSizesDict = (NSDictionary *)[altSizesArray objectAtIndex:1];
    NSString *imageUrl = (NSString *)[altSizesDict objectForKey:@"url"];
    return imageUrl;
}

+(NSString *)getFileExtension:(NSString *)urlString
{
    NSUInteger startIndex = urlString.length - 3;
    NSRange fileExtensionRange = {startIndex, 3};
    return [urlString substringWithRange:fileExtensionRange];
}


@end
