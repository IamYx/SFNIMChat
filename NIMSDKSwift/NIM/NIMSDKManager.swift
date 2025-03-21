import NIMSDK

final class NIMSDKManager {
    
    var myAvatar = ""
    var myName = ""
    var currentAccount = ""
    var currentVersion = ""
    var nimDelegate = NIMSDKDelegate()
    
    static let shared = NIMSDKManager()
    private init() {}
    
    func regist() {
        // 初始化 NIMSDK
        let options = NIMSDKOption()
        // 设置你的 AppKey，需要替换为你自己在云信平台申请的 AppKey
        options.appKey = "4727023efa991d31d61b3b32e819bd5b"
        NIMSDK.shared().register(with: options)
    }
    
    var conversationManager: NIMConversationManager {
        NIMSDK.shared().conversationManager
    }
    
    var userManager: NIMUserManager {
        NIMSDK.shared().userManager
    }
    
    var loginManager: NIMLoginManager {
        NIMSDK.shared().loginManager
    }
    
    func fetchAllRecentSessions() -> [ConversationModel] {
        
        var array : [ConversationModel] = []
        for recent in NIMSDK.shared().conversationManager.allRecentSessions()! {
            array.append(ConversationModel.init(recentSession: recent))
        }
        return array
    }
    
    func deleteRecentSession(_ session: NIMRecentSession, option: NIMDeleteRecentSessionOption) async throws {
        try await withCheckedThrowingContinuation { continuation in
            conversationManager.delete(session, option: option) { error in
                error != nil ? continuation.resume(throwing: error!) : continuation.resume()
            }
        }
    }
    
    // 修改登录方法，增加回调参数
    func login(account: String, token: String, completion: ((Result<Void, Error>) -> Void)? = nil) {
        loginManager.login(account, token: token) { error in
            let result: Result<Void, Error>
            if let error = error as? NSError {
                let processedError = self.processLoginError(error)
                result = .failure(processedError)
            } else {
                result = .success(())
                if let userInfo = NIMSDK.shared().userManager.userInfo(NIMSDK.shared().loginManager.currentAccount())?.userInfo {
                    self.myAvatar = userInfo.avatarUrl ?? ""
                    self.myName = userInfo.nickName ?? "当前用户"
                    self.currentVersion = NIMSDK.shared().sdkVersion()
                    self.currentAccount = NIMSDK.shared().loginManager.currentAccount()
                    
                    NIMSDK.shared().conversationManager.add(self.nimDelegate)
                    NIMSDK.shared().chatManager.add(self.nimDelegate)
                }
            }
            completion?(result)
        }
    }
    
    func logout(completion: ((Result<Void, Error>) -> Void)? = nil) {
        loginManager.logout { error in
            let result: Result<Void, Error>
            if let error = error as? NSError {
                let processedError = self.processLoginError(error)
                result = .failure(processedError)
            } else {
                result = .success(())
            }
            completion?(result)
        }
    }
    
    // 新增错误处理私有方法
    private func processLoginError(_ error: NSError) -> Error {
        switch error.code {
        case 302...303:
            return NSError(domain: "", code: 3000, userInfo: ["detail": "失败"])
        case 408:
            return NSError(domain: "", code: 4000, userInfo: ["detail": "失败"])
        default:
            return error
        }
    }
    
    
    //------message-----
    func getMessageList(coversatinId: String, type: Int) -> [MessageModel] {
        var list: [MessageModel] = []
        
        let messages = NIMSDK.shared().conversationManager.messages(in: NIMSession(coversatinId, type: type == 0 ? .P2P : .team), message: nil, limit: 100)!
        for message in messages {
            list.append(MessageModel(message: message))
        }
        
        return list
    }
    
    /* ----消息发送------ */
    //文本消息发送
    func sendTextMessage(text: String, sessionId: String, sessionType: Int, completion: ((Int) -> Void)? = nil) {
        let type = sessionType == 1 ? NIMSessionType.team : NIMSessionType.P2P
        let message = NIMMessage()
        message.text = text
        NIMSDK.shared().chatManager.send(message, to: NIMSession.init(sessionId, type: type)) { error in
            
        }
    }
    //图片消息发送
    func sendImageMessage(path: String, sessionId: String, sessionType: Int, completion: ((Int) -> Void)? = nil) {
        let type = sessionType == 1 ? NIMSessionType.team : NIMSessionType.P2P
        let message = NIMMessage()
        let messageObject = NIMImageObject(filepath: path)
        message.messageObject = messageObject
        NIMSDK.shared().chatManager.send(message, to: NIMSession.init(sessionId, type: type)) { error in
            
        }
    }
    
}
