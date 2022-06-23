//
//  Episode.h
//  KKBoxPart2
//
//  Created by Woody on 2022/6/22.
//

#import <Foundation/Foundation.h>

//@interface Music : NSObject <NSCoding>
//
//@property (nonatomic, copy) NSString *link;
//@property (nonatomic, copy) NSString *type;
//@property (nonatomic, copy) NSNumber * length;
//@property (nonatomic, copy) NSNumber * duration;
//
//@end


@interface EpospdeInfo : NSObject <NSCoding>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *pubDate;
@property (nonatomic, copy) NSString *guid;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *thumbnail;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *content;


@end



