//
//  NIMSDK.h
//  NIMSDK
//
//  Created by Netease.
//  Copyright © 2017年 Netease. All rights reserved.
//

/**
 *  平台相关定义
 */
#import "NIMPlatform.h"

/**
 *  全局枚举和结构体定义
 */
#import "NIMGlobalDefs.h"

/**
 *  配置项
 */
#import "NIMSDKOption.h"
#import "NIMSDKConfig.h"

/**
 *  会话相关定义
 */
#import "NIMSession.h"
#import "NIMRecentSession.h"
#import "NIMMessageSearchOption.h"
#import "NIMIncompleteSessionInfo.h"
#import "NIMMessagesInSessionOption.h"


/**
 *  用户定义
 */
#import "NIMUser.h"
#import "NIMUserSearchOption.h"

/**
 *  群相关定义
 */
#import "NIMTeamDefs.h"
#import "NIMTeam.h"
#import "NIMTeamMember.h"
#import "NIMCreateTeamOption.h"
#import "NIMCreateTeamExOption.h"
#import "NIMTeamManagerDelegate.h"
#import "NIMTeamFetchMemberOption.h"
#import "NIMTeamSearchOption.h"
#import "NIMTeamMemberSearchOption.h"
#import "NIMTeamMemberSearchResult.h"

/**
 *  聊天室相关定义
 */
#import "NIMChatroom.h"
#import "NIMChatroomEnterRequest.h"
#import "NIMMessageChatroomExtension.h"
#import "NIMChatroomMember.h"
#import "NIMChatroomMemberRequest.h"
#import "NIMChatroomTagRequest.h"
#import "NIMChatroomUpdateRequest.h"
#import "NIMChatroomQueueRequest.h"
#import "NIMChatroomBeKickedResult.h"
#import "NIMChatroomCdnTrackInfo.h"
#import "NIMGetMessagesByTagsParam.h"
#import "NIMChatroomTagsUpdateEvent.h"

/**
 *  消息定义
 */
#import "NIMMessage.h"
#import "NIMAddEmptyRecentSessionBySessionOption.h"
#import "NIMSystemNotification.h"
#import "NIMRevokeMessageNotification.h"
#import "NIMDeleteMessagesOption.h"
#import "NIMDeleteMessageOption.h"
#import "NIMBroadcastMessage.h"
#import "NIMImportedRecentSession.h"
#import "NIMClearMessagesOption.h"
#import "NIMDeleteRecentSessionOption.h"
#import "NIMBatchDeleteMessagesOption.h"
#import "NIMRevokeMessageOption.h"
#import "NIMSessionDeleteAllRemoteMessagesOptions.h"
#import "NIMSessionDeleteAllRemoteMessagesInfo.h"
#import "NIMMessageRobotInfo.h"
#import "NIMMessageAIConfig.h"

/**
 *  推送定义
 */
#import "NIMPushNotificationSetting.h"

/**
 *  登录定义
 */
#import "NIMLoginClient.h"
#import "NIMLoginKickoutResult.h"

/**
 *  文档转码信息
 */
#import "NIMDocTranscodingInfo.h"

/**
 *  事件订阅
 */
#import "NIMSubscribeEvent.h"
#import "NIMSubscribeRequest.h"
#import "NIMSubscribeOnlineInfo.h"
#import "NIMSubscribeResult.h"

/**
 *  智能机器人
 */
#import "NIMRobot.h"

/**
 *  缓存管理
 */
#import "NIMCacheQuery.h"

/**
 *  通用音视频信令
 */
#import "NIMSignalingMemberInfo.h"
#import "NIMSignalingRequest.h"
#import "NIMSignalingResponse.h"


/**
 *  各个对外接口协议定义
 */
