import UIKit
class VoiceMessageCellTableViewCell: MessageCellTableViewCell {
    // MARK: - UI Components
    private var playButton: UIButton!
    private var waveformView: UIView!
    private var durationLabel: UILabel!
    private var cmodel: MessageModel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupVoiceUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupVoiceUI() {
        // 播放按钮
        playButton = UIButton(type: .system)
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        playButton.tintColor = .white
        
        // 波形图
        waveformView = UIView()
        waveformView.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        waveformView.layer.cornerRadius = 2
        
        // 时长标签
        durationLabel = UILabel()
        durationLabel.font = UIFont.systemFont(ofSize: 14)
        durationLabel.textColor = .white
        
        // 添加到左右气泡视图
        bubbleViewL.addSubview(playButton)
        bubbleViewL.addSubview(waveformView)
        bubbleViewL.addSubview(durationLabel)
    }
    
    override func configure(model: MessageModel) {
        super.configure(model: model)
        
        durationLabel.text = "\(String(format: "%.2f", model.voiceDuration))″"
        cmodel = model
        updateVoiceLayout()
    }
    
    private func updateVoiceLayout() {
        let bubbleWidth = cmodel.isOutgoing ? bubbleViewR.frame.width : bubbleViewL.frame.width
//        let contentX: CGFloat = cmodel.isOutgoing ? bubbleViewR.frame.origin.x : bubbleViewL.frame.origin.x
        
        // 播放按钮布局
        playButton.frame = CGRect(
            x: 12,
            y: (bubbleViewL.frame.height - 24) / 2,
            width: 24,
            height: 24
        )
        
        // 波形图布局
        waveformView.frame = CGRect(
            x: 40,
            y: (bubbleViewL.frame.height - 6) / 2,
            width: bubbleWidth - 100,
            height: 6
        )
        
        // 时长标签布局
        durationLabel.frame = CGRect(
            x: waveformView.frame.maxX + 8,
            y: (bubbleViewL.frame.height - 20) / 2,
            width: 60,
            height: 20
        )
        
        bubbleViewL.addSubview(playButton)
        bubbleViewL.addSubview(waveformView)
        bubbleViewL.addSubview(durationLabel)
        
        // 根据消息方向调整元素位置
        if cmodel.isOutgoing {
            
            bubbleViewR.addSubview(playButton)
            bubbleViewR.addSubview(waveformView)
            bubbleViewR.addSubview(durationLabel)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateVoiceLayout()
    }
}
