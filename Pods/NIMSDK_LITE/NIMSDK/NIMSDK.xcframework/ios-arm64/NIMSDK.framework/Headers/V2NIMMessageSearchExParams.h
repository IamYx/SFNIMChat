//
//  V2NIMMessageSearchExParams.h
//  NIMSDK
//
//  Created by Netease.
//  Copyright © 2024 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 搜索关键字匹配条件
typedef NS_ENUM(NSInteger, V2NIMSearchKeywordMathType) {
    V2NIM_SEARCH_KEYWORD_MATH_TYPE_OR               = 0,  ///< 或
    V2NIM_SEARCH_KEYWORD_MATH_TYPE_AND              = 1,  ///< 与
};

/// 消息检索参数
@interface V2NIMMessageSearchExParams : NSObject

/// 搜索 “全部会话” 还是搜索 “指定的会话” conversationId 为空（nil），搜索全部会话；conversationId 不为空，搜索指定会话。
@property (nonatomic,strong,nullable) NSString *conversationId;

/// 最多支持 5 个。当消息发送者以及消息类型均未指定时，必须设置关键字列表；否则，关键字列表可以为空。nil 和count==0 都表示为空
@property (nonatomic,strong,nullable) NSArray<NSString *> *keywordList;
/// 指定关键字列表匹配类型。可设置为 “或” 关系搜索，或 “与” 关系搜索。取值分别为 V2NIM_SEARCH_KEYWORD_MATH_TYPE_OR 和 V2NIM_SEARCH_KEYWORD_MATH_TYPE_AND。默认为 “或” 关系搜索。
@property (nonatomic,assign) V2NIMSearchKeywordMathType keywordMatchType;
/// 指定 accountId 发送的消息。最多支持 5 个。超过返回参数错误， accountid默认只检查数量， 不检查是否重复。nil 和count==0 都表示没有指定人数
///
@property (nonatomic,strong,nullable) NSArray<NSString *> *senderAccountIds;
/// 根据消息类型检索消息，为nil或空列表， 则表示查询所有消息类型。关键字不为空时， 不支持检索通知类消息。非文本消息，只检索对应检索字段，如果检索字段为空则该消息不回被检索到
@property (nonatomic,strong,nullable) NSArray<NSNumber *> *messageTypes;

/// 搜索的起始时间点，默认为 0（从现在开始搜索）。UTC 时间戳，单位：毫秒。
@property (nonatomic,assign) int64_t searchStartTime;
/// 从起始时间点开始的过去时间范围。默认为 0（不限制时间范围）。24 x 60 x 60 x 1000 代表过去一天，单位：毫秒。
@property (nonatomic,assign) int64_t searchTimePeriod;

/// 搜索的数量。最大100
@property (nonatomic,assign) NSInteger limit;
/// 搜索的起始位置，第一次填写空字符串，续拉时填写上一次返回的 V2NIMMessageSearchResult 中的 nextPageToken。两次查询参数必须一致
@property (nonatomic,strong,nullable) NSString *pageToken;

@end

NS_ASSUME_NONNULL_END
