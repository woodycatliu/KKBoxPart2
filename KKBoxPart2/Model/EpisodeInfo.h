//
//  Episode.h
//  KKBoxPart2
//
//  Created by Woody on 2022/6/22.
//

#import <Foundation/Foundation.h>


@interface EpisodeInfo : NSObject <NSCoding, NSCopying> {
    
    NSString *title; // Feed title
    NSString *link; // Feed link
    NSString *summary; // Feed summary / description
    NSURL *url; // Feed url
    
    // custom
    NSString *image;
    
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSURL *url;
@property (nonatomic, copy) NSString *image;

@end
