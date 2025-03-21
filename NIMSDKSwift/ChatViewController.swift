import UIKit

class ChatViewController: UIViewController {
    
    var model : ConversationModel
    var msgModels: [MessageModel] = []
    private var inputContainerBottomConstraint: NSLayoutConstraint!
    
    init(model: ConversationModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("=== ViewController deinit")
    }
    
    // MARK: - UI Components
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(TextMessageCellTableViewCell.self, forCellReuseIdentifier: "MessageCell")
        tv.register(ImageMessageCellTableViewCell.self, forCellReuseIdentifier: "ImgMessageCell")
        tv.separatorStyle = .none
        tv.allowsSelection = true
        tv.dataSource = self
        tv.delegate = self
        
        // 修正下拉刷新方向
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadMoreHistory), for: .valueChanged)
        tv.refreshControl = refreshControl
        
        // 调整表格内容显示方向
//        tv.estimatedRowHeight = 60
        tv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    private lazy var inputContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // 新增按钮堆栈视图
    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // 新增四个功能按钮
    private lazy var imageButton: UIButton = createSystemIconButton(systemName: "photo", action: #selector(selectImage))
    private lazy var voiceButton: UIButton = createSystemIconButton(systemName: "mic", action: #selector(sendVoice))
    private lazy var videoCallButton: UIButton = createSystemIconButton(systemName: "video", action: #selector(videoCall))
    private lazy var voiceCallButton: UIButton = createSystemIconButton(systemName: "phone", action: #selector(voiceCall))
    
    private lazy var messageField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "输入消息"
        tf.borderStyle = .roundedRect
        tf.delegate = self
        tf.returnKeyType = .send
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupKeyboardObservers()
        
        self.msgModels = NIMSDKManager.shared.getMessageList(coversatinId: model.conversationId, type: model.conversationType)
        self.tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.scrollToBottom()
        }
        
        NIMSDKManager.shared.nimDelegate.recvMessages = {
            [weak self] messags in
            for message in messags {
                if (message.conversationId != self?.model.conversationId) {
                    return
                } else {
                    self?.msgModels.append(message)
                }
            }
            self?.tableView.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self?.scrollToBottom()
            }
        }
        
        NIMSDKManager.shared.nimDelegate.messageWillSend = {[weak self] message in
            
            if (message.conversationId != self?.model.conversationId) {
                return
            } else {
                self?.msgModels.append(message)
                self?.tableView.reloadData()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self?.scrollToBottom()
                }
            }
            
        }
        
        NIMSDKManager.shared.nimDelegate.messageSendSuccess = {
            [weak self] message, error in
            
            if (message.conversationId != self?.model.conversationId) {
                return
            } else {
                if (error != nil) {
                    return
                }
                if let messagesArray = self?.msgModels {
                    for model in messagesArray {
                        if (message.messageId == model.messageId) {
                            model.messageSendStatus = message.messageSendStatus
                        }
                    }
                }
                self?.tableView.reloadData()
            }
            
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = self.model.name
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .plain,
            target: self.navigationController,
            action: #selector(UINavigationController.popViewController(animated:))
        )
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        inputContainerBottomConstraint = inputContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        
        // 添加表格视图
        view.addSubview(tableView)
        view.addSubview(inputContainer)
        
        // 输入容器布局
        // 在输入容器中添加按钮
        inputContainer.addSubview(buttonStack)
        inputContainer.addSubview(messageField)
        
        // 将按钮添加到堆栈
        buttonStack.addArrangedSubview(imageButton)
        buttonStack.addArrangedSubview(voiceButton)
        buttonStack.addArrangedSubview(voiceCallButton)
        buttonStack.addArrangedSubview(videoCallButton)
    
        NSLayoutConstraint.activate([
            // 表格视图约束
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: inputContainer.topAnchor),
            
            // 输入容器约束
            inputContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            inputContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            inputContainerBottomConstraint, // 使用已初始化的约束
            inputContainer.heightAnchor.constraint(equalToConstant: 100),

            // 按钮堆栈约束（修改部分）
            buttonStack.topAnchor.constraint(equalTo: inputContainer.topAnchor, constant: 8),
            buttonStack.leadingAnchor.constraint(equalTo: inputContainer.leadingAnchor, constant: 16),
            buttonStack.trailingAnchor.constraint(equalTo: inputContainer.trailingAnchor, constant: -16),
            buttonStack.heightAnchor.constraint(equalToConstant: 36),
            
            // 消息输入框约束（调整顶部约束）
            messageField.topAnchor.constraint(equalTo: buttonStack.bottomAnchor, constant: 8),
            messageField.leadingAnchor.constraint(equalTo: inputContainer.leadingAnchor, constant: 16),
            messageField.bottomAnchor.constraint(equalTo: inputContainer.bottomAnchor, constant: -8),
            messageField.trailingAnchor.constraint(equalTo: inputContainer.trailingAnchor, constant: -16)
        ])
    }
    
    // MARK: - Event Handlers (预留方法)
    @objc private func loadMoreHistory() {
        // 加载完成后滚动到顶部
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    @objc private func sendMessage() {
        // 预留发送消息逻辑
        if (messageField.text != nil) {
            NIMSDKManager.shared.sendTextMessage(text: messageField.text!, sessionId: model.conversationId, sessionType: model.conversationType)
        }
        messageField.text = nil
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), 
                                             name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                             name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // 添加 viewDidAppear 方法
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // 添加滚动到底部方法
    private func scrollToBottom() {
        let lastRow = tableView.numberOfRows(inSection: 0) - 1
        guard lastRow >= 0 else { return }
        tableView.scrollToRow(
            at: IndexPath(row: lastRow, section: 0),
            at: .bottom,
            animated: false
        )
    }
    
    // 修改键盘显示处理方法
    @objc private func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
              let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else { return }
        
        // 计算键盘高度（考虑安全区域）
        let keyboardHeight = keyboardFrame.height - view.safeAreaInsets.bottom
        inputContainerBottomConstraint.constant = -keyboardHeight
        
        // 添加弹性动画
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: curve), animations: {
            self.view.layoutIfNeeded()
            self.scrollToBottom()
        })
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
              let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else { return }
        
        inputContainerBottomConstraint.constant = 0
        
        // 同步键盘动画曲线
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: curve), animations: {
            self.view.layoutIfNeeded()
            
            self.scrollToBottom()
        })
    }
    
    // 添加滚动视图代理方法
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true) // 下拉时隐藏键盘
    }
    
    // 添加点击处理方法
    @objc private func handleTableViewTap() {
        view.endEditing(true)
    }
    
    // 新增按钮创建方法
    private func createSystemIconButton(systemName: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: systemName), for: .normal)
        button.tintColor = .systemBlue
        button.addTarget(self, action: action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    // MARK: - 新增按钮事件方法
    @objc private func selectImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }

    @objc private func sendVoice() {
        // 显示语音录制界面
        let alert = UIAlertController(title: "语音消息", message: "按住录制", preferredStyle: .actionSheet)
        present(alert, animated: true)
    }

    @objc private func videoCall() {
        let alert = UIAlertController(title: "视频通话", message: "即将发起视频通话", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }

    @objc private func voiceCall() {
        let alert = UIAlertController(title: "语音通话", message: "即将发起语音通话", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }

}

extension ChatViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = msgModels[indexPath.row]
        return (model.messageSize?.height ?? 56) + 32 + 20
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = self.msgModels[indexPath.row]
        print("=== \(message.messageType)")
        handleTableViewTap()
    }
    
}

// MARK: - TableView DataSource
extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return msgModels.count // 示例数据
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = msgModels[indexPath.row]
        var cell = MessageCellTableViewCell()
        if (model.messageType == 0) {
            cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! TextMessageCellTableViewCell
        } else if (model.messageType == 1) {
            cell = tableView.dequeueReusableCell(withIdentifier: "ImgMessageCell", for: indexPath) as! ImageMessageCellTableViewCell
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! TextMessageCellTableViewCell
        }
        cell.configure(model: model)
        return cell
    }
}

// MARK: - TextField Delegate
extension ChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessage()
        return true
    }
}

// 新增图片选择代理方法
extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let url = info[.imageURL] as? URL {
            // 处理选择的图片
            print("直接获取图片路径: \(url.path)")
            NIMSDKManager.shared.sendImageMessage(path: url.path, sessionId: model.conversationId, sessionType: model.conversationType)
        }
        dismiss(animated: true)
    }
}

extension ChatViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController?.viewControllers.count ?? 0 > 1
    }
}
