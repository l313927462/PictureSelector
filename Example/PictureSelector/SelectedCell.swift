//
//  AddedCell.swift
//  PictureSelector
//
//  Created by liugq on 2021/8/8.
//

import UIKit
import PictureSelector
private let selectButtonMargin = 3
private let selectButtonWidth = 25
class AddedCell: UICollectionViewCell {
    public var deleteBlock: ((_ model: PhotoModel) -> Void)?
    var selectButton = UIButton()
    var timeLabel = UILabel()
    var imageView = UIImageView()
    var model: PhotoModel? {
        didSet {

            guard  model != nil  else {
                timeLabel.isHidden = true
                selectButton.isHidden = true
                imageView.image =  UIImage.init(named:"add_icon")
                return
            }
            
            timeLabel.isHidden = !(model?.mediaType == .video)
            timeLabel.text = model?.duration
            selectButton.isHidden = false
            imageView.image =  model?.thumImage
            
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(selectButton)
        addSubview(timeLabel)

//        timeLabel.backgroundColor = .groupTableViewBackground
        timeLabel.textAlignment = .right
        timeLabel.textColor = .white
        timeLabel.font = UIFont.systemFont(ofSize: 13)

        selectButton.setImage( UIImage.init(named:"compose_photo_close"), for: .normal)
        selectButton.imageView?.contentMode = .scaleToFill
        selectButton.addTarget(self, action: #selector(deletAction), for: .touchUpInside)

        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        selectButton.snp.makeConstraints { make in
            make.top.equalTo(imageView)
            make.trailing.equalTo(imageView)
            make.width.height.equalTo(selectButtonWidth)
        }
        timeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
            make.height.equalTo(20)
            make.bottom.equalToSuperview()
        }
        
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public static func reuseID() -> String {
        return "FAQAddedImageCellReuseIdentifier"
    }

    @objc func deletAction() {
        deleteBlock!(model!)
    }
}
