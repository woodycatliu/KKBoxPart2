//
//  EpisodeInfo.m
//  KKBoxPart2
//
//  Created by Woody on 2022/6/23.
//

#import <Foundation/Foundation.h>
#import "EpisodeInfo.h"

#define EXCERPT(str, len) (([str length] > len) ? [[str substringToIndex:len-1] stringByAppendingString:@"…"] : str)

@implementation EpisodeInfo
@synthesize title, image, link, url, summary;


- (NSString *)description {
    NSMutableString *string = [[NSMutableString alloc] initWithString:@"EpisodeItem: "];
    if (title)   [string appendFormat:@"“%@”", EXCERPT(title, 50)];
    //if (link)    [string appendFormat:@" (%@)", link];
    //if (summary) [string appendFormat:@", %@", MWExcerpt(summary, 50)];
    return string;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    if (title) [encoder encodeObject:title forKey:@"title"];
    if (link) [encoder encodeObject:link forKey:@"link"];
    if (summary) [encoder encodeObject:title forKey:@"summary"];
    if (image) [encoder encodeObject:title forKey:@"image"];
    if (url) [encoder encodeObject:title forKey:@"url"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if ((self = [super init])) {
        title = [decoder decodeObjectForKey:@"title"];
        link = [decoder decodeObjectForKey:@"link"];
        summary = [decoder decodeObjectForKey:@"summary"];
        image = [decoder decodeObjectForKey:@"image"];
        url = [decoder decodeObjectForKey:@"url"];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    EpisodeInfo *copy = [[[self class] alloc] init];
    
    if (copy) {
        copy.title = title.copy;
        copy.url = url.copy;
        copy.image = image.copy;
        copy.link = link.copy;
        copy.summary = summary.copy;
    }
    return  copy;
}

@end
