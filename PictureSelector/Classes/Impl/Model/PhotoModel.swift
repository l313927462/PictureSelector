//
//  PhotoModel.swift
//  PictureSelector
//
//  Created by liugq on 2021/8/6.
//

import Photos
import UIKit



public class PhotoModel: NSObject {
    var name: String = ""
    var formatName: String = ""
    var asset: PHAsset?
    var avAsset: AVAsset?
    @objc dynamic var isSelected: Bool = false
    var locallyAvailable: Bool {
        get {
            guard let phasset = asset else {
                return false
            }
            
            let info = PHAssetResource.assetResources(for: phasset)
            if let firstObj = info.first, let isLocalAvailabel: Bool = firstObj.value(forKey: "locallyAvailable") as? Bool {
                return  isLocalAvailabel
            }
            return false
        }
    }
    var mediaType: PHAssetMediaType? {
        return asset?.mediaType
    }
    var identifier: String? {
        return asset?.localIdentifier
    }
    
    var duration: String = ""
    @objc dynamic var thumImage: UIImage?

    var previewImage: UIImage? {
        return UIImage.init(data: self.data)
    }
    /// 用于视频预览
    var playItem: AVPlayerItem?
    /// 视频 or 图片的真实数据
    var data = Data()
    /// 视频 or 图片数据的 大小，单位MB
    var sizeOfMb:CGFloat {
        get {
            return CGFloat(data.count) / (1024*1024)
        }
    }

    
    
    public func updataThumimage(_ targetSize: CGSize) {
        
        guard let requestAsset = asset else {
            print("asset is nil --------")
            return
        }
        let option = PHImageRequestOptions()
        option.isNetworkAccessAllowed = true
        PHImageManager.default().requestImage(for: requestAsset, targetSize: targetSize, contentMode: .aspectFill, options: option, resultHandler: { image, _ in
            self.thumImage = image
        })
    }
    
    public func isSupportedForat() -> Bool {
        let upperName = name.uppercased()
        let formats = ["PNG", "JPG", "JPEG", "MOV", "MP4", "WAVI"]
        for item in formats {
            if upperName.hasSuffix(item) {
                return true
            }
        }
        return false
    }
}
