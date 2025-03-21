import UIKit
import SDWebImage

class ConversationListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // 在类顶部添加自定义单元格
    private class ConversationCell: UITableViewCell {
        let avatarView = UIImageView()
        let titleLabel = UILabel()
        let detailLabel = UILabel()
        let timeLabel = UILabel()
        let badgeLabel = UILabel() // 新增未读标签
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
            
            // 头像配置
            avatarView.contentMode = .scaleAspectFill
            avatarView.layer.cornerRadius = 20
            avatarView.clipsToBounds = true
            avatarView.translatesAutoresizingMaskIntoConstraints = false
            
            // 时间标签配置
            timeLabel.translatesAutoresizingMaskIntoConstraints = false
            timeLabel.font = UIFont.systemFont(ofSize: 12)
            timeLabel.textColor = .gray
            timeLabel.textAlignment = .right
            
            // 标题和详情标签配置
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            detailLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            detailLabel.font = UIFont.systemFont(ofSize: 14)
            detailLabel.textColor = .gray
            
            // 新增未读数标签配置
            badgeLabel.translatesAutoresizingMaskIntoConstraints = false
            badgeLabel.backgroundColor = .systemRed
            badgeLabel.textColor = .white
            badgeLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
            badgeLabel.textAlignment = .center
            badgeLabel.layer.cornerRadius = 9
            badgeLabel.clipsToBounds = true
            badgeLabel.isHidden = true
            
            // 添加视图到contentView
            contentView.addSubview(avatarView)
            contentView.addSubview(titleLabel)
            contentView.addSubview(detailLabel)
            contentView.addSubview(timeLabel)
            contentView.addSubview(badgeLabel)
            
            // 设置约束
            NSLayoutConstraint.activate([
                // 头像约束
                avatarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                avatarView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                avatarView.widthAnchor.constraint(equalToConstant: 40),
                avatarView.heightAnchor.constraint(equalToConstant: 40),
                
                // 时间标签约束
                timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                timeLabel.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
                
                // 标题标签约束
                titleLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 12),
                titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: timeLabel.leadingAnchor, constant: -8),
                titleLabel.topAnchor.constraint(equalTo: avatarView.topAnchor),
                
                // 详情标签约束
                detailLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
                detailLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
                detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
                
                // 未读数标签约束
                badgeLabel.trailingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 6),
                badgeLabel.topAnchor.constraint(equalTo: avatarView.topAnchor, constant: -6),
                badgeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 18),
                badgeLabel.heightAnchor.constraint(equalToConstant: 18)
            ])
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    // 修改表格注册和配置部分
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ConversationCell.self, forCellReuseIdentifier: "ConversationCell") // 修改注册的单元格类型
        tableView.rowHeight = 56 // 增加行高
        return tableView
    }()

    private var conversations: [ConversationModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    
        // 设置导航栏标题
        setupNav()
    
        // 添加 tableView
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
    
        // 注册会话管理的代理
        NIMSDKManager.shared.nimDelegate.conversationAdd = {[weak self] model in
            
            self?.conversations.insert(model, at: 0)
            self?.tableView.reloadData()
        }
        
        NIMSDKManager.shared.nimDelegate.conversationUpdate = {[weak self] model in
            for item in self!.conversations {
                if item.conversationId == model.conversationId {
                    item.content = model.content
                    item.time = model.time
                    item.unreadCount = model.unreadCount
                }
            }
            self?.tableView.reloadData()
        }
    
        // 获取最近会话列表
        loadConversations()
        
        // 添加带动画的编辑按钮
        let editButton = UIButton()
        editButton.setTitle("编辑", for: .normal)
        editButton.setTitleColor(.systemBlue, for: .normal)
        editButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        editButton.addTarget(self, action: #selector(toggleEditing), for: .touchUpInside)
        // 初始位置直接设置在正确位置但透明度为0
        editButton.frame = CGRect(x: view.bounds.width - 60 - 16, y: 0, width: 60, height: 44)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: editButton)
    }
    
    // MARK: - 编辑功能
    @objc private func toggleEditing(btn : UIButton) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        btn.setTitle(tableView.isEditing ? "完成":"编辑", for: .normal)
    }
    
    // 启用行编辑
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // 自定义编辑操作
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "删除") { [weak self] (_, _, completion) in
            self?.deleteConversation(at: indexPath)
            completion(true)
        }
        
        let topAction = UIContextualAction(style: .normal, title: "置顶") { [weak self] (_, _, completion) in
            self?.pinConversation(at: indexPath)
            completion(true)
        }
        topAction.backgroundColor = .systemBlue
        
        return UISwipeActionsConfiguration(actions: [deleteAction, topAction])
    }
    
    private func deleteConversation(at indexPath: IndexPath) {
//        let session = conversations[indexPath.row]
//        let option = NIMDeleteRecentSessionOption()
//        NIMSDK.shared().conversationManager.delete(session, option: option) {[weak self] error in
//            if (error == nil) {
//                self?.conversations.remove(at: indexPath.row)
//                self?.tableView.deleteRows(at: [indexPath], with: .automatic)
//            }
//        }
    }
    
    private func pinConversation(at indexPath: IndexPath) {
        let pinned = conversations.remove(at: indexPath.row)
        conversations.insert(pinned, at: 0)
        tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0))
    }
    
    func setupNav() {
        // 创建容器视图
        let containerView = UIView()
        
        // 添加头像视图
        let avatarView = UIImageView()
        avatarView.contentMode = .scaleAspectFill
        avatarView.layer.cornerRadius = 15  // 圆形头像
        avatarView.clipsToBounds = true
        avatarView.frame = CGRect(x: 0, y: 7, width: 30, height: 30)
        
        // 设置默认头像
        avatarView.image = UIImage(systemName: "person.crop.circle.fill")?.withTintColor(.systemIndigo, renderingMode: .alwaysOriginal)
        
        avatarView.sd_setImage(with: URL(string: NIMSDKManager.shared.myAvatar), placeholderImage: avatarView.image)
        
        // 添加用户昵称标签
        let userNameLabel = UILabel()
        userNameLabel.text = NIMSDKManager.shared.myName
        userNameLabel.font = UIFont.boldSystemFont(ofSize: 17)
        userNameLabel.sizeToFit()
        userNameLabel.frame.origin = CGPoint(x: 38, y: (44 - userNameLabel.frame.height)/2)
        
        // 设置容器视图尺寸
        containerView.frame = CGRect(x: 0, y: 0, width: userNameLabel.frame.width + 38, height: 44)
        
        // 添加子视图
        containerView.addSubview(avatarView)
        containerView.addSubview(userNameLabel)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: containerView)
    }

    private func loadConversations() {
        conversations = NIMSDKManager.shared.fetchAllRecentSessions()
        tableView.reloadData()
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    // 修改 cellForRowAt 方法
    // 在cellForRowAt方法中添加未读数配置
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell", for: indexPath) as! ConversationCell
        let conversation = conversations[indexPath.row]
        
        // 配置未读数
        let unreadCount = conversation.unreadCount
        cell.badgeLabel.isHidden = unreadCount <= 0
        cell.badgeLabel.text = unreadCount > 99 ? "99+" : "\(unreadCount)"
        
        // 配置会话信息
        if conversation.conversationType == 0 { // 单聊会话
            cell.avatarView.sd_setImage(with: URL(string: conversation.avatar),
                                      placeholderImage: UIImage(systemName: "person.crop.circle"))
        } else { // 群聊会话
            cell.avatarView.sd_setImage(with: URL(string: conversation.avatar),
                                      placeholderImage: UIImage(systemName: "person.2.circle"))
        }
        cell.titleLabel.text = conversation.name
        
        // 设置最新消息
        cell.detailLabel.text = conversation.content
        
        // 时间标签配置
        cell.timeLabel.text = conversation.time
        
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // 这里可以添加点击会话进入聊天页面的逻辑
        
        let chatVc = ChatViewController(model: self.conversations[indexPath.row])
        chatVc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(chatVc, animated: true)
        
    }

}
