//
//  MessageCellTableViewCell.swift
//  NIMSDKSwift
//
//  Created by 姚肖 on 2025/3/17.
//

import UIKit

class MessageCellTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    lazy var bubbleViewL: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        return view
    }()
    
    lazy var bubbleViewR: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        return view
    }()
    
    lazy var nameLabelL: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = 12
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .lightGray
        return label
    }()
    
    lazy var nameLabelR: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = 12
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .lightGray
        label.textAlignment = .right
        return label
    }()
    
    lazy var statusView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(bubbleViewL)
        contentView.addSubview(bubbleViewR)
        contentView.addSubview(statusView)
        contentView.addSubview(nameLabelL)
        contentView.addSubview(nameLabelR)
        
        bubbleViewL.frame = CGRect(x: 10, y: 8, width: 100, height: 40)
        bubbleViewR.frame = CGRect(x: UIScreen.main.bounds.size.width - 110, y: 8, width: 100, height: 40)
    }
    
    func configure(model: MessageModel) {
        
        let width = model.messageSize?.width ?? 0
        let height = model.messageSize?.height ?? 0
        
        nameLabelL.frame = CGRect(x: 10, y: 5, width: 100, height: 20)
        bubbleViewL.frame = CGRect(x: 10, y: 28, width: width + 20, height: height + 16)
        nameLabelR.frame = CGRect(x: UIScreen.main.bounds.size.width - 15 - 100, y: 5, width: 100, height: 20)
        bubbleViewR.frame = CGRect(x: UIScreen.main.bounds.size.width - 30 - width, y: 28, width: width + 20, height: height + 16)
        
        nameLabelL.text = model.senderName
        nameLabelR.text = model.senderName
        
        if (model.isOutgoing) {
            bubbleViewL.isHidden = true
            bubbleViewR.isHidden = false
            bubbleViewR.backgroundColor = .systemBlue
            nameLabelL.isHidden = true
            nameLabelR.isHidden = false
        } else {
            bubbleViewR.isHidden = true
            bubbleViewL.isHidden = false
            bubbleViewL.backgroundColor = .systemGray5
            nameLabelL.isHidden = false
            nameLabelR.isHidden = true
        }
        
        statusView.isHidden = true
        statusView.delBreathAnimation()
        if (model.messageSendStatus == 1) {
            statusView.isHidden = false
            statusView.frame = CGRect(x: bubbleViewR.frame.origin.x - 15, y: 28, width: 10, height: 10)
            statusView.backgroundColor = .orange
            statusView.addBreathAnimation()
        } else if (model.messageSendStatus == 0) {
            statusView.isHidden = false
            statusView.frame = CGRect(x: bubbleViewR.frame.origin.x - 15, y: 8, width: 10, height: 10)
            statusView.backgroundColor = .red
        }
        
    }

}
