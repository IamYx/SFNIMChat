import UIKit
import SVProgressHUD

private let accountKey = "LastLoginAccount"
private let passwordKey = "LastLoginPassword"

class LoginViewController: UIViewController {
    
    // MARK: - UI Elements
    private let backgroundView: UIView = {
        let view = UIView()
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor(red: 0.96, green: 0.87, blue: 0.91, alpha: 1.0).cgColor,
                           UIColor(red: 0.79, green: 0.85, blue: 0.95, alpha: 1.0).cgColor]
        gradient.locations = [0, 1]
        gradient.frame = UIScreen.main.bounds
        view.layer.addSublayer(gradient)
        return view
    }()

    private let logoImageView: UILabel = {
        let label = UILabel()
        label.text = "yuan"
        label.font = UIFont(name: "Snell Roundhand", size: 48) ?? UIFont.boldSystemFont(ofSize: 48)
        label.textColor = .clear // 必须设为透明
        label.textAlignment = .center
        label.layer.shadowOpacity = 0 // 暂时关闭阴影
        
        // 渐变层
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(red: 0.98, green: 0.36, blue: 0.52, alpha: 1.0).cgColor,
            UIColor(red: 0.23, green: 0.78, blue: 0.88, alpha: 1.0).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        label.layer.addSublayer(gradient)
        
        // 文字形状遮罩
        let textLayer = CATextLayer()
        textLayer.string = label.text
        textLayer.font = label.font
        textLayer.fontSize = label.font.pointSize
        textLayer.alignmentMode = .center
        textLayer.contentsScale = UIScreen.main.scale // 关键：保证高分辨率显示
        gradient.mask = textLayer
        
        label.transform = CGAffineTransform(rotationAngle: -.pi/18)
        
        return label
    }()
    
    // 在 viewDidAppear 中启动动画
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logoImageView.addBreathAnimation()
    }
    private let usernameField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "用户账号"
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 8
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.systemTeal.withAlphaComponent(0.3).cgColor
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        tf.leftViewMode = .always
        // 添加左侧图标
        let iconView = UIImageView(image: UIImage(systemName: "person.crop.circle"))
        iconView.tintColor = .systemIndigo
        tf.leftView?.addSubview(iconView)
        iconView.frame = CGRect(x: 8, y: (50-24)/2, width: 24, height: 24) // 根据新高度计算垂直居中
        return tf
    }()
    
    private let passwordField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "登录密码"
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 8
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.systemTeal.withAlphaComponent(0.3).cgColor
        tf.isSecureTextEntry = true
        // 添加左侧图标
        let iconView = UIImageView(image: UIImage(systemName: "lock.fill"))
        iconView.tintColor = .systemIndigo
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        tf.leftView?.addSubview(iconView)
        tf.leftViewMode = .always
        iconView.frame = CGRect(x: 8, y: (50-24)/2, width: 24, height: 24) // 根据新高度计算垂直居中
        return tf
    }()
    
    private let loginButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("登录", for: .normal)
        btn.backgroundColor = .white
        btn.setTitleColor(.systemIndigo, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.layer.cornerRadius = 8
        btn.layer.shadowColor = UIColor.systemIndigo.cgColor
        btn.layer.shadowOffset = CGSize(width: 0, height: 4)
        btn.layer.shadowRadius = 8
        btn.layer.shadowOpacity = 0.2
        // 渐变色背景
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor(red: 0.51, green: 0.73, blue: 0.98, alpha: 1.0).cgColor,
                           UIColor(red: 0.29, green: 0.56, blue: 0.89, alpha: 1.0).cgColor]
        gradient.cornerRadius = 8
        btn.layer.insertSublayer(gradient, at: 0)
        return btn
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupInteractions()
        
        // 自动填充上次登录信息
        if let savedAccount = UserDefaults.standard.string(forKey: accountKey),
           let savedPassword = UserDefaults.standard.string(forKey: passwordKey) {
            usernameField.text = savedAccount
            passwordField.text = savedPassword
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 更新所有渐变层尺寸
        if let gradient = logoImageView.layer.sublayers?.first as? CAGradientLayer,
           let textMask = gradient.mask as? CATextLayer {
            gradient.frame = logoImageView.bounds
            textMask.frame = gradient.bounds
        }
        
        loginButton.layer.sublayers?.first?.frame = loginButton.bounds
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.addSubview(backgroundView)
        view.addSubview(logoImageView)
        view.addSubview(usernameField)
        view.addSubview(passwordField)
        view.addSubview(loginButton)
        
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
    }
    
    private func setupInteractions() {
        // 按钮点击动画
        loginButton.addTarget(self, action: #selector(animateButtonDown), for: .touchDown)
        loginButton.addTarget(self, action: #selector(animateButtonUp), for: .touchUpOutside)
        loginButton.addTarget(self, action: #selector(animateButtonUp), for: .touchUpInside)
    }
    
    @objc private func animateButtonDown() {
        UIView.animate(withDuration: 0.1) {
            self.loginButton.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
        }
    }
    
    @objc private func animateButtonUp() {
        UIView.animate(withDuration: 0.1) {
            self.loginButton.transform = .identity
        }
    }
    
    private func setupConstraints() {
        [logoImageView, usernameField, passwordField, loginButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            // Logo布局
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            logoImageView.widthAnchor.constraint(equalToConstant: 120),
            logoImageView.heightAnchor.constraint(equalToConstant: 120),
            
            // 输入框布局（增加高度至50）
            usernameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            usernameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            usernameField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 40), // 减少顶部间距
            usernameField.heightAnchor.constraint(equalToConstant: 50), // 新增高度约束
            
            passwordField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            passwordField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            passwordField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 25), // 增加间距
            passwordField.heightAnchor.constraint(equalToConstant: 50), // 新增高度约束
            
            // 登录按钮（保持原高度）
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 40),
            loginButton.heightAnchor.constraint(equalToConstant: 50) // 高度微调至50
        ])
    }
    
    @objc private func handleLogin() {
        guard let account = usernameField.text?.trimmingCharacters(in: .whitespaces), !account.isEmpty,
              let token = passwordField.text?.trimmingCharacters(in: .whitespaces), !token.isEmpty else {
            SVProgressHUD.showError(withStatus: "账号或密码不能为空")
            return
        }
        
        SVProgressHUD.show(withStatus: "登录中...")
        
        NIMSDKManager.shared.login(account: account, token: token) { result in
            switch result {
            case .success:
                SVProgressHUD.dismiss()
                UserDefaults.standard.set(account, forKey: accountKey)
                UserDefaults.standard.set(token, forKey: passwordKey)
                
                // 创建带导航控制器的 TabBar 控制器
                let tabBarController = UITabBarController()
                
                // 会话列表页
                let conversationNav = UINavigationController(rootViewController: ConversationListViewController())
                conversationNav.tabBarItem = UITabBarItem(
                    title: "消息",
                    image: UIImage(systemName: "message.fill"),
                    tag: 0
                )
                
                // 个人中心页
                let profileNav = UINavigationController(rootViewController: ProfileViewController())
                profileNav.tabBarItem = UITabBarItem(
                    title: "我的",
                    image: UIImage(systemName: "person.crop.circle.fill"),
                    tag: 1
                )
                
                tabBarController.viewControllers = [conversationNav, profileNav]
                
                // 切换根视图
                UIApplication.shared.windows.first?.rootViewController = tabBarController
            case .failure(let error):
                SVProgressHUD.showError(withStatus: "登录失败: \(error.localizedDescription)")
            }
        }
    }
    
    // 删除原有的 showAlert 方法
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
}
