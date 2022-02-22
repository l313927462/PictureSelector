//
//  PhotoManager.swift
//  PictureSelector
//
//  Created by liugq on 2022/2/13.
//

import UIKit
import Photos
import PhotosUI

class PhotoManager: NSObject {
    /// 资源库所有的图片 、视频
    public var dataSource = [PhotoModel]()
    weak var delegate: DatasourceChangeDelegate?
    public var selectedArray = [PhotoModel]()
    @objc dynamic var isIcloudLoading = false
    private var fetchResult = PHFetchResult<PHAsset>()
    
    var fetchAllOption: PHFetchOptions {
        let option: PHFetchOptions = PHFetchOptions()
        option.includeAssetSourceTypes = .typeUserLibrary
        option.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        return option
    }
    required override init() {
        super.init()
    }
    
    
    func fetchAllPhotos()  {
        fetchResult = PHAsset.fetchAssets(with: fetchAllOption)
        dataSource = creatDatasource(fetchResult)
        delegate?.reloadAll()
    }
    
    func creatDatasource(_ fetchResult: PHFetchResult<PHAsset>) ->[PhotoModel] {
        var addedIdentifierDictionary = [String: Int]()
        for  i in (0..<selectedArray.count).reversed() {
            let item = selectedArray[i]
            if let id = item.asset?.localIdentifier {
                addedIdentifierDictionary[id] = i
            } else {
                selectedArray.remove(at: i)
            }
        }
        
        var modelArray = [PhotoModel]()
        
        for i in 0 ..< fetchResult.count{
            let model = PhotoModel()
            let asset = fetchResult[i]
            model.asset = asset
            model.name = asset.value(forKey: "filename") as? String ?? String()
            if addedIdentifierDictionary.isEmpty == false,
               let id = model.asset?.localIdentifier,
               addedIdentifierDictionary.keys.contains(id) {
                model.isSelected = true
                let selectIndex = addedIdentifierDictionary[id]
                let selectModel = selectedArray[selectIndex!]
                model.data = selectModel.data
                model.avAsset = selectModel.avAsset
                selectedArray[selectIndex!] = model
            }
            if model.mediaType == .video || model.mediaType == .image {
                if model.mediaType == .video {
                    model.duration = PhotoTool.dealWith(duration: asset.duration)
                }
            }
            modelArray.append(model)
        }
        return modelArray
    }
    
    

    
    func downloadFormIcloud(_ model: PhotoModel) {
        if dataSource.contains(model) {
            if model.isSelected  == true {
                model.isSelected = false
                if let index = self.selectedArray.firstIndex(of: model) {
                    self.selectedArray.remove(at: index)
                }
                return
            } else {
                
                DispatchQueue.global().async {
                    if let asset = model.asset {
                        print("model.locallyAvailable     ====\(model.locallyAvailable)")
                        if model.locallyAvailable == false {
                            self.isIcloudLoading = true
                        }
                        if model.mediaType == .image {
                        
                            let option = PHImageRequestOptions()
                            option.isNetworkAccessAllowed = true
                            PHImageManager.default().requestImageData(for: asset, options: option) { imageData, string, orientation, infoDic in
                                if self.isIcloudLoading {
                                    self.isIcloudLoading = false
                                }
                                model.data = imageData ?? Data()
                                if imageData?.isEmpty == false, self.dataSource.contains(model) {
                                    model.isSelected = true
                                    self.selectedArray.append(model)
                                }
                            }
                        } else if model.mediaType == .video {
                            let option = PHVideoRequestOptions()
                            option.isNetworkAccessAllowed = true
                            PHImageManager.default().requestAVAsset(forVideo: asset, options: option) { avasset, audiomix, infoDic in
                                if self.isIcloudLoading {
                                    self.isIcloudLoading = false
                                }
                                model.avAsset = avasset
                                if let path: URL = avasset?.value(forKey: "URL") as? URL {
                                    if let data = NSData(contentsOf: path) ,self.dataSource.contains(model) {
                                        model.data = data as Data
                                        model.isSelected = true
                                        self.selectedArray.append(model)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
   //MARK: -libraryChanged
    func libraryChanged(_ changeInstance: PHChange) {
        let newResult = PHAsset.fetchAssets(with: fetchAllOption)
        guard let changeDetails = changeInstance.changeDetails(for: fetchResult)else {
            return
        }
        
        if changeDetails.hasMoves {
            return
        }
        
        let fetchResult = changeDetails.fetchResultAfterChanges
        if let removeIndexs = changeDetails.removedIndexes,removeIndexs.count > 0 {
            print("删除 : \(removeIndexs)")
            //  删除
            for index in removeIndexs {
                if index >= 0, index < self.dataSource.count {
                    let model = dataSource[index]
                    if model.isSelected ,selectedArray.contains(model) {
                        self.selectedArray.remove(at: selectedArray.firstIndex(of: model)!)
                    }
                }
            }
            dataSource = creatDatasource(fetchResult)
            delegate?.reloadAll()
        } else if let changedIndexs = changeDetails.changedIndexes,changedIndexs.count > 0 {
            // 改变
            print("改变 : \(changedIndexs)")
            var rows = [IndexPath]()
            let newDatasource = creatDatasource(fetchResult)
            for index in changedIndexs {
                if index >= 0, index < dataSource.count {
                    if dataSource[index].isSelected {
                        continue
                    }
                    dataSource[index] = newDatasource[index]
                    print(dataSource[index])
                    rows.append(IndexPath.init(row: index, section: 0))
                }
            }
            delegate?.reload(rows)
        } else if let addedInddexs = changeDetails.insertedIndexes,addedInddexs.count > 0 {
            // 新增
            print("新增 : \(addedInddexs)")
            dataSource = creatDatasource(fetchResult)
            delegate?.reloadAll()
        }
    }
}

@objc protocol DatasourceChangeDelegate {
    
    func reloadAll()
    
    func reload(_ rows: [IndexPath])
}
