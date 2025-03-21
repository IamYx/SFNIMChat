//
//  ImageMessageCellTableViewCell.swift
//  NIMSDKSwift
//
//  Created by 姚肖 on 2025/3/17.
//

import UIKit

class ImageMessageCellTableViewCell: MessageCellTableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private lazy var messageImgL: UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    private lazy var messageImgR: UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        bubbleViewL.addSubview(messageImgL)
        bubbleViewR.addSubview(messageImgR)
    }
    
    override func configure(model: MessageModel) {
        super.configure(model: model)
        
        let width = model.messageSize?.width ?? 0
        let height = model.messageSize?.height ?? 0
        
        messageImgL.frame = CGRect(x: 10, y: 8, width: width, height: height)
        messageImgR.frame = CGRect(x: bubbleViewR.bounds.size.width - 10 - width, y: 8, width: width, height: height)
        
        if (model.isOutgoing) {
            messageImgL.isHidden = true
            messageImgR.isHidden = false
            
            if (model.imageUrl.contains("http")) {
                messageImgR.sd_setImage(with: URL(string: model.imageUrl))
            } else {
                messageImgR.image = UIImage(contentsOfFile: model.imageUrl)
            }
        } else {
            messageImgR.isHidden = true
            messageImgL.isHidden = false
            
            if (model.imageUrl.contains("http")) {
                messageImgL.sd_setImage(with: URL(string: model.imageUrl))
            } else {
                messageImgL.image = UIImage(contentsOfFile: model.imageUrl)
            }
        }
        
    }

}
