//
//  CustomMessageAttachment.swift
//  NIMSDKSwift
//
//  Created by 姚肖 on 2023/4/23.
//

import UIKit
import NIMSDK

class CustomMessageAttachment: NSObject, NIMCustomAttachment, NIMCustomAttachmentCoding {
    func encode() -> String {
        return ""
    }
    
    
    func decodeAttachment(_ content: String?) -> NIMCustomAttachment? {
        return nil
    }

}
