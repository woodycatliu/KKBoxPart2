//
//  KKParser.h
//  KKBoxPart2
//
//  Created by Woody on 2022/6/23.
//

#import <Foundation/Foundation.h>
#import "MWFeedParser.h"
#import "EpisodeItem.h"
#import "EpisodeInfo.h"


#define KKErrorDomain @"KKFeedParser"
#define KKErrorCodeNotInitiated 1 /* KKParser not initialised correctly */
#define KKErrorItemOrInfoFoundNull 2 /* KKParser info or items null */


@class KKParser;

@protocol KKParserDelegate <NSObject>
@optional
- (void)feedParserDidStart:(KKParser *)parser;
- (void)feedParser:(KKParser *)parser didFailWithError:(NSError *)error;
- (void)feedParserDidFinish:(EpisodeInfo *)info items:(NSArray<EpisodeItem *> *)items;

@end

@interface KKParser : NSObject <MWFeedParserDelegate> {
    id <KKParserDelegate> __unsafe_unretained delegate;
    
//    @private
    MWFeedParser *parser;
    NSURL *url;
    NSArray<EpisodeItem *> *items;
    EpisodeInfo *info;
}
// Init MWFeedParser with a URL string
- (id)initWithFeedURL:(NSURL *)feedURL;

- (BOOL)parse;

@property (nonatomic, unsafe_unretained) id <KKParserDelegate> delegate;
@property (nonatomic, copy) NSArray<EpisodeItem *> *items;
@property (nonatomic, strong) EpisodeInfo *info;

#pragma mark private
@property (nonatomic, strong) MWFeedParser *parser;
@property (nonatomic, copy) NSURL *url;


@end
