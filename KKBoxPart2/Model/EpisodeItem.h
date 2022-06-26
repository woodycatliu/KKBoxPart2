//
//  EpisodeItem.h
//  KKBoxPart2
//
//  Created by Woody on 2022/6/23.
//

#import <Foundation/Foundation.h>


@interface EpisodeItem : NSObject <NSCoding, NSCopying> {
    NSString *title;
    NSDate *date;
    NSString *author;
    NSString *image;
    NSString *summary;
    NSString *mp3;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSDate *date;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *mp3;


@end
