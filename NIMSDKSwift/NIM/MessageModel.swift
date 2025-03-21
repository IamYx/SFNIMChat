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
    var senderName = ""
    
    init(message: NIMMessage) {
        super.init()
        
        //base
        self.conversationId = message.session?.sessionId ?? ""
        self.messageSendStatus = message.deliveryState.rawValue
        self.messageId = message.messageId
        
        if (message.from == NIMSDKManager.shared.currentAccount) {
            isOutgoing = true
        } else {
            isOutgoing = false
        }
        senderName = message.senderName ?? message.from!
        
        //文本消息
        self.text = message.text ?? ""
        //话单消息
        if (message.messageType == .rtcCallRecord) {
            let rtcObject : NIMRtcCallRecordObject = message.messageObject as! NIMRtcCallRecordObject
            switch rtcObject.callStatus {
            case .busy:
                self.text = "【对方忙线】"
                break
            case .canceled:
                self.text = "【通话取消】"
                break
            case .complete:
                self.text = "【通话时长: \(rtcObject.durations)】"
                break
            case .rejected:
                self.text = "【通话拒绝】"
                break
            case .timeout:
                self.text = "【超时未接听】"
                break
            default:
                break
            }
            self.text = self.text + "\(rtcObject.callType == .audio ? "【语音】" : "【视频】")"
        }
        
        //自定义消息
        if (message.messageType == .custom) {
//            let customObject : NIMCustomObject = message.messageObject as! NIMCustomObject
            self.text = message.rawAttachContent ?? ""
        }
        //通知消息
        if (message.messageType == .notification) {
            self.text = message.rawAttachContent ?? ""
        }
        
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
        
        //图片消息
        if (message.messageType == .image) {
            self.messageType = 1
            let imgObject: NIMImageObject = message.messageObject as! NIMImageObject
            self.imageUrl = imgObject.thumbPath ?? imgObject.thumbUrl ?? ""
            let a = imgObject.size.height / imgObject.size.width
            self.messageSize = CGSize(width: 180, height: 180 * (a > 0 ? a : 1))
        }
        
    }
    
}
