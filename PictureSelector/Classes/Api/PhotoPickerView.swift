//
//  PhotoPickerview.swift
//  PictureSelector
//
//  Created by liugq on 2021/8/8.
//

import SnapKit
import UIKit

public struct PhotoPickerConfiguration {
    var columnCount: Int64 = 4
    var itemSpace:CGFloat = 2
    var maxSelectImageCount = 4
    var maxSelectViodeoCount = 0
    
    /// 单个照片大小限制 （单位：MB）
    var photoDataMaxSize = 5
    /// 单个视频大小限制 （单位：MB）
    var videoDataMaxSize = 100
    
    var itemWidth:CGFloat {
        get {
            return (CGFloat(UIScreen.main.bounds.size.width) - itemSpace * CGFloat((columnCount - 1))) / CGFloat( Float(columnCount))
        }
    }
}




public class PhotoPickerView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    var pickerConfig = PhotoPickerConfiguration()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    
    public convenience init(_ frame:CGRect, _ config: PhotoPickerConfiguration?) {
       
        self.init(frame: frame)
        if let customConfig = config {
            pickerConfig = customConfig
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        addSubview(collectionView)
        collectionView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
      
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: pickerConfig.itemWidth, height: pickerConfig.itemWidth)
        layout.minimumLineSpacing = pickerConfig.itemSpace
        layout.minimumInteritemSpacing = pickerConfig.itemSpace
        let collectView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectView.showsVerticalScrollIndicator = true
        collectView.backgroundColor = .clear
        collectView.register(AddedCell.self, forCellWithReuseIdentifier: AddedCell.reuseID())
        return collectView
    }()
    
//    public var clickAdd: (() -> Void)?
    
    public func refreshData() {
        collectionView.reloadData()
    }
    
    public var addedPhotos: [PhotoModel] = [PhotoModel()]
    
   
    

}


// MARK: - UICollectionViewDelegate
extension PhotoPickerView {
    
    public func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return addedPhotos.count >= 4 ? 4 : addedPhotos.count
    }
    
    

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: AddedCell = collectionView.dequeueReusableCell(withReuseIdentifier: AddedCell.reuseID(), for: indexPath) as? AddedCell ?? AddedCell()
        cell.model = addedPhotos[indexPath.row]
        cell.backgroundColor = .yellow
        cell.deleteBlock = { mod in
            self.addedPhotos.remove(at: self.addedPhotos.index(of: mod)!)
            self.refreshData()
        }
        return cell
    }
    
    public func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if addedPhotos[indexPath.row].asset != nil {
            
        } else {
            print("jump ----")
            let controller = PhotoListController()
            let navController = UINavigationController(rootViewController: controller)
            controller.modalPresentationStyle = .fullScreen

            var selectArray = addedPhotos
            selectArray.removeLast()
            controller.completeBlock = { photos in

                print(photos.count)
                let lastModel = self.addedPhotos.last
                self.addedPhotos = photos
                self.addedPhotos.append(lastModel!)
                self.collectionView.reloadData()
            }
            
            if let vc = ControllerHelper.currentController(){
                navController.modalPresentationStyle = .fullScreen
                var array = addedPhotos
                array.removeLast()
                controller.lastAddedArray = array
                print(array.count)
                vc.present(navController, animated: true, completion: nil)
            } else {
                print("current controller is nil ... ")
            }
            
        }
    }
}
