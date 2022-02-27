//
//  PhotoPickerview.swift
//  PictureSelector
//
//  Created by liugq on 2021/8/8.
//

import SnapKit
import UIKit






public class PhotoPickerView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    var config = SelectorConfiguration()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    public convenience init(_ frame:CGRect, itemSize: CGSize, itemSpace: CGFloat = 1, selectorConfig: SelectorConfiguration? = nil) {
       
        self.init(frame: frame)
        if let customConfig = selectorConfig {
            config = customConfig
        }
        
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = itemSize
        layout.minimumLineSpacing = itemSpace
        layout.minimumInteritemSpacing = itemSpace
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
    
//    public var clickAdd: (() -> Void)?
    
    public func refreshData() {
        collectionView.reloadData()
    }
    
    public var addedPhotos: [PhotoModel] = [PhotoModel()]
    
   

}


// MARK: - UICollectionViewDelegate
extension PhotoPickerView {
    
    public func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return Int((addedPhotos.count >= config.maxSelectCount) ?  Int(config.maxSelectCount) : addedPhotos.count)
    }
        
    

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: AddedCell = collectionView.dequeueReusableCell(withReuseIdentifier: AddedCell.reuseID(), for: indexPath) as? AddedCell ?? AddedCell()
        cell.model = addedPhotos[indexPath.row]
        cell.backgroundColor = .yellow
        cell.deleteBlock = { mod in
            self.addedPhotos.remove(at: self.addedPhotos.firstIndex(of: mod)!)
            self.refreshData()
        }
        return cell
    }
    
    public func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if addedPhotos[indexPath.row].asset != nil {
            
        } else {
            print("jump ----")
            let controller = PhotoListController.init(config)
            let navController = UINavigationController(rootViewController: controller)
            controller.modalPresentationStyle = .fullScreen

            var selectArray = addedPhotos
            selectArray.removeLast()
            controller.completeBlock = { photos in
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
                vc.present(navController, animated: true, completion: nil)
            } else {
                print("current controller is nil ... ")
            }
            
        }
    }
}
