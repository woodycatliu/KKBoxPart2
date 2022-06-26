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

@synthesize title, date, summary, author, image, mp3;


- (NSString *)description {
    NSMutableString *string = [[NSMutableString alloc] initWithString:@"EpisodeItem: "];
    if (title)   [string appendFormat:@"“%@”", EXCERPT(title, 50)];
    return string;
}


- (void)encodeWithCoder:(NSCoder *)encoder {
    if (title) [encoder encodeObject:title forKey:@"title"];
    if (mp3) [encoder encodeObject:mp3 forKey:@"mp3"];
    if (summary) [encoder encodeObject:title forKey:@"summary"];
    if (image) [encoder encodeObject:title forKey:@"image"];
    if (date) [encoder encodeObject:date forKey:@"date"];
    if (author) [encoder encodeObject:title forKey:@"author"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if ((self = [super init])) {
        title = [decoder decodeObjectForKey:@"title"];
        mp3 = [decoder decodeObjectForKey:@"mp3"];
        summary = [decoder decodeObjectForKey:@"summary"];
        image = [decoder decodeObjectForKey:@"image"];
        date = [decoder decodeObjectForKey:@"date"];
        author = [decoder decodeObjectForKey:@"author"];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    EpisodeItem *copy = [[[self class] alloc] init];
    
    if (copy) {
        copy.title = title.copy;
        copy.date = date.copy;
        copy.author = author.copy;
        copy.image = image.copy;
        copy.summary = summary.copy;
        copy.mp3 = mp3.copy;
    }
    return  copy;
}

@end
