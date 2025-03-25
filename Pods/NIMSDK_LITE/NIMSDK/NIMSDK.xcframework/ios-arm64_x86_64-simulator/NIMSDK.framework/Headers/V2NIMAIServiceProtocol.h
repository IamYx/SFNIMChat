//
//  V2NIMAIServiceProtocol.h
//  NIMLib
//
//  Created by Netease on 2024/5/20.
//  Copyright © 2024 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "V2NIMUserServiceProtocol.h"
#import "V2NIMBase.h"

NS_ASSUME_NONNULL_BEGIN

@class V2NIMProxyAIModelCallParams;
@class V2NIMAIModelCallContent;
@class V2NIMAIUser;
@class V2NIMProxyAICallAntispamConfig;
@class V2NIMAIModelCallResult;

@protocol V2NIMAIListener;

typedef void (^V2NIMGetAlUserListSuccess)(NSArray <V2NIMAIUser *> * _Nullable result);

/// 大模型类型
typedef NS_ENUM(NSInteger, V2NIMAIModelType) {
    V2NIM_AI_MODEL_TYPE_UNKNOW, // 未知
    V2NIM_AI_MODEL_TYPE_QWEN,   // 通义千问大模型
    V2NIM_AI_MODEL_TYPE_AZURE,  // 微软Azure
    V2NIM_AI_MODEL_TYPE_PRIVATE // 私有本地大模型
};


/// 大模型请求内容类型
typedef NS_ENUM(NSInteger, V2NIMAIModelCallContentType) {
    V2NIM_AI_MODEL_CONTENT_TYPE_TEXT = 0 // 暂时只有0，代表文本，预留扩展能力
};

/// 大模型角色内容
typedef NS_ENUM(NSInteger, V2NIMAIModelRoleType) {
    V2NIM_AI_MODEL_ROLE_TYPE_SYSTEM,
    V2NIM_AI_MODEL_ROLE_TYPE_USER,
    V2NIM_AI_MODEL_ROLE_TYPE_ASSISTANT
};

@protocol V2NIMAIService <NSObject>

/**
 *  数字人拉取接口
 *  返回全量的本Appkey相关的数字人用户
 *
 *  @param success  请求成功回调
 *  @param failure  请求失败回调
 */
- (void)getAIUserList:(nullable V2NIMGetAlUserListSuccess)success
              failure:(nullable V2NIMFailureCallback)failure;


/**
 *  Al数字人请求代理接口
 *
 *  @param params   接口入参
 *  @param success  请求成功回调
 *  @param failure  请求失败回调
 */

- (void)proxyAIModelCall:(V2NIMProxyAIModelCallParams *)params
                 success:(nullable V2NIMSuccessCallback)success
                 failure:(nullable V2NIMFailureCallback)failure;



/**
* 添加数字人监听器
*
* @param listener 消息监听回调
*/
- (void)addAIListener:(id<V2NIMAIListener>)listener;

/**
* 删除数字人监听器
*
* @param listener 消息监听回调
*/
- (void)removeAIListener:(id<V2NIMAIListener>)listener;

@end

// Al数字人监听
@protocol V2NIMAIListener <NSObject>

/**
 *  AI透传接口的响应的回调
 *  接口调用完毕后, 接下来服务器响应以通知的形式下发, 端测需要触发回调提供.
 *  @param data  响应内容
 */
- (void)onProxyAIModelCall:(V2NIMAIModelCallResult *)data;

@end


@interface V2NIMAIModelCallContent : NSObject<NSCopying>

/// 请求/响应的文本内容
@property(nonatomic,copy) NSString *msg;

/// 类型,暂时只有0，代表文本，预留扩展能力
@property(nonatomic,assign) V2NIMAIModelCallContentType type;

@end

/// 请求调用上下文内容
@interface V2NIMAIModelCallMessage : NSObject

/// 上下文内容的角色
@property(nonatomic,assign) V2NIMAIModelRoleType role;

/// 上下文内容的内容
@property(nonatomic,copy) NSString *msg;

/// 类型
@property(nonatomic,assign) V2NIMAIModelCallContentType type;

@end

/**
 *  Ai 大模型配置覆盖， 配置了该字段， 则默认覆盖控制台相关配置
 *  如果所有字段均为空，则以控制台配置为准， 本地不做格式校验
 *  如果设置参数超过范围， 则会主动纠正到正确范围
 */
@interface V2NIMAIModelConfigParams : NSObject<NSCopying>

