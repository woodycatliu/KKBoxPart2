//
//  EpisodeItem.m
//  KKBoxPart2
//
//  Created by Woody on 2022/6/23.
//

#import <Foundation/Foundation.h>
#import "EpisodeItem.h"


#define EXCERPT(str, len) (([str length] > len) ? [[str substringToIndex:len-1] stringByAppendingString:@"…"] : str)

@implementation EpisodeItem

@synthesize title, date, summary, author, guid, image, link;


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
    if (date) [encoder encodeObject:link forKey:@"date"];
    if (author) [encoder encodeObject:title forKey:@"author"];
    if (guid) [encoder encodeObject:title forKey:@"guid"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if ((self = [super init])) {
        title = [decoder decodeObjectForKey:@"title"];
        link = [decoder decodeObjectForKey:@"link"];
        summary = [decoder decodeObjectForKey:@"summary"];
        image = [decoder decodeObjectForKey:@"image"];
        date = [decoder decodeObjectForKey:@"date"];
        author = [decoder decodeObjectForKey:@"author"];
        guid = [decoder decodeObjectForKey:@"guid"];
    }
    return self;
}

@end
