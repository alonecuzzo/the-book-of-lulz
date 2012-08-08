//
//  TBLUtil.h
//  thebookoflulz
//
//  Created by Eric J Bell on 8/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SearchResult;

@interface TBLUtil : NSObject

+(NSString *)photoImageUrl:(SearchResult *)searchResult;
+(NSString *)getFileExtension:(NSString *)urlString;

@end
