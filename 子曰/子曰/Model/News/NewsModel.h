//
//  NewsModel.h
//  子曰
//
//  Created by Martell on 16/1/21.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NewsTModel,NewsAdsModel,NewsImgextraModel;
@interface NewsModel : NSObject
//
@property (nonatomic, strong) NSArray<NewsTModel *> *T1348647853363;

@end
@interface NewsTModel : NSObject

@property (nonatomic, copy) NSNumber *imgType;

@property (nonatomic, copy) NSString *tname;

@property (nonatomic, copy) NSString *ptime;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) NSArray<NewsImgextraModel *> *imgextra;

@property (nonatomic, copy) NSString *photosetID;

@property (nonatomic, copy) NSString *postid;

@property (nonatomic, assign) NSInteger hasHead;

@property (nonatomic, assign) NSInteger hasImg;

@property (nonatomic, copy) NSString *lmodify;

@property (nonatomic, copy) NSString *docid;

@property (nonatomic, copy) NSString *template;

@property (nonatomic, assign) NSInteger replyCount;

@property (nonatomic, assign) NSInteger votecount;

@property (nonatomic, copy) NSString *alias;

@property (nonatomic, assign) BOOL hasCover;

@property (nonatomic, assign) NSInteger priority;

@property (nonatomic, copy) NSString *skipType;

@property (nonatomic, copy) NSString *cid;

@property (nonatomic, assign) NSInteger hasAD;

@property (nonatomic, copy) NSString *imgsrc;

@property (nonatomic, assign) BOOL hasIcon;

@property (nonatomic, strong) NSArray<NewsAdsModel *> *ads;

@property (nonatomic, copy) NSString *ename;

@property (nonatomic, copy) NSString *skipID;

@property (nonatomic, copy) NSString *boardid;

@property (nonatomic, assign) NSInteger order;

@property (nonatomic, copy) NSString *digest;

@property (nonatomic, copy) NSString *source;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *url_3w;

@end

@interface NewsAdsModel : NSObject

@property (nonatomic, copy) NSString *docid;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic, copy) NSString *tag;

@property (nonatomic, copy) NSString *imgsrc;

@end

@interface NewsImgextraModel : NSObject

@property (nonatomic, copy) NSString *imgsrc;

@end

