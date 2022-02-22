//
//  Util.swift
//  PictureSelector
//
//  Created by liugq on 2022/1/13.
//

import Foundation
import UIKit

extension UIImage {
    static func image(_ named: String) -> UIImage? {
        return UIImage(named: named, in: mybundle(), compatibleWith: nil)
    }
    
    static func mybundle() -> Bundle? {
        let bundle = Bundle(for: PhotoPickerView.self)
        let path = bundle.path(forResource: "PictureSelector", ofType: "bundle")
        return Bundle(path: path ?? "")
    }
}


class Util {
    static func image(_ named: String) -> UIImage? {
        return UIImage(named: named, in: mybundle(), compatibleWith: nil)
    }
    
    static func mybundle() -> Bundle? {
        let bundle = Bundle(for: PhotoPickerView.self)
        let path = bundle.path(forResource: "PictureSelector", ofType: "bundle")
        return Bundle(path: path ?? "")
    }
}

