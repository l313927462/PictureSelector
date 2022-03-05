//
//  PhotoPickerview.swift
//  PictureSelector
//
//  Created by liugq on 2021/8/8.
//

import SnapKit
import UIKit
import PictureSelector


public class PhotoPickerView: UIView,UICollectionViewDelegate,UICollectionViewDataSource{
    var config = SelectorConfiguration()
    
    public var addedArray: [PhotoModel] = []
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize.init(width: 80, height: 80)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.register(AddedCell.self, forCellWithReuseIdentifier: AddedCell.reuseID())
        
        addSubview(self.collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var collectionView: UICollectionView!
    
    func refreshData() {
        collectionView.reloadData()
    }
    
    func jumpToSelector(){
        config.maxSelectCount = 9
        PhotoPickerService.toSelect(config, self.addedArray) { [self] resultArray in
            self.addedArray = resultArray
            refreshData()
        }
    }
}


// MARK: - UICollectionViewDelegate
extension PhotoPickerView {
    public func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        if addedArray.count >= config.maxSelectCount {
            return Int(config.maxSelectCount)
        }
        return addedArray.count + 1
    }
        
    

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: AddedCell = collectionView.dequeueReusableCell(withReuseIdentifier: AddedCell.reuseID(), for: indexPath) as? AddedCell ?? AddedCell()
        if indexPath.row < addedArray.count{
            cell.model = addedArray[indexPath.row]
        } else {
            cell.model = nil
        }
        cell.backgroundColor = .yellow
        cell.deleteBlock = { mod in
            self.addedArray.remove(at: self.addedArray.firstIndex(of: mod)!)
            self.refreshData()
        }
        return cell
    }
    
    public func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row >= addedArray.count {
            jumpToSelector()
        } else {
            
        }
    }
}
