//
//  KKParser.m
//  KKBoxPart2
//
//  Created by Woody on 2022/6/23.
//

#import <Foundation/Foundation.h>
#import "KKParser.h"
#import "MWFeedParser.h"


@implementation KKParser
@synthesize parser, delegate, items, info, url;

-(id)init {
    if ((self = [super init])) {}
    return self;
}

- (id)initWithFeedURL:(NSURL *)feedURL {
    if ((self = [self init])) {
        url = feedURL;
        
    }
    return self;
}

- (BOOL)parse {
    MWFeedParser *parser = [[MWFeedParser alloc] initWithFeedURL:url];
    self.parser = parser;
    if (!parser) {
        NSError *error = [NSError errorWithDomain:KKErrorDomain code:KKErrorCodeNotInitiated userInfo:NULL];
        [delegate feedParser:self didFailWithError: error];
        return NO;
    }
    parser.delegate = self;
    BOOL success = [parser parse];
    return success;
}

- (void) feedParserDidStart:(MWFeedParser *)parser {
    [delegate feedParserDidStart:self];
}

- (void) feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error {
    [delegate feedParser:self didFailWithError:error];
}

- (void) feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info {

    if (!self.info) {
        EpisodeInfo *inf = [[EpisodeInfo alloc] init];
        self.info = inf;
        self.info.url = info.url;
        self.info.title = info.title;
        self.info.image = info.image;
        self.info.link = info.link;
        self.info.summary = info.summary;
    }
}

- (void) feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
    EpisodeItem *ei = [[EpisodeItem alloc] init];
    
    if (item) {
        ei.title = item.title;
        ei.date = item.date;
        ei.summary = item.summary;
        ei.image = item.image;
        ei.author = item.author;
        if (item.enclosures && item.enclosures.count != 0 && [item.enclosures[0] objectForKey:@"url"]) {
            ei.mp3 = [item.enclosures[0] objectForKey:@"url"];
        }
        if (self.items) {
            self.items = [self.items arrayByAddingObject:ei];
        }
        else {
            self.items = [NSArray arrayWithObject:ei];
        }
    }

}

- (void) feedParserDidFinish:(MWFeedParser *)parser {
    if (info && items) {
        [delegate feedParserDidFinish:info items:items];
    } else {
        NSError *error = [NSError errorWithDomain:KKErrorDomain code:KKErrorItemOrInfoFoundNull userInfo:NULL];
        [delegate feedParser:self didFailWithError:error];
    }
    
}

@end
