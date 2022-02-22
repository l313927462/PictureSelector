//
//  PhotoTool.swift
//  PictureSelector
//
//  Created by liugq on 2021/8/7.
//

import UIKit

class PhotoTool: NSObject {
    public static func dealWith(duration: TimeInterval) -> String {
        var time = String()
        if duration < 60 {
            time = String(format: "00:%02d", Int(duration))
        } else {
            let min = Int(duration) / 60
            let sec = Int(duration) % 60
            let hour = Int(min) / 60

            if hour > 0 {
                time = String(format: "%d:%02d:%02d", hour, min, sec)
            } else if min > 0 {
                time = String(format: "%d:%02d", min, sec)
            }
        }
        return time
    }
}
