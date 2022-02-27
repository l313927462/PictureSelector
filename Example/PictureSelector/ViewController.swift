//
//  ViewController.swift
//  PictureSelector
//
//  Created by 313927462@qq.com on 02/22/2022.
//  Copyright (c) 2022 313927462@qq.com. All rights reserved.
//

import UIKit
import Photos
import SnapKit
import PictureSelector

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        test()
        
    }
    
    
    
    func test() {
        let library = PHPhotoLibrary.authorizationStatus()
        if library == PHAuthorizationStatus.denied ||
            library == PHAuthorizationStatus.restricted ||
            library == PHAuthorizationStatus.notDetermined
        {
            print("没有权限")
        } else {
            print("有权限")
        }
        
        if #available(iOS 14, *) {
            // 查询权限
            let level = PHAccessLevel.readWrite
            
            let status = PHPhotoLibrary.authorizationStatus(for: level)
            switch status {
            case .limited:
                NSLog("limited")
            case .denied:
                NSLog("denied")
            case .authorized:
                NSLog("authorized")
            default:
                break
            }
        }
        
        let photoView = PhotoPickerView.init(.zero, itemSize: CGSize.init(width: 80, height: 80))
        view.addSubview(photoView)
        photoView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.height.equalTo(280)
            make.top.equalTo(100)
            make.trailing.equalToSuperview()
        }
    }
    
    // 判断是否授权
    func isAuthorized() -> Bool {
        return PHPhotoLibrary.authorizationStatus() == .authorized ||
        PHPhotoLibrary.authorizationStatus() == .notDetermined
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

