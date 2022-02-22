//
//  PhotoCell.swift
//  PictureSelector
//
//  Created by liugq on 2021/8/6.
//

import Photos
import SnapKit
import UIKit

private let selectButtonMargin = 3
private let selectButtonWidth = 25

private let observerKey_isSelected = "isSelected"
private let observerKey_thumImage = "thumImage"


class PhotoCell: UICollectionViewCell {
    public var downloadBlock: ((_ model: PhotoModel) -> Void)?
    var selectButton = UIButton()
    var timeLabel = UILabel()
    var imageView = UIImageView()
    var model: PhotoModel? {
        didSet {
            addObserver()
            refreshUI()
        }
    }
    
    func addObserver(){
        model?.addObserver(self, forKeyPath: observerKey_isSelected, options: .new, context: nil)
        model?.addObserver(self, forKeyPath: observerKey_thumImage, options: .new, context: nil)
    }
    
    func removeObserver(){
        model?.removeObserver(self, forKeyPath: observerKey_thumImage)
        model?.removeObserver(self, forKeyPath: observerKey_isSelected)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    func configureUI(){
        addSubview(imageView)
        addSubview(selectButton)
        addSubview(timeLabel)
        
        timeLabel.textAlignment = .right
        timeLabel.textColor = .white
        timeLabel.font = UIFont.systemFont(ofSize: 13)
        
        selectButton.setImage(Util.image("btn-check-normal"), for: .normal)
        selectButton.addTarget(self, action: #selector(selectAction), for: .touchUpInside)
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        selectButton.snp.makeConstraints { make in
            make.top.equalTo(imageView).offset(selectButtonMargin)
            make.trailing.equalTo(imageView).offset(-selectButtonMargin)
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
        return "FAQAddPhotoCellReuseIdentifier"
    }
    
    deinit {
        removeObserver()
    }
    
    @objc func selectAction() {
        if downloadBlock != nil, model != nil {
            downloadBlock!(model!)
        }
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == observerKey_isSelected {
            refreshSelectView()
        } else if keyPath == observerKey_thumImage {
            loadThumImage()
        }
    }
    
    func refreshUI() {
        refreshSelectView()
        timeLabel.isHidden = !(model?.mediaType == .video)
        timeLabel.text = model?.duration
        if (model?.thumImage) != nil {
            loadThumImage()
        } else {
            model?.updataThumimage(self.bounds.size)
        }
    }
    
    func loadThumImage(){
        DispatchQueue.main.async {
            self.imageView.image = self.model?.thumImage
        }
    }
    
    func refreshSelectView() {
        var iconName = "btn-check-normal"
        if self.model?.isSelected == true {
            iconName = "btn-check-selected"
        }
        DispatchQueue.main.async {
            self.selectButton.setImage(Util.image(iconName), for: .normal)
        }
    }
}
