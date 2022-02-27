//
//  PhotoPickerService.swift
//  PictureSelector
//
//  Created by liugq on 2022/1/13.
//

import Foundation


enum SelectMediaType {
    case photo
    case video
    case all
}

public struct SelectorConfiguration {
    
    var selctType: SelectMediaType = .photo

    var maxSelectCount: UInt = 4
    /// unit: MB
    var singlePhotoMaxSize: CGFloat?
    /// unit: MB
    var sigleVideoMaxSize: CGFloat?
    /// unit: Second
    var singleVideoMaxDuration: Int?
    /// Which format is supported，such as  : [PNG, JPEG, MP4, ....]
    var availableFormats = [String]()
    
    /// The number of columns per row in the  selector
    var numberOfColumnsInSelector: UInt = 4
}



public struct PhotoPickerService {
    
    func initPhotoPickerView(_ : SelectorConfiguration) -> PhotoPickerView {
        PhotoPickerView.init()
    }
}
