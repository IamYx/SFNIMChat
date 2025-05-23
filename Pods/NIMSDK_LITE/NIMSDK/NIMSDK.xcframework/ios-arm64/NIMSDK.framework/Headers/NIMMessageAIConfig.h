//
//  NIMMessageAIConfig.h
//  NIMLib
//
//  Created by 陈吉力 on 2024/9/24.
//  Copyright © 2024 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NIMAIModelConfigParams;
@class NIMAIModelCallContent;
@class NIMAIModelCallMessage;

/// 大模型角色类型
typedef NS_ENUM(NSInteger, NIMMessageAIStatus) {
    NIMMessageAIStatusUnknow                          = 0,  ///< 普通消息
    NIMMessageAIStatusAt                              = 1,  ///< 表示是一个艾特数字人的消息
    NIMMessageAIStatusResponse                        = 2,  ///< 表示是数字人响应艾特的消息
};

@interface NIMMessageAIConfig :  NSObject<NSCopying>
/// 数字人的 accountId
@property(nullable,nonatomic,strong,readwrite) NSString *accountId;

/// 该 AI 消息的询问和应答标识
/// 0 表示普通消息
/// 1 表示是一个艾特数字人的消息
/// 2 表示是数字人响应艾特的消息
/// 响应回参
@property(nonatomic,assign,readwrite) NIMMessageAIStatus aiStatus;

@end

@interface NIMMessageAIConfigParams : NSObject<NSCopying>
/// 数字人的 accountId
@property(nullable,nonatomic,strong,readwrite) NSString *accountId;

/// 请求大模型的内容
@property(nullable,nonatomic,strong,readwrite) NIMAIModelCallContent *content;
/// 上下文内容
/// 当前只支持文本消息
@property(nullable,nonatomic,strong,readwrite) NSArray<NIMAIModelCallMessage *> *messages;
/// 提示词变量占位符替换
/// JSON 格式的字符串
/// 用于填充prompt中的变量
@property(nullable,nonatomic,strong,readwrite) NSString *promptVariables;
/// 请求接口模型相关参数配置， 如果参数不为空，则默认覆盖控制相关配置
@property(nullable,nonatomic,strong,readwrite) NIMAIModelConfigParams *modelConfigParams;
@end
