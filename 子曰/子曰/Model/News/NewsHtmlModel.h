//
//  NewsHtmlModel.h
//  子曰
//
//  Created by Martell on 16/1/26.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NewsHtmlImgModel,NewsKeyword_SearchModel,NewsRelative_SysModel;
@interface NewsHtmlModel : NSObject

@property (nonatomic, copy) NSString *ptime;

@property (nonatomic, copy) NSString *source;

@property (nonatomic, copy) NSString *ec;

@property (nonatomic, strong) NSArray *link;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *tid;

@property (nonatomic, strong) NSArray *boboList;

@property (nonatomic, strong) NSArray *apps;

@property (nonatomic, strong) NSArray<NewsHtmlImgModel *> *img;

@property (nonatomic, strong) NSArray *topiclist_news;

@property (nonatomic, strong) NSArray *ydbaike;

@property (nonatomic, copy) NSString *docid;

@property (nonatomic, assign) BOOL picnews;

@property (nonatomic, assign) NSInteger replyCount;

@property (nonatomic, copy) NSString *source_url;

@property (nonatomic, copy) NSString *template;

@property (nonatomic, copy) NSString *replyBoard;

@property (nonatomic, assign) BOOL hasNext;

@property (nonatomic, strong) NSArray *topiclist;

@property (nonatomic, copy) NSString *body;

@property (nonatomic, strong) NSArray<NewsKeyword_SearchModel *> *keyword_search;

@property (nonatomic, strong) NSArray *votes;

@property (nonatomic, assign) NSInteger threadAgainst;

@property (nonatomic, copy) NSString *voicecomment;

@property (nonatomic, copy) NSString *dkeys;

@property (nonatomic, strong) NSArray *users;

@property (nonatomic, assign) NSInteger threadVote;

@property (nonatomic, strong) NSArray<NewsRelative_SysModel *> *relative_sys;

@property (nonatomic, copy) NSString *digest;

@end
@interface NewsHtmlImgModel : NSObject

@property (nonatomic, copy) NSString *alt;

@property (nonatomic, copy) NSString *pixel;

@property (nonatomic, copy) NSString *ref;

@property (nonatomic, copy) NSString *src;

@end

@interface NewsKeyword_SearchModel : NSObject

@property (nonatomic, copy) NSString *word;

@end

@interface NewsRelative_SysModel : NSObject

@property (nonatomic, copy) NSString *source;

@property (nonatomic, copy) NSString *imgsrc;

@property (nonatomic, copy) NSString *ptime;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *href;

@property (nonatomic, copy) NSString *type;

@end