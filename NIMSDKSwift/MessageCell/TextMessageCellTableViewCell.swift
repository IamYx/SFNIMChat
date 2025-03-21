//
//  TextMessageCellTableViewCell.swift
//  NIMSDKSwift
//
//  Created by 姚肖 on 2025/3/17.
//

import UIKit

class TextMessageCellTableViewCell: MessageCellTableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private lazy var messageLabelL: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var messageLabelR: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        bubbleViewL.addSubview(messageLabelL)
        bubbleViewR.addSubview(messageLabelR)
    }
    
    override func configure(model: MessageModel) {
        
        super.configure(model: model)
        
        let width = model.messageSize?.width ?? 0
        let height = model.messageSize?.height ?? 0
        
        messageLabelL.frame = CGRect(x: 10, y: 8, width: width, height: height)
        
        messageLabelR.frame = CGRect(x: bubbleViewR.bounds.size.width - 10 - width, y: 8, width: width, height: height)
        
        if (model.isOutgoing) {
            messageLabelL.isHidden = true
            messageLabelR.isHidden = false
            
            messageLabelR.text = model.text
            messageLabelR.textColor = .white
            
        } else {
            messageLabelR.isHidden = true
            messageLabelL.isHidden = false
            
            messageLabelL.text = model.text
            messageLabelL.textColor = .black
        }
        
    }

}