/// 提示词
@property(nullable,nonatomic,copy) NSString *prompt;

/// 模型最大tokens数量
@property(nonatomic,assign) NSInteger maxTokens;

/**
 *  取值范围（0，1），生成时，核采样方法的概率阈值。
 *  例如，取值为0.8时，仅保留累计概率之和大于等于0.8的概率分布中的token，作为随机采样的候选集。取值范围为（0,1.0)，取值越大，生成的随机性越高；取值越低，生成的随机性越低。
 *  默认值 0.5。注意，取值不要大于等于1
 */

@property(nonatomic,assign) CGFloat topP;

/**
 *  取值范围(0,2)，用于控制随机性和多样性的程度。
 *  具体来说，temperature值控制了生成文本时对每个候选词的概率分布进行平滑的程度。较高的temperature值会降低概率分布的峰值，使得更多的低概率词被选择，生成结果更加多样化；而较低的temperature值则会增强概率分布的峰值，使得高概率词更容易被选择，生成结果更加确定。
 */
@property(nonatomic,assign) CGFloat temperature;

@end

@interface V2NIMProxyAIModelCallParams : NSObject

/// 机器人账号ID
@property(nonatomic,copy) NSString *accountId;

/// 请求id
@property(nonatomic,copy) NSString *requestId;

/// 请求大模型的内容
@property(nonatomic,strong) V2NIMAIModelCallContent *content;

/// 上下文内容
@property(nullable,nonatomic,strong) NSArray<V2NIMAIModelCallMessage *> *messages;

/// 提示词变量占位符替换
/// JSON 格式的字符串
/// 用于填充prompt中的变量
@property(nullable,nonatomic,copy) NSString *promptVariables;

/// 请求接口模型相关参数配置， 如果参数不为空，则默认覆盖控制相关配置
@property(nullable,nonatomic,strong) V2NIMAIModelConfigParams *modelConfigParams;

/// AI 透传接口的反垃圾配置
@property(nullable,nonatomic,strong) V2NIMProxyAICallAntispamConfig *antispamConfig;
@end

@interface V2NIMAIModelConfig : NSObject

/// 具体大模型版本模型名
@property(nonatomic,copy) NSString *model;

/// 提示词
@property(nonatomic,copy) NSString *prompt;

/// 提示词对应的变量
@property(nullable,nonatomic,strong) NSArray *promptKeys;

/// 模型最大tokens数量
@property(nonatomic,assign) NSInteger maxTokens;

/**
 *  取值范围（0，1），生成时，核采样方法的概率阈值。
 *  例如，取值为0.8时，仅保留累计概率之和大于等于0.8的概率分布中的token，作为随机采样的候选集。取值范围为（0,1.0)，取值越大，生成的随机性越高；取值越低，生成的随机性越低。
 *  默认值 0.5。注意，取值不要大于等于1
 */

@property(nonatomic,assign) CGFloat topP;

/**
 *  取值范围(0,2)，用于控制随机性和多样性的程度。
 *  具体来说，temperature值控制了生成文本时对每个候选词的概率分布进行平滑的程度。较高的temperature值会降低概率分布的峰值，使得更多的低概率词被选择，生成结果更加多样化；而较低的temperature值则会增强概率分布的峰值，使得高概率词更容易被选择，生成结果更加确定。
 */
@property(nonatomic,assign) CGFloat temperature;

@end

@interface V2NIMAIUser : V2NIMUser

/// 大模型类型
@property(nonatomic,assign) V2NIMAIModelType modelType;

/// 模型相关配置信息
@property(nullable,nonatomic) V2NIMAIModelConfig *modelConfig;

@end


@interface V2NIMProxyAICallAntispamConfig : NSObject
/// 指定消息是否需要经过安全通。默认为 true
/// 对于已开通安全通的用户有效，默认消息都会走安全通，如果对单条消息设置 enable 为 false，则此消息不会走安全通
@property(nonatomic,assign) BOOL antispamEnabled;

/// 指定易盾业务id
@property(nullable,nonatomic,copy) NSString *antispamBusinessId;
@end

@interface V2NIMAIModelCallResult : NSObject

/// 数字人的accountId
@property(nonatomic,copy) NSString *accountId;

/// 本次响应的标识
@property(nonatomic,copy) NSString *requestId;

/// 请求AI的回复
@property(nonatomic,strong) V2NIMAIModelCallContent *content;

/// AI响应的状态码
@property(nonatomic,assign) NSInteger code;

@end

NS_ASSUME_NONNULL_END
