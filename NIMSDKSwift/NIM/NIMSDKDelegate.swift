//
//  NIMSDKDelegate.swift
//  NIMSDKSwift
//
//  Created by 姚肖 on 2025/3/14.
//

import UIKit
import NIMSDK

class NIMSDKDelegate: NSObject, NIMConversationManagerDelegate, NIMChatManagerDelegate {
    
    var conversationAdd: ((_ con: ConversationModel) -> Void)?
    var conversationUpdate: ((_ con: ConversationModel) -> Void)?

    func didAdd(_ recentSession: NIMRecentSession, totalUnreadCount: Int) {
        if (conversationAdd != nil) {
            conversationAdd!(ConversationModel.init(recentSession: recentSession))
        }
    }
    
    func didUpdate(_ recentSession: NIMRecentSession, totalUnreadCount: Int) {
        if (conversationUpdate != nil) {
            conversationUpdate!(ConversationModel.init(recentSession: recentSession))
        }
    }
    
    var messageWillSend:((_ msg: MessageModel) -> Void)?
    var messageSendSuccess:((_ msg: MessageModel, _ error: NSError?) -> Void)?
    var recvMessages:((_ msgs: [MessageModel]) -> Void)?
    
    func willSend(_ message: NIMMessage) {
        if (messageWillSend != nil) {
            messageWillSend!(MessageModel(message: message))
        }
    }
    
    func send(_ message: NIMMessage, didCompleteWithError error: (any Error)?) {
        if (messageSendSuccess != nil) {
            messageSendSuccess!(MessageModel(message: message), error as NSError?)
        }
    }
    
    func onRecvMessages(_ messages: [NIMMessage]) {
        if (recvMessages != nil) {
            var arr: [MessageModel] = []
            for message in messages {
                arr.append(MessageModel(message: message))
            }
            recvMessages!(arr)
        }
    }
}
