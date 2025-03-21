import UIKit

class ProfileViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 隐藏导航栏
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 恢复导航栏显示
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        // 添加渐变背景
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.systemBlue.cgColor, UIColor.systemTeal.cgColor]
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 280)
        view.layer.addSublayer(gradientLayer)
        
        // 头像容器
        let avatarContainer = UIView(frame: CGRect(x: 0, y: 45, width: view.frame.width, height: 240))
        
        // 添加头像
        let avatarView = UIImageView()
        avatarView.contentMode = .scaleAspectFill
        avatarView.layer.cornerRadius = 45
        avatarView.layer.borderWidth = 3
        avatarView.layer.borderColor = UIColor.white.cgColor
        avatarView.clipsToBounds = true
        avatarView.frame = CGRect(x: (view.frame.width-90)/2, y: 45, width: 90, height: 90)
        
        // 用户信息获取
        avatarView.sd_setImage(with: URL(string: NIMSDKManager.shared.myAvatar),
                              placeholderImage: UIImage(systemName: "person.circle.fill"))
        
        // 添加昵称标签
        let nameLabel = UILabel()
        nameLabel.text = NIMSDKManager.shared.myName
        nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        nameLabel.textColor = .darkGray
        nameLabel.sizeToFit()
        nameLabel.center = CGPoint(x: view.center.x, y: avatarView.frame.maxY + 30)
        avatarContainer.addSubview(nameLabel)
        
        avatarContainer.addSubview(avatarView)
        view.addSubview(avatarContainer)
        
        let tableView = UITableView(frame: view.bounds)
        tableView.backgroundColor = .clear
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        tableView.tableHeaderView = UIView(frame: CGRect.init(x: 0, y: 0, width: view.bounds.width, height: 240))
        
        let logoutButton = UIButton(type: .system)
        logoutButton.backgroundColor = .systemRed
        logoutButton.layer.cornerRadius = 8
        logoutButton.setTitleColor(.white, for: .normal)
        logoutButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        logoutButton.setTitle("退出登录", for: .normal)
        logoutButton.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        logoutButton.frame = CGRect(x: 20, y: 40, width: view.frame.width - 40, height: 50)
        
        let footView = UIView(frame: CGRect.init(x: 0, y: 0, width: view.bounds.width, height: 100))
        footView.backgroundColor = .white
        footView.addSubview(logoutButton)
        tableView.tableFooterView = footView
    }
    
    @objc private func handleLogout() {
        // 退出登录逻辑
        NIMSDKManager.shared.logout { result in
            switch result {
            case .success:
                let loginVC = LoginViewController()
                UIView.transition(with: UIApplication.shared.windows.first!,
                                  duration: 0.3,
                                  options: .transitionCrossDissolve,
                                  animations: {
                    UIApplication.shared.windows.first?.rootViewController = loginVC
                })
            case .failure(_):
                break
            }
        }
    }
    
}
// 添加表格数据源扩展
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 1) {
            self.navigationController?.pushViewController(ViewController(), animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4 // 账号、性别、地区
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        
        let iconConfig = UIImage.SymbolConfiguration(weight: .medium)
        switch indexPath.row {
        case 0:
            cell.imageView?.image = UIImage(systemName: "person.fill", withConfiguration: iconConfig)
            cell.textLabel?.text = "账号：\(NIMSDKManager.shared.currentAccount)"
        case 1:
            cell.imageView?.image = UIImage(systemName: "person.2.circle", withConfiguration: iconConfig)
            cell.textLabel?.text = "性别"
        case 2:
            cell.imageView?.image = UIImage(systemName: "map.fill", withConfiguration: iconConfig)
            cell.textLabel?.text = "地区"
        case 3:
            cell.imageView?.image = UIImage(systemName: "tag.fill", withConfiguration: iconConfig)?
                .withTintColor(.systemGray, renderingMode: .alwaysOriginal)
            cell.textLabel?.text = "版本号"
            // 获取应用版本号
            let version = NIMSDKManager.shared.currentVersion
            cell.textLabel?.text = "v\(version)"
            cell.textLabel?.textColor = .systemGray
            cell.accessoryType = .none // 移除右侧箭头
            cell.selectionStyle = .none // 禁止选中
        default:
            break
        }
        return cell
    }
}