#import "NIMLoginManagerProtocol.h"
#import "NIMChatManagerProtocol.h"
#import "NIMConversationManagerProtocol.h"
#import "NIMMediaManagerProtocol.h"
#import "NIMUserManagerProtocol.h"
#import "NIMTeamManagerProtocol.h"
#import "NIMSuperTeamManagerProtocol.h"
#import "NIMSystemNotificationManagerProtocol.h"
#import "NIMApnsManagerProtocol.h"
#import "NIMResourceManagerProtocol.h"
#import "NIMChatroomManagerProtocol.h"
#import "NIMDocTranscodingManagerProtocol.h"
#import "NIMEventSubscribeManagerProtocol.h"
#import "NIMRobotManagerProtocol.h"
#import "NIMRedPacketManagerProtocol.h"
#import "NIMBroadcastManagerProtocol.h"
#import "NIMAntispamManagerProtocol.h"
#import "NIMSignalManagerProtocol.h"
#import "NIMPassThroughManagerProtocol.h"
#import "NIMChatExtendManagerProtocol.h"
#import "NIMIndexManagerProtocol.h"
#import "NIMQChatManagerProtocol.h"
#import "NIMQChatApnsManagerProtocol.h"
#import "NIMQChatServerManagerProtocol.h"
#import "NIMQChatChannelManagerProtocol.h"
#import "NIMQChatRoleManagerProtocol.h"
#import "NIMQChatMessageManagerProtocol.h"
#import "NIMQChatMessageExtendManagerProtocol.h"
#import "NIMQChatRTCChannelManagerProtocol.h"
#import "NIMCustomizedAPIManagerProtocol.h"
#import "NIMSystemStateProtocol.h"
#import "NIMAIManagerProtocol.h"

/**
 *  SDK业务类
 */
#import "NIMServerSetting.h"
#import "NIMSDKHeader.h"

/**
 * 数据库
 */
#import "NIMDatabaseException.h"

/**
 *  资源
 */
#import "NIMResourceExtraInfo.h"

/**
 *  透传代理定义
 */
#import "NIMPassThroughOption.h"


/**
 *  Thread Talk & 快捷回复
 */
#import "NIMThreadTalkFetchOption.h"
#import "NIMChatExtendBasicInfo.h"
#import "NIMQuickComment.h"
#import "NIMThreadTalkFetchResult.h"

/**
 * 收藏
 */
#import "NIMCollectInfo.h"
#import "NIMCollectQueryOptions.h"
#import "NIMAddCollectParams.h"

/**
 * 置顶会话
 */
#import "NIMStickTopSessionInfo.h"
#import "NIMAddStickTopSessionParams.h"
#import "NIMSyncStickTopSessionResponse.h"
#import "NIMLoadRecentSessionsOptions.h"

/**
 * PIN
 */
#import "NIMMessagePinItem.h"
#import "NIMSyncMessagePinRequest.h"
#import "NIMSyncMessagePinResponse.h"

/**
 * 圈组
 */
#import "NIMQChatConfig.h"
#import "NIMQChatOption.h"
#import "NIMQChatAPIDefs.h"

/**
* 日志
*/
# import "NIMLogDesensitizationConfig.h"

#import "NIMCustomSystemNotificationSetting.h"
#import "NIMUnsupportedNotificationContent.h"
#import "NIMCustomObject.h"
#import "NIMMessageApnsMemberOption.h"
#import "NIMChatroomNotificationContent.h"
#import "NIMSuperTeamNotificationContent.h"
#import "NIMNotificationContent.h"
#import "NIMTipObject.h"
#import "NIMLocationObject.h"
#import "NIMTeamMessageReceipt.h"
#import "NIMRobotObject.h"
#import "NIMEncryptionConfig.h"
#import "NIMRedPacketRequest.h"
#import "NIMAudioObject.h"
#import "NIMVideoObject.h"
#import "NIMAntiSpamOption.h"
#import "NIMImageObject.h"
#import "NIMTeamNotificationContent.h"
#import "NIMNetCallNotificationContent.h"
#import "NIMMessageReceipt.h"
#import "NIMTeamMessageReceiptDetail.h"
#import "NIMMessageObjectProtocol.h"
#import "NIMRtcCallRecordObject.h"
#import "NIMAsymEncryptionOption.h"
#import "NIMNotificationObject.h"
#import "NIMGenericTypeAPIDefine.h"
#import "NIMFileObject.h"
#import "NIMMessageSetting.h"
