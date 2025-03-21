//
//  ConversationModel.swift
//  NIMSDKSwift
//
//  Created by 姚肖 on 2025/3/14.
//

import UIKit
import NIMSDK

class ConversationModel: NSObject {
    
    var avatar = ""
    var name = ""
    var content = ""
    var time = ""
    var unreadCount = 0
    var conversationType = 0 //0单聊 1群聊
    var conversationId = ""
    
    init(recentSession : NIMRecentSession) {
        super.init()
        conversationType = recentSession.session?.sessionType.rawValue ?? 0
        if (conversationType == 0) {
            let user = NIMSDK.shared().userManager.userInfo(recentSession.session!.sessionId)?.userInfo
            avatar = user?.avatarUrl ?? ""
            name = user?.nickName ?? recentSession.session?.sessionId ?? ""
        } else if (conversationType == 1) {
            let team = NIMSDK.shared().teamManager.team(byId2: recentSession.session!.sessionId)
            avatar = team?.avatarUrl ?? ""
            name = team?.teamName ?? ""
        }
        content = messageDescription(for: recentSession.lastMessage!)
        if let timestamp = recentSession.lastMessage?.timestamp {
            time = formatMessageTime(timestamp)
        }
        unreadCount = recentSession.unreadCount
        conversationId = recentSession.session?.sessionId ?? ""
    }
    
    private func messageDescription(for message: NIMMessage) -> String {
        var prefix = ""
        if message.deliveryState == .failed {
            prefix = "发送失败，请重试 "
        }
        
        switch message.messageType {
        case .text:
            return prefix + (message.text ?? "[文本消息]")
        case .image:
            return prefix + "[图片]"
        case .video:
            return prefix + "[视频]"
        case .audio:
            return prefix + (message.isPlayed ? "[语音]" : "[未读语音]")
        case .location:
            return prefix + "[位置]"
        case .notification:
            return prefix + "[系统通知]"
        case .file:
            return prefix + "[文件]"
        case .tip:
            return prefix + "[提示消息]"
        case .custom:
            return prefix + "[自定义消息]"
        case .rtcCallRecord:
            return prefix + "[音视频通话]"
        default:
            return prefix + "[未知消息]"
        }
    }
    
    private func formatMessageTime(_ timeInterval: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeInterval)
        let formatter = DateFormatter()
        if Calendar.current.isDateInToday(date) {
            formatter.dateFormat = "HH:mm"
        } else {
            formatter.dateFormat = "MM/dd"
        }
        return formatter.string(from: date)
    }
    
}
