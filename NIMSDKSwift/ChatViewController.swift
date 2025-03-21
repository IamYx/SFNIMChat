import UIKit

class ChatViewController: UIViewController {
    
    var model : ConversationModel
    var msgModels: [MessageModel] = []
    
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
        tv.allowsSelection = false
        tv.dataSource = self
        tv.delegate = self
        
        // 添加点击手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTableViewTap))
        tv.addGestureRecognizer(tapGesture)
        
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
    
    private lazy var messageField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "输入消息"
        tf.borderStyle = .roundedRect
        tf.delegate = self
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private lazy var sendButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("发送", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
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
    
    // MARK: - UI Setup
    // 添加约束引用
    private var inputContainerBottomConstraint: NSLayoutConstraint!
    
    private func setupUI() {
        view.backgroundColor = .white
        title = self.model.name
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .plain,
            target: self.navigationController,
            action: #selector(UINavigationController.popViewController(animated:))
        )
        
        // 添加表格视图
        view.addSubview(tableView)
        view.addSubview(inputContainer)
        
        // 输入容器布局
        inputContainer.addSubview(messageField)
        inputContainer.addSubview(sendButton)
        
        // 初始化底部约束
        inputContainerBottomConstraint = inputContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        
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
            inputContainer.heightAnchor.constraint(equalToConstant: 60),
            
            // 消息输入框约束
            messageField.leadingAnchor.constraint(equalTo: inputContainer.leadingAnchor, constant: 16),
            messageField.topAnchor.constraint(equalTo: inputContainer.topAnchor, constant: 8),
            messageField.bottomAnchor.constraint(equalTo: inputContainer.bottomAnchor, constant: -8),
            
            // 发送按钮约束
            sendButton.leadingAnchor.constraint(equalTo: messageField.trailingAnchor, constant: 8),
            sendButton.trailingAnchor.constraint(equalTo: inputContainer.trailingAnchor, constant: -16),
            sendButton.centerYAnchor.constraint(equalTo: messageField.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 60)
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
}

extension ChatViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = msgModels[indexPath.row]
        return (model.messageSize?.height ?? 56) + 32
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
