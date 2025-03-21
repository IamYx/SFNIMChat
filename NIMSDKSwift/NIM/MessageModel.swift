//
//  MessageModel.swift
//  NIMSDKSwift
//
//  Created by 姚肖 on 2025/3/14.
//

import UIKit
import NIMSDK

class MessageModel: NSObject {

    var text = ""
    var isOutgoing = false
    var messageSize: CGSize?
    var imageUrl = ""
    var messageType = 0
    var conversationId = ""
    var messageId = ""
    var messageSendStatus = 0
    
    init(message: NIMMessage) {
        super.init()
        self.conversationId = message.session?.sessionId ?? ""
        self.messageSendStatus = message.deliveryState.rawValue
        self.text = message.text ?? ""
        self.messageId = message.messageId
        
        let maxBubbleWidth: CGFloat = 200 - 24 
        let font = UIFont.systemFont(ofSize: 16)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: maxBubbleWidth, height: 0))
        label.font = font
        label.numberOfLines = 0
        label.text = self.text
        label.sizeToFit()
        let size = label.bounds.size
        
        self.messageSize = CGSize(
            width: min(size.width, maxBubbleWidth),
            height: max(size.height, 20) // 20 是单行文本最小高度
        )
        
        if (message.from == NIMSDKManager.shared.currentAccount) {
            isOutgoing = true
        } else {
            isOutgoing = false
        }
        
        if (message.messageType == .image) {
            self.messageType = 1
            let imgObject: NIMImageObject = message.messageObject as! NIMImageObject
            self.imageUrl = imgObject.thumbUrl ?? ""
            let a = imgObject.size.height / imgObject.size.width
            self.messageSize = CGSize(width: 180, height: 180 * (a > 0 ? a : 1))
        }
    }
    
}
